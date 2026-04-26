import 'package:flutter/material.dart';

/// Key used in the result map returned by [CustomBottomSheetSelector.customBottomSheet].
const String selectedList = 'selection';

/// Default border colour for input fields.
final Color borderColor = const Color(0xFF35343E).withAlpha(26);

/// Default label colour.
final Color labelColor = Colors.black.withAlpha(112);

/// Default error colour.
const Color errorColor = Color(0xFFFF5858);

/// Default input field border radius.
const double borderRadius = 44;

/// Returns a [TextStyle] with sensible defaults, overridable per parameter.
TextStyle defaultTextStyle({
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.w400,
  String? fontFamily,
  TextDecoration decoration = TextDecoration.none,
  Color color = Colors.black,
  FontStyle fontStyle = FontStyle.normal,
}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: decoration,
      color: color,
      fontStyle: fontStyle,
    );

/// Returns a rounded [OutlineInputBorder].
InputBorder inputFieldBorder({Color? color}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(width: 1, color: color ?? borderColor),
    );
