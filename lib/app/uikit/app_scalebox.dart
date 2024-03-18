import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

class AppScaleBox extends StatelessWidget {
  final Widget child;
  const AppScaleBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return rf.ResponsiveScaledBox(
      width: rf.ResponsiveValue<double>(context, conditionalValues: [
        rf.Condition.between(start: 0, end: 380, value: context.width),
        rf.Condition.between(start: 381, end: 480, value: context.width),
        rf.Condition.between(start: 481, end: 720, value: 560),
        rf.Condition.between(start: 721, end: 1920, value: 800),
      ]).value,
      child: child,
    );
  }
}
