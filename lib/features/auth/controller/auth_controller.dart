import 'dart:async';
import 'package:fernstack/features/auth/controller/auth_state.dart';
import 'package:fernstack/services/auth/extra/auth_provider.dart';
import 'package:fernstack/services/auth/extra/auth_result.dart';
import 'package:fernstack/services/auth/auth_service.dart';
import 'package:fernstack/services/auth/extra/auth_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoggedInProvider = Provider<bool>((ref) {
  final asyncAuthState = ref.watch(asyncAuthStateProvider);
  return asyncAuthState.value?.status == AuthStatus.loggedIn;
});

final asyncAuthStateProvider =
    AsyncNotifierProvider<AsyncAuthStateNotifier, AuthState?>(
        AsyncAuthStateNotifier.new);

class AsyncAuthStateNotifier extends AsyncNotifier<AuthState?> {
  late final AuthService _authService;

  @override
  FutureOr<AuthState?> build() async {
    _authService = ref.watch(authServiceProvider);
    final (isLoggedIn, authProvider) = await _authService.setAuthUser();
    if (isLoggedIn) {
      return AuthState(provider: authProvider!, status: AuthStatus.loggedIn);
    }
    return null;
  }

  Future<void> signUpEmail({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    state = const AsyncLoading();

    final AuthResult authResult = await _authService.signUpEmail(
      name: name,
      email: email,
      password: password,
    );

    state = AsyncData(
      AuthState(
        status: authResult.authStatus,
      ),
    );

    if (authResult.authStatus == AuthStatus.registered) {
      navigator.pop();
    }
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          authResult.message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> logInEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // state = const AsyncLoading<AuthState?>();
    state = const AsyncLoading<AuthState?>().copyWithPrevious(
      const AsyncData(
        AuthState(
          provider: AuthProvider.email,
        ),
      ),
    );

    final AuthResult authResult = await _authService.logInEmail(
      email: email,
      password: password,
    );
    bool isLoggedIn = authResult.authStatus == AuthStatus.loggedIn;

    state = AsyncData(
      AuthState(
        status: authResult.authStatus,
        provider: isLoggedIn ? AuthProvider.email : null,
      ),
    );

    if (isLoggedIn) {
      navigator.pop();
    }

    // Doesn't work =>
    // if (state == const AsyncData(AuthStatus.loggedIn)) {
    //   navigator.pop();
    // }
    // May work
    // if(state.value?.status == AuthStatus.loggedIn){
    //      navigator.pop();
    // }

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          authResult.message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> logInGoogle({
    required BuildContext context,
  }) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // state = const AsyncLoading();
    state = const AsyncLoading<AuthState?>().copyWithPrevious(
      const AsyncData(
        AuthState(
          provider: AuthProvider.google,
        ),
      ),
    );

    final AuthResult authResult = await _authService.logInGoogle();

    // state = AsyncData(authResult.authStatus);
    bool isLoggedIn = authResult.authStatus == AuthStatus.loggedIn;

    state = AsyncData(
      AuthState(
        status: authResult.authStatus,
        provider: isLoggedIn ? AuthProvider.google : null,
      ),
    );

    if (isLoggedIn) {
      navigator.pop();
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          authResult.message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> logOut() async {
    state = const AsyncLoading();
    await _authService.logOut();
    state = const AsyncData(null);
  }
}
