import 'dart:math';
import 'package:fernstack/features/home/views/drawer_menu.dart';
import 'package:fernstack/features/home/views/home_page.dart';
import 'package:fernstack/features/home/widgets/rive_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with SingleTickerProviderStateMixin {
  late SMIBool isDrawerHidden;
  bool isDrawerClosed = true;

  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        AnimatedPositioned(
          left: isDrawerClosed ? -size.width * 0.65 : 0,
          width: size.width * 0.65,
          height: size.height,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          child: const DrawerMenu(),
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(animation.value - 30 * animation.value * pi / 180),
          child: Transform.translate(
            offset: Offset(animation.value * size.width * 0.60, 0),
            child: Transform.scale(
              scale: scaleAnimation.value,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: HomePage(),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          left: isDrawerClosed ? 0 : size.width * 0.52,
          top: isDrawerClosed ? size.height * 0.04 : size.height * 0.065,
          child: IconButton(
            style: IconButton.styleFrom(
              maximumSize: const Size.fromRadius(30),
            ),
            splashRadius: 0.1,
            onPressed: () {
              isDrawerHidden.value = !isDrawerHidden.value;
              if (isDrawerClosed) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
              setState(() {
                isDrawerClosed = isDrawerHidden.value;
              });
            },
            icon: RiveAnimation.asset(
              'assets/rive/menu_button.riv',
              onInit: (artboard) {
                StateMachineController controller = RiveUtils.getRiveController(
                  artboard: artboard,
                  stateMachineName: "State Machine",
                );
                isDrawerHidden = controller.findSMI("isOpen") as SMIBool;
                isDrawerHidden.value = true;
              },
            ),
          ),
        ),
      ],
    );
  }
}
