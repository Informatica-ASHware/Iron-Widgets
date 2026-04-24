import 'package:flutter/material.dart';
import 'label.dart';

class Check extends StatefulWidget {
  const Check(this.label, this.value, this.callback,
      {this.width = 200, Key? key})
      : super(key: key);

  final String label;
  final bool value;
  final Function(bool) callback;
  final double? width;

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  bool _value = false;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      color: Colors.transparent,
      child: Row(
        children: [
          if (widget.label.isNotEmpty) Label(widget.label),
          Checkbox(
            onChanged: (bool? value) {
              if (value != null) {
                widget.callback(value);
                setState(() {
                  _value = value;
                });
              }
            },
            value: _value,

          ),
        ],
      ),
    );
  }
}
