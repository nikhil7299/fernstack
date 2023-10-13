import 'package:fernstack/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = NotifierProvider<UserNotifier, User?>(UserNotifier.new);

class UserNotifier extends Notifier<User?> {
  @override
  User? build() {
    return null;
  }

  void setUser(Map<String, dynamic> user) {
    state = User.fromMap(user);
  }

  void setUserFromModel(User user) {
    state = user;
  }

  void removeUser() {
    state = null;
  }
}
