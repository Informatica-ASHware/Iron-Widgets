import 'package:flutter/material.dart';

import 'label.dart';

class Editor extends StatefulWidget {
  const Editor(
    this.label,
    this.text,
    this.callback, {
    this.width = 240,
    this.lines = 1,
    Key? key,
    this.password = false,
    this.labelOnTop = false,
  }) : super(key: key);

  final String label;
  final String text;
  final Function(String) callback;
  final double width;
  final int lines;
  final bool password;
  final bool labelOnTop;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  TextEditingController controller = TextEditingController();

  void listener() {
    widget.callback(controller.text);
  }

  @override
  void initState() {
    controller.text = widget.text;
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
    List<Widget> children = [
      Label(widget.label),
      Container(
        width: widget.width,
        height: widget.lines == 1 ? 30 : widget.lines * 15,
        //widget.lines == 1 ? 30 : widget.lines * 20,
        margin: EdgeInsets.zero,
        // color: Colors.red,
        child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
            ),
            maxLines: widget.lines,
            obscureText: widget.password,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
    ];
    return Container(
      width: widget.width,

      // margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      // color: Colors.yellow,
      height: //(widget.lines * 30) + (widget.labelOnTop ? 20 : 0),
          (widget.lines == 1 ? 40 : (widget.lines * 18)) +
              (widget.labelOnTop ? 20 : 0),
      child: widget.labelOnTop
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
      // child: ListView(
      //   primary: false,
      //   scrollDirection: widget.labelOnTop ? Axis.vertical : Axis.horizontal,
      //   children: children,
      // ),
    );
  }
}
