import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color? textColor;
  final bool loading;
  const PrimaryButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.textColor,
      required this.color,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        splashColor: CustomTheme.white,
        elevation: 0.0,
        height: 45,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: color,
        disabledColor: CustomTheme.black.withValues(alpha: .3),
        onPressed: loading ? null : onPressed,
        child: loading
            ? SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: CustomTheme.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style:
                    CustomTextStyle.title13Regular.copyWith(color: textColor),
              ));
  }
}
