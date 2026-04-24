import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/widget/flutter_single_select.dart';
import '../translations.dart';

const _ = translationOf;


class Select<T> extends StatefulWidget {
  const Select(this.title, this.label, this.value, this.options, this.callback,
      {this.height = 30,
      this.width = 200,
      this.allOptionText,
      this.doneButtonText,
      this.cancelButtonText,
      Key? key})
      : super(key: key);

  final String title;
  final String label;
  final String? allOptionText;
  final String? doneButtonText;
  final String? cancelButtonText;
  final T? value;
  final List<T> options;
  final Function(T) callback;
  final double height;
  final double width;

  @override
  State<Select<T>> createState() => _SelectState<T>();
}

class _SelectState<T> extends State<Select<T>> {
  T? _value;

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
        allOptionText: widget.allOptionText ?? _('All'),
        doneButtonText: widget.doneButtonText ?? _('Done'),
        cancelButtonText: widget.cancelButtonText ?? _('Cancel'),
      ),
    );
  }
}
