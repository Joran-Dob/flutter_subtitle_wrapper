import 'package:flutter/material.dart';

class Tag {
  final String id;
  final String name;
  final Color color;
  final String description;

  Tag(
      {required this.name,
      required this.color,
      required this.id,
      required this.description});
  static Tag getTag(String tag) {
    tag = tag.toLowerCase();
    for (Tag item in tempTags) {
      if (item.id == tag) {
        return item;
      }
    }
    return Tag(
        id: 'defualt', name: "defualt", color: Colors.white, description: "");
  }

  @override
  String toString() {
    return this.id + ':' + this.name + ":" + this.color.value.toString();
  }
}

List<Tag> tempTags = [];
