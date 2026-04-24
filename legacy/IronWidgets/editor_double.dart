import 'package:flutter/material.dart';

import 'label.dart';

class EditorDouble extends StatefulWidget {
  const EditorDouble(this.label, this.value, this.callback,
      {this.width = 240, this.lines = 1, Key? key})
      : super(key: key);

  final String label;
  final double value;
  final Function(double) callback;
  final double width;
  final int lines;

  @override
  State<EditorDouble> createState() => _EditorDoubleState();
}

class _EditorDoubleState extends State<EditorDouble> {
  TextEditingController controller = TextEditingController();

  void listener() {
    widget.callback(double.tryParse(controller.text) ?? 0);
  }

  @override
  void initState() {
    controller.text = widget.value.toString();
    controller.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: const EdgeInsets.all(2),
      height: widget.lines == 1 ? 30 : null,
      child: Row(
        children: [
          if (widget.label.isNotEmpty) Label(widget.label),
          Container(
            width: widget.width,
            margin: EdgeInsets.zero,
            child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                maxLines: widget.lines,
                style: const TextStyle(
                  fontSize: 14,
                )),
          ),
        ],
      ),
    );
  }
}
