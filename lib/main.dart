import 'package:fernstack/features/auth/controller/auth_controller.dart';
import 'package:fernstack/features/home/views/home_view.dart';
import 'package:fernstack/features/onboarding/views/onboarding_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fernstack/core/dev_tools.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(
    const ProviderScope(
      observers: [StateLogger()],
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final asyncAuthState = ref.watch(asyncAuthStateProvider);

    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: asyncAuthState.isLoading
          ? Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CupertinoActivityIndicator(
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Loading",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : isLoggedIn
              ? const HomeView()
              : const OnboardingView(),
    );
  }
}
