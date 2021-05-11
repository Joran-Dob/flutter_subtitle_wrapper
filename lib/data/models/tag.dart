import 'package:flutter/material.dart';

class Tag {
  final String name;
  final Color color;
  final String description;

  Tag({required this.name, required this.color, required this.description});
  static Tag getTagByName(String title) {
    title = title.toLowerCase();
    for (var item in tempTags) {
      if (item.name == title) {
        return item;
      }
    }
    return Tag(name: "defualt", color: Colors.white, description: "");
  }

  static final List<Tag> tempTags = [
    Tag(
      name: "essential",
      color: Colors.purple,
      description: "from essential words",
    ),
    Tag(
      name: "504",
      color: Colors.orange,
      description: "from 504 words",
    ),
    Tag(
      name: "personal",
      color: Colors.blueAccent,
      description: "from pesrsonal words",
    ),
  ];
}
