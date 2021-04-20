import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles.dart';

class AppTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String initialValue;
  final bool isObscure;
  final IconData icon;
  final Widget trailing;
  final String Function(String) validator;
  final ValueChanged<String> onSave;
  final TextInputType keyboardType;
  final double borderRadius;
  final int maxLength;
  final String helperText;
  final String errorText;
  final double labelSize;
  final List<TextInputFormatter> formatters;
  final EdgeInsets margin;

  const AppTextFormField({
    Key key,
    this.label,
    this.controller,
    this.initialValue,
    this.isObscure = false,
    this.icon,
    this.trailing,
    this.validator,
    this.onSave,
    this.keyboardType,
    this.borderRadius = 10,
    this.maxLength,
    this.helperText,
    this.errorText,
    this.labelSize,
    this.formatters,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: margin ?? const EdgeInsets.all(8),
      child: TextFormField(
        initialValue: controller == null ? initialValue : null,
        controller: controller,
        autofocus: true,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppStyles.primaryColorTextField),
        obscureText: isObscure,
        validator: validator,
        keyboardType: keyboardType,
        maxLength: maxLength,
        onFieldSubmitted: onSave,
        onSaved: onSave,
        inputFormatters: formatters,
        decoration: InputDecoration(
          counterStyle: TextStyle(fontSize: 0),

          filled: true,
          fillColor: AppStyles.primaryBackBlackKnowText,
          //focusColor: Colors.red,
          //focusedBorder: InputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppStyles.primaryColorWhite),
            borderRadius: BorderRadius.circular(50),
          ),
          hoverColor: Colors.red,
          /*hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppStyles.primaryColorBlack),*/
          hintStyle: TextStyle(color: Colors.orange),
          errorStyle: theme.textTheme.caption.copyWith(color: Colors.red),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          labelText: label,
          labelStyle: TextStyle(
              fontSize: labelSize, color: AppStyles.primaryColorTextField),
          helperText: helperText,
          errorText: errorText,
          prefixIcon: icon == null
              ? null
              : Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(
                    icon,
                    color: AppStyles.primaryColorTextField,
                  )),
          suffixIcon: trailing == null
              ? null
              : Padding(padding: EdgeInsets.only(right: 12), child: trailing),
        ),
      ),
    );
  }
}
