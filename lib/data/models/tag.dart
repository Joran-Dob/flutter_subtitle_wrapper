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
  // static Tag getTagByName(String title) {
  //   title = title.toLowerCase();
  //   for (var item in tempTags) {
  //     if (item.name == title) {
  //       return item;
  //     }
  //   }
  //   return Tag(
  //       tag: 'defualt', name: "defualt", color: Colors.white, description: "");
  // }
  static Tag getTag(String tag) {
    tag = tag.toLowerCase();
    for (Tag item in tempTags) {
      // throw item.toString();
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

List<Tag> tempTags = [
  Tag(
    id: "a",
    name: "essential",
    color: Colors.purple,
    description: "from essential words",
  ),
  Tag(
    id: "b",
    name: "504",
    color: Colors.orange,
    description: "from 504 words",
  ),
  Tag(
    id: "c",
    name: "personal",
    color: Colors.blueAccent,
    description: "from pesrsonal words",
  ),
];
