import 'package:fernstack/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final String labelText;
  final String hintText;
  final TextInputType textInputType;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  const CustomTextField({
    super.key,
    required this.validator,
    required this.textEditingController,
    required this.suffixIcon,
    required this.labelText,
    required this.hintText,
    required this.textInputType,
    required this.onChanged,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      style: const TextStyle(color: AppColors.deepPurple),
      onChanged: onChanged,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: textEditingController,
      cursorColor: AppColors.deepPurple,
      obscureText: obscureText,
      keyboardType: textInputType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: labelText,
        floatingLabelStyle:
            const TextStyle(color: AppColors.deepPurple, fontSize: 25),
        labelStyle: const TextStyle(fontSize: 20, color: AppColors.lightPurple),
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.lightPurple),
        focusColor: AppColors.deepPurple,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.deepPurple,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.deepPurple,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.deepPurple),
        ),
        enabled: true,
      ),
    );
  }
}
