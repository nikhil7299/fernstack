import 'package:fernstack/features/admin/views/category_view.dart';
import 'package:fernstack/features/admin/widgets/custom_widgets.dart';
import 'package:fernstack/features/user/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminView extends ConsumerWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AdminView(),
      );
  const AdminView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final user = ref.watch(userProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text("Admin Panel"),
            expandedHeight: size.height * 0.20,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(top: 10),
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(
                  top: 120,
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Admin Id : ${user!.uid}"),
                    Text("Name      : ${user.name}"),
                    Text("Email      : ${user.email}"),
                    Text("Phone     : ${user.phone}"),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const Text("Categories"),
                  const Divider(height: 20),
                  FilledButton(
                    onPressed: () => Navigator.push(
                      context,
                      CategoryView.route(
                          actionTitle: "Edit Category",
                          actionName: "Update Changes",
                          onPressed: () {}),
                    ),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.deepPurple.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomNetworkImage(
                          imageUrl:
                              'https://cdn-icons-png.flaticon.com/512/1198/1198368.png',
                          height: 100,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name : Furniture",
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Sub Categories : 12",
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        FilledButton(
          onPressed: () {
            Navigator.push(
              context,
              CategoryView.route(
                actionTitle: "Add Category",
                actionName: "Save Category",
                onPressed: () {},
              ),
            );
          },
          child: RichText(
            text: TextSpan(
              children: [
                const WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                  ),
                ),
                TextSpan(
                    text: "  Add Category",
                    style: Theme.of(context).primaryTextTheme.titleMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
