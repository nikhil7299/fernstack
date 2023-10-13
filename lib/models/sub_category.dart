import 'dart:convert';

import 'package:flutter/foundation.dart'
    show ValueGetter, immutable, listEquals;

@immutable
class SubCategory {
  final String scid;
  final String cid;
  final String name;
  final String imageUrl;
  final List<String>? innerCategories;

  const SubCategory({
    required this.scid,
    required this.cid,
    required this.name,
    required this.imageUrl,
    this.innerCategories,
  });

  SubCategory copyWith({
    String? scid,
    String? cid,
    String? name,
    String? imageUrl,
    ValueGetter<List<String>?>? innerCategories,
  }) {
    return SubCategory(
      scid: scid ?? this.scid,
      cid: cid ?? this.cid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      innerCategories:
          innerCategories != null ? innerCategories() : this.innerCategories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'scid': scid,
      'cid': cid,
      'name': name,
      'imageUrl': imageUrl,
      'innerCategories': innerCategories,
    };
  }

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      scid: map['_id'] ?? '',
      cid: map['cid'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      innerCategories: List<String>.from(map['innerCategories']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubCategory.fromJson(String source) =>
      SubCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubCategory (scid: $scid, cid: $cid, name: $name, imageUrl: $imageUrl, innerCategories: $innerCategories)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubCategory &&
        other.scid == scid &&
        other.cid == cid &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        listEquals(other.innerCategories, innerCategories);
  }

  @override
  int get hashCode {
    return scid.hashCode ^
        cid.hashCode ^
        name.hashCode ^
        imageUrl.hashCode ^
        innerCategories.hashCode;
  }
}
