import 'package:flutter/material.dart';

class WMicroEditor extends StatefulWidget {
  const WMicroEditor(
      {this.label = '',
      required this.value,
      required this.onChanged,
      this.width = 50,
      this.height = 20,
      this.fontSize = 10,
      Key? key})
      : super(key: key);

  final String label;
  final String value;
  final Function(String) onChanged;
  final double width;
  final double height;
  final double fontSize;

  @override
  State<WMicroEditor> createState() => _WMicroEditorState();
}

class _WMicroEditorState extends State<WMicroEditor> {
  TextEditingController controller = TextEditingController();

  listener() {
    widget.onChanged(controller.text);
  }

  @override
  void initState() {
    controller.text = widget.value;
    controller.addListener(listener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.label.isNotEmpty)
          Text(
            '${widget.label}:',
            style: TextStyle(fontSize: widget.fontSize),
          ),
        SizedBox(
          width: widget.width,
          height: widget.height,
          // color: Colors.yellow,
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: widget.fontSize),
            controller: controller,
            keyboardType: TextInputType.number,
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.right,
            strutStyle: StrutStyle(
              fontSize: widget.fontSize,
            ),
          ),
        ),
      ],
    );
  }
}
