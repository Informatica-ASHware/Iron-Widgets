import 'package:flutter/material.dart';

import '../utils/utils.dart';

/// A single tappable row inside the custom bottom-sheet selector.
class CustomBottomSheetButton extends StatelessWidget {
  const CustomBottomSheetButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.leading,
    this.buttonTextStyle,
    this.trailing,
  });

  /// Called when the row is tapped.
  final void Function()? onPressed;

  /// Optional widget shown before [buttonText].
  final Widget? leading;

  /// Optional widget shown after [buttonText].
  final Widget? trailing;

  /// The label for this row.
  final String buttonText;

  /// Override for the label text style.
  final TextStyle? buttonTextStyle;

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: onPressed,
        splashColor: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            children: [
              leading ?? const SizedBox.shrink(),
              SizedBox(width: leading != null ? 10 : 0),
              Expanded(
                child: Text(
                  buttonText,
                  style: buttonTextStyle ?? defaultTextStyle(),
                ),
              ),
              SizedBox(width: trailing != null ? 10 : 0),
              trailing ?? const SizedBox.shrink(),
            ],
          ),
        ),
      );
}
