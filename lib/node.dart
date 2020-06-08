import 'package:flutter/material.dart';

class Node {
  Node({
    this.name,
    this.position,
  }) : this.neighbors = [];

  final String name;
  final Offset position;
  final List<Node> neighbors;
}
