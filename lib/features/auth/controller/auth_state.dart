import 'package:flutter/foundation.dart' show ValueGetter, immutable;
import 'package:flutter/widgets.dart';

import 'package:fernstack/services/auth/extra/auth_provider.dart';
import 'package:fernstack/services/auth/extra/auth_status.dart';

@immutable
class AuthState {
  final AuthStatus? status;
  final AuthProvider? provider;

  const AuthState({
    this.status,
    this.provider,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.status == status &&
        other.provider == provider;
  }

  @override
  int get hashCode => status.hashCode ^ provider.hashCode;

  @override
  String toString() => '$status - $provider';

  AuthState copyWith({
    ValueGetter<AuthStatus?>? status,
    ValueGetter<AuthProvider?>? provider,
  }) {
    return AuthState(
      status: status != null ? status() : this.status,
      provider: provider != null ? provider() : this.provider,
    );
  }
}
