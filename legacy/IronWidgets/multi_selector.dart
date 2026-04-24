import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/widget/flutter_multi_select.dart';
import '../translations.dart';

const _ = translationOf;

class MultiSelector<T> extends StatefulWidget {
  const MultiSelector(
      this.title, this.label, this.value, this.options, this.callback,
      {this.height,
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
  final List<T> value;
  final List<T> options;
  final Function(List<dynamic>) callback;
  final double? height;
  final double width;

  @override
  State<MultiSelector<T>> createState() => _MultiSelectorState<T>();
}

class _MultiSelectorState<T> extends State<MultiSelector<T>> {
  late List<T> _value;

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
      child: CustomMultiSelectField<T>(
        items: widget.options,
        title: widget.title,
        initialValue: _value,
        onSelectionDone: (List value) {
          setState(() {
            _value.clear();
            _value.addAll(value.map((e) => e as T));
            // debugPrint('value: $_value');
          });
          widget.callback(value);
        },
        allOptionText: widget.allOptionText ?? _('All'),
        doneButtonText: widget.doneButtonText ?? _('Done'),
        cancelButtonText: widget.cancelButtonText ?? _('Cancel'),
        // onSelectionDone: (value) {
        //   setState(() {
        //     // _value = value;
        //   });
        //   // widget.callback(value as List<Object>);
        // },
        itemAsString: (item) => item.toString(),
      ),
    );
  }
}
