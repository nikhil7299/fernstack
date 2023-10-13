import 'dart:convert';
import 'package:flutter/foundation.dart'
    show ValueGetter, immutable, listEquals;
import 'package:fernstack/models/sub_category.dart';

@immutable
class Category {
  final String cid;
  final String name;
  final String imageUrl;
  final List<SubCategory>? subCategories;
  const Category({
    required this.cid,
    required this.name,
    required this.imageUrl,
    this.subCategories,
  });

  Category copyWith({
    String? cid,
    String? name,
    String? imageUrl,
    ValueGetter<List<SubCategory>?>? subCategories,
  }) {
    return Category(
      cid: cid ?? this.cid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      subCategories:
          subCategories != null ? subCategories() : this.subCategories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cid': cid,
      'name': name,
      'imageUrl': imageUrl,
      'subCategories': subCategories?.map((x) => x.toMap()).toList(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      cid: map['_id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      subCategories: map['subCategories'] != null
          ? List<SubCategory>.from(
              map['subCategories']?.map((x) => SubCategory.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category (cid: $cid, name: $name, imageUrl: $imageUrl, subCategories: $subCategories)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.cid == cid &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        listEquals(other.subCategories, subCategories);
  }

  @override
  int get hashCode {
    return cid.hashCode ^
        name.hashCode ^
        imageUrl.hashCode ^
        subCategories.hashCode;
  }
}
