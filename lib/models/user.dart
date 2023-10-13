import 'dart:convert';

import 'package:flutter/foundation.dart' show immutable;

@immutable
class User {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final bool isPhoneVerified;
  final String type;

  const User({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.isPhoneVerified = false,
    required this.type,
  });

  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    bool? isPhoneVerified,
    String? type,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'isPhoneVerified': isPhoneVerified,
      'type': type,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      isPhoneVerified: map['isPhoneVerified'] ?? false,
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return '''User (uid: $uid, name: $name, type: $type)
  (email: $email, phone: $phone, isPhoneVerified: $isPhoneVerified)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.isPhoneVerified == isPhoneVerified &&
        other.type == type;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        isPhoneVerified.hashCode ^
        type.hashCode;
  }
}
