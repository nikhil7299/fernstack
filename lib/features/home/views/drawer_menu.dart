import 'package:fernstack/features/admin/views/admin_view.dart';
import 'package:fernstack/features/auth/controller/auth_controller.dart';
import 'package:fernstack/features/home/widgets/rive_assets.dart';
import 'package:fernstack/features/user/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class DrawerMenu extends ConsumerStatefulWidget {
  const DrawerMenu({super.key});

  @override
  ConsumerState<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends ConsumerState<DrawerMenu> {
  RiveAsset selectedItem = drawerMenuItemsData.first;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final user = ref.watch(userProvider);

    return Material(
      color: Colors.black,
      child: Container(
        width: size.width * 0.65,
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              onTap: () {},
              leading: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "NIKHIL KUMAR",
                style: Theme.of(context).primaryTextTheme.bodyLarge,
              ),
              subtitle: Text(
                "Youtuber",
                style: Theme.of(context).primaryTextTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "     MENU",
              style: theme.primaryTextTheme.titleMedium!
                  .copyWith(color: Colors.white70),
              textAlign: TextAlign.start,
            ),
            const Divider(
              color: Colors.white24,
              thickness: 1,
              indent: 12,
              endIndent: 12,
            ),
            ...drawerMenuItemsData.map(
              (drawerMenuItemData) => MenuItemTile(
                riveAsset: drawerMenuItemData,
                isTapped: selectedItem == drawerMenuItemData,
                onTap: () {
                  drawerMenuItemData.input!.change(true);
                  Future.delayed(const Duration(seconds: 1), () {
                    drawerMenuItemData.input!.change(false);
                  });
                  setState(
                    () {
                      selectedItem = drawerMenuItemData;
                    },
                  );
                },
                riveOnInit: (artboard) {
                  StateMachineController controller =
                      RiveUtils.getRiveController(
                          artboard: artboard,
                          stateMachineName:
                              drawerMenuItemData.stateMachineName);
                  drawerMenuItemData.input =
                      controller.findSMI("active") as SMIBool;
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "     MENU",
              style: theme.primaryTextTheme.titleMedium!
                  .copyWith(color: Colors.white70),
              textAlign: TextAlign.start,
            ),
            const Divider(
              color: Colors.white24,
              thickness: 1,
              indent: 12,
              endIndent: 12,
            ),
            const Spacer(),
            if (user!.type == "admin")
              FilledButton(
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.push(context, AdminView.route());
                },
                child: const Text("Admin Panel"),
              ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                await ref.read(asyncAuthStateProvider.notifier).logOut();
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemTile extends StatelessWidget {
  final RiveAsset riveAsset;
  final bool isTapped;
  final VoidCallback onTap;
  final ValueChanged<Artboard> riveOnInit;
  const MenuItemTile({
    super.key,
    required this.riveAsset,
    required this.isTapped,
    required this.onTap,
    required this.riveOnInit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          height: size.height * 0.053,
          width: isTapped ? size.width * 0.63 : 0,
          decoration: const BoxDecoration(
            color: Color(0xFF6792FF),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        ListTile(
          splashColor: Colors.transparent,
          onTap: onTap,
          leading: SizedBox(
            height: 34,
            width: 34,
            child: RiveAnimation.asset(
              riveAsset.assetPath,
              artboard: riveAsset.artboard,
              onInit: riveOnInit,
            ),
          ),
          title: Text(
            riveAsset.title,
            style: theme.primaryTextTheme.titleMedium,
          ),
        )
      ],
    );
  }
}
