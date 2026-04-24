import 'refresh_widget.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class WMicroSwitch extends StatefulWidget {
  const WMicroSwitch(this.text, this.value, this.onChanged,
      {this.width = 58, this.height = 22, this.message = '', Key? key})
      : super(key: key);

  final String text;
  final String message;
  final bool value;
  final Function(bool) onChanged;
  final double width;
  final double height;

  @override
  State<WMicroSwitch> createState() => _WMicroSwitchState();
}

class _WMicroSwitchState extends State<WMicroSwitch> {
  // bool value = false;

  @override
  void initState() {
    // value = widget.value;
    addRefreshLotWidget(wSil, () {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: widget.width,
      height: widget.height,
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.value ? gold : Colors.white,
        border: Border.all(
          color: gold,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 11,
            // color: value ? darkGray : darkRed,
            color: widget.value ? darkRed : darkGray,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (widget.message.isNotEmpty) {
      child = Tooltip(
        message: widget.message,
        child: child,
      );
    }

    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
        // setState(() => value = widget.value);
        // debugPrint('${widget.text}: widget.value: ${widget.value}');
      },
      child: child,
    );
  }
}
