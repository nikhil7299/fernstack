import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final Color? loadingColor;
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return SizedBox(
          height: height,
          child: CupertinoActivityIndicator(
            color: loadingColor,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Image.asset(
        "assets/images/placeholder.jpg",
        height: height,
      ),
    );
  }
}

class CustomMinTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController textEditingController;
  const CustomMinTextField({
    super.key,
    required this.textEditingController,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
