import 'package:fernstack/services/auth/extra/auth_status.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthResult {
  final AuthStatus authStatus;
  final String message;
  const AuthResult({
    required this.authStatus,
    required this.message,
  });

  @override
  String toString() =>
      'AuthResult (authStatus: $authStatus, message: $message)';
}
