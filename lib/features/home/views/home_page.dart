import 'package:fernstack/common/providers.dart';
import 'package:fernstack/core/dev_tools.dart';
import 'package:fernstack/features/user/controller/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Icon(Icons.generating_tokens_rounded),
        titleSpacing: 60,
        centerTitle: false,
        backgroundColor: Colors.deepPurple.shade50,
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {},
            icon: Icon(CupertinoIcons.search),
          ),
          IconButton(
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(CupertinoIcons.suit_heart),
          ),
          IconButton(
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(CupertinoIcons.cart),
          ),
          SizedBox(width: 5),
        ],
      ),
      body: ListView(
        children: [
          FilledButton(
            style: FilledButton.styleFrom(
              fixedSize: Size.fromWidth(size.width),
            ),
            onPressed: () async {
              final secureStorage = ref.watch(secureStorageProvider);
              final user = ref.watch(userProvider);
              final token = await secureStorage.read(key: 'Authorization');
              token.log();
              user.log();
            },
            child: const Text("Routes"),
          ),
        ],
      ),
    );
  }
}
