import 'package:flutter/material.dart';

class SlidableWidgetAction {
  final Widget icon;
  final Future Function(int index) onTap;

  const SlidableWidgetAction({required this.icon, required this.onTap});
}
