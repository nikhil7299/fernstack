import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color bgColor;
  final Size size;
  final VoidCallback onPressed;
  final Widget child;
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.size,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: bgColor,
        fixedSize: Size.fromWidth(
          size.width,
        ),
      ),
      child: child,
    );
  }
}
