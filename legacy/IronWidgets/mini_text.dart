import 'package:flutter/material.dart';

class MiniText extends StatefulWidget {
  const MiniText(
    this.text, {
    this.width,
    this.margin,
    this.fontSize,
    this.color,
    Key? key,
  }) : super(key: key);

  final String text;
  final double? width;
  final double? margin;
  final double? fontSize;
  final Color? color;

  @override
  State<MiniText> createState() => _MiniTextState();
}

class _MiniTextState extends State<MiniText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: widget.margin == null ? null : EdgeInsets.all(widget.margin!),
      child: Text(
        widget.text,
        style: TextStyle(fontSize: widget.fontSize ?? 10, color: widget.color),
        textAlign: widget.text.isEmpty
            ? TextAlign.left
            : '-1023456789'.contains(widget.text[0])
                ? TextAlign.right
                : TextAlign.left,
      ),
    );
  }
}
