import 'package:fernstack/features/admin/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  final String actionTitle;
  final String actionName;
  final VoidCallback onPressed;
  static route({
    required String actionTitle,
    required String actionName,
    required VoidCallback onPressed,
  }) =>
      MaterialPageRoute(
        builder: (context) => CategoryView(
          actionTitle: actionTitle,
          actionName: actionName,
          onPressed: onPressed,
        ),
      );
  const CategoryView({
    super.key,
    required this.actionTitle,
    required this.actionName,
    required this.onPressed,
  });

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  late final TextEditingController imageUrlTextEditingController;
  late final TextEditingController categoryNameTextEditingController;
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    imageUrlTextEditingController = TextEditingController();
    categoryNameTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    imageUrlTextEditingController.dispose();
    categoryNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.actionTitle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        children: [
          CustomNetworkImage(imageUrl: imageUrl, height: 250),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomMinTextField(
                  labelText: "Image Url",
                  textEditingController: imageUrlTextEditingController,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade200,
                ),
                onPressed: () {
                  setState(() {
                    imageUrl = imageUrlTextEditingController.text;
                  });
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CustomMinTextField(
            textEditingController: categoryNameTextEditingController,
            labelText: "Category Name",
          ),
          const SizedBox(height: 15),
          const Text("Sub Categories"),
          const Divider(),
        ],
      ),
      persistentFooterButtons: [
        FilledButton(
          onPressed: () {},
          child: Text(widget.actionName),
        ),
      ],
    );
  }
}
