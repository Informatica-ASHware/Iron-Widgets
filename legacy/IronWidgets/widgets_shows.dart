import 'w_micro_editor.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

double height = 20;
double fontSize = 10;
TextStyle baseStylePercent = const TextStyle(
  color: Colors.black,
  fontSize: 10,
  overflow: TextOverflow.fade,
);
TextStyle baseStyleValue = const TextStyle(
  color: Colors.black,
  fontSize: 10,
  fontWeight: FontWeight.bold,
  overflow: TextOverflow.fade,
);
TextStyle baseStyleLabel = const TextStyle(
  color: Colors.black,
  fontSize: 10,
  fontWeight: FontWeight.bold,
  overflow: TextOverflow.fade,
);
TextStyle baseStyleTitle = const TextStyle(
  color: Colors.black,
  fontSize: 12,
  overflow: TextOverflow.fade,
);
double widthInt = 20;
double widthValue = 60;
double widthPercent = 60;

show(
  String l,
  String v,
  double width,
  TextStyle styleLabel,
  TextStyle styleValue, {
  bool editable = false,
  Function(String)? callback,
}) {
  Widget value = Text(
    v,
    style: styleValue,
  );
  if (editable) {
    value = WMicroEditor(
      label: '',
      onChanged: callback ?? (value) {},
      value: v,
      width: 40,
      height: 14,
    );
  }
  return Container(
    width: width,
    height: height,
    color: Colors.white,
    margin: const EdgeInsets.all(2),
    padding: const EdgeInsets.all(1),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l,
          style: styleLabel,
        ),
        value,
      ],
    ),
  );
}

Widget showValuesColumn(
  String l1,
  String v1,
  String l2,
  String v2,
  double width,
  TextStyle styleLabel,
  TextStyle styleValue, {
  Color? background,
  bool editable = false,
  Function(String)? editableTop,
  Function(String)? editableBottom,
}) {
  return Container(
    color: background ?? gold,
    child: Column(
      children: [
        show(l1, v1, width, styleLabel, styleValue,
            editable: editable,
            callback: editableTop),
        show(l2, v2, width, styleLabel, styleValue,
            editable: editable,
            callback: editableBottom),
      ],
    ),
  );
}

Widget showPercColumn(
  String l1,
  String v1,
  String l2,
  String v2,
  double width,
  TextStyle styleLabel,
  TextStyle stylePercent, {
  Color? background,
  bool editable = false,
  Function(String)? editableTop,
  Function(String)? editableBottom,
}) {
  return Container(
    color: background ?? gold,
    child: Column(
      children: [
        show(l1, '$v1%', width, styleLabel, stylePercent,
            editable: editable,
            callback: editableTop),
        show(l2, '$v2%', width, styleLabel, stylePercent,
            editable: editable,
            callback: editableBottom),
      ],
    ),
  );
}
