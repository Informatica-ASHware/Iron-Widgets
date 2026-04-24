import 'package:flutter/material.dart';

class Label extends StatefulWidget {
  const Label(
    this.text, {
    this.width,
    this.colon = true,
    Key? key,
  }) : super(key: key);

  final String text;
  final double? width;
  final bool colon;

  @override
  State<Label> createState() => _LabelState();
}

class _LabelState extends State<Label> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: widget.width,
      child: Text(
        '${widget.text}${widget.colon ? ':' : ''}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
