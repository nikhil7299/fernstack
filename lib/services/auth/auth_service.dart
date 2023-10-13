import 'package:dio/dio.dart';
import 'package:fernstack/common/providers.dart';
import 'package:fernstack/features/user/controller/user_controller.dart';
import 'package:fernstack/services/auth/extra/auth_provider.dart';
import 'package:fernstack/services/auth/extra/auth_result.dart';
import 'package:fernstack/services/auth/extra/auth_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthService(
    ref: ref,
    dio: dio,
  );
});

abstract class IAuthService {
  Future<(bool, AuthProvider?)> setAuthUser();
  Future<AuthResult> signUpEmail({
    required String name,
    required String email,
    required String password,
  });
  Future<AuthResult> logInEmail({
    required String email,
    required String password,
  });
  Future<AuthResult> logInGoogle();
  Future<void> logOut();
}

class AuthService implements IAuthService {
  final Ref _ref;
  final Dio _dio;

  AuthService({
    required Ref ref,
    required Dio dio,
  })  : _ref = ref,
        _dio = dio;

  @override
  Future<(bool, AuthProvider?)> setAuthUser() async {
    final String? token =
        await _ref.read(secureStorageProvider).read(key: 'Authorization');
    if (token == null) {
      return (false, null);
    }
    const apiRoute = '/';
    try {
      final res = await _dio.get(
        apiRoute,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print(res.data['provider']);

      if (res.statusCode == 200) {
        _ref.read(userProvider.notifier).setUser(res.data['user']);
        return (true, AuthProvider.values.byName(res.data['provider']));
      }

      return (false, null);
    } catch (e) {
      if (e is DioException) {
        return (false, null);
      }
      return (false, null);
    }
  }

  @override
  Future<AuthResult> signUpEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    const apiRoute = '/auth/signUpEmail';
    try {
      final res = await _dio.post(apiRoute, data: {
        'name': name,
        'email': email,
        'password': password,
      });
      if (res.statusCode == 200) {
        return AuthResult(
          authStatus: AuthStatus.registered,
          message: res.data['msg'],
        );
      }
      return AuthResult(
        authStatus: AuthStatus.failure,
        message: res.data['msg'],
      );
    } catch (e) {
      if (e is DioException) {
        return AuthResult(
          authStatus: AuthStatus.failure,
          message: e.response?.data['msg'],
        );
      }
      return const AuthResult(
        authStatus: AuthStatus.failure,
        message: "Unexpected Error Occured",
      );
    }
  }

  @override
  Future<AuthResult> logInEmail({
    required String email,
    required String password,
  }) async {
    const apiRoute = '/auth/logInEmail';
    try {
      final res = await _dio.post(apiRoute, data: {
        'email': email,
        'password': password,
      });

      if (res.statusCode == 200) {
        _ref.read(userProvider.notifier).setUser(res.data['user']);
        await _ref.read(secureStorageProvider).write(
              key: 'Authorization',
              value: res.data['token'],
            );
        return AuthResult(
          authStatus: AuthStatus.loggedIn,
          message: res.data['msg'],
        );
      }
      return AuthResult(
        authStatus: AuthStatus.failure,
        message: res.data['msg'],
      );
    } catch (e) {
      // e.runtimeType.log();
      // 'logInEmail error - $e'.log();
      if (e is DioException) {
        return AuthResult(
          authStatus: AuthStatus.failure,
          message: e.response?.data['msg'],
        );
      }
      return const AuthResult(
        authStatus: AuthStatus.failure,
        message: "Unexpected Error Occured",
      );
    }
  }

  @override
  Future<AuthResult> logInGoogle() async {
    const apiRoute = '/auth/logInGoogle';

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? signInAccount = await googleSignIn.signIn();

      if (signInAccount == null) {
        return const AuthResult(
          authStatus: AuthStatus.failure,
          message: "Google Sign In Aborted",
        );
      }

      final res = await _dio.post(apiRoute, data: {
        'name': signInAccount.displayName,
        'email': signInAccount.email,
      });

      if (res.statusCode == 200) {
        _ref.read(userProvider.notifier).setUser(res.data['user']);
        await _ref.read(secureStorageProvider).write(
              key: 'Authorization',
              value: res.data['token'],
            );
        return AuthResult(
          authStatus: AuthStatus.loggedIn,
          message: res.data['msg'],
        );
      }
      return AuthResult(
        authStatus: AuthStatus.failure,
        message: res.data['msg'],
      );
    } on Exception catch (e) {
      // e.runtimeType.log();
      // print('logInGoogle error - $e');

      if (e is DioException) {
        return AuthResult(
          authStatus: AuthStatus.failure,
          message: e.response?.data['msg'],
        );
      }
      return const AuthResult(
        authStatus: AuthStatus.failure,
        message: "Unexpected Error Occured",
      );
    }
  }

  @override
  Future<void> logOut() async {
    await GoogleSignIn().signOut();
    _ref.read(userProvider.notifier).removeUser();
    await _ref.read(secureStorageProvider).delete(key: 'Authorization');
  }
}
