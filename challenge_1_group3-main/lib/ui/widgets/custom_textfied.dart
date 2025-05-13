import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final int? maxLine;
  final bool required;
  final bool showLabel;
  final bool readOnly;
  final bool password;
  final int? length;
  final double verticalPadding;
  final TextInputType inputType;
  final Function? onValidate;
  final ValueChanged? onChanged;
  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.required = false,
    this.maxLine = 1,
    this.readOnly = false,
    this.verticalPadding = 13,
    this.inputType = TextInputType.text,
    this.onValidate,
    this.showLabel = false,
    this.password = false,
    this.length,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLine,
      controller: controller,
      style: CustomTextStyle.title13Regular,
      cursorColor: Colors.black,
      cursorHeight: 12,
      obscureText: password,
      maxLength: length,
      validator: (v) {
        if (v!.isEmpty && required) return "$hintText is required*";
        if (onValidate != null) return onValidate!(v);
        return null;
      },
      onChanged: onChanged,
      readOnly: readOnly,
      keyboardType: inputType,
      decoration: InputDecoration(
          counterText: length != null && length == 500 ? null : '',
          labelStyle: CustomTextStyle.title13Regular
              .copyWith(color: CustomTheme.black.withValues(alpha: .5)),
          labelText: showLabel ? hintText : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: CustomTheme.black.withValues(alpha: .1),
                width: .5), // Removes border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: CustomTheme.accentColor, width: 1), // Removes border
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: CustomTheme.black.withValues(alpha: .1),
                width: .5), // Removes border
          ),
          filled: true,
          fillColor: CustomTheme.textField,
          hintStyle: CustomTextStyle.title13Regular
              .copyWith(color: CustomTheme.black.withValues(alpha: .5)),
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15, vertical: verticalPadding),
          hintText: hintText),
    );
  }
}
