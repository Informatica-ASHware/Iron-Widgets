// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/widget/flutter_single_select.dart';
// import 'label.dart';

class Enum<T> extends StatefulWidget {
  const Enum(this.title, this.label, this.value, this.options, this.callback,
      {this.height = 30, this.width = 200, Key? key})
      : super(key: key);

  final String title;
  final String label;
  final T value;
  final List<T> options;
  final Function(T) callback;
  final double height;
  final double width;

  @override
  State<Enum<T>> createState() => _EnumState<T>();
}

class _EnumState<T> extends State<Enum<T>> {
  late T _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: widget.height,
      width: widget.width,
      // color: Colors.red,
      child: CustomSingleSelectField<T>(
        items: widget.options,
        title: widget.title,
        initialValue: _value,
        onSelectionDone: (value) {
          setState(() {
            _value = value;
          });
          widget.callback(value);
        },
        itemAsString: (item) => item,
      ),
    );
  }
}
