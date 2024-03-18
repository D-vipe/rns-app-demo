import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rns_app/app/utils/extensions.dart';

class Loader extends StatelessWidget {
  final Color? color;
  final bool? btn;
  final double size;

  const Loader({
    Key? key,
    this.color,
    this.size = 30,
    this.btn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: btn == true
          ? LoadingAnimationWidget.hexagonDots(color: color ?? context.colors.white, size: 15)
          : LoadingAnimationWidget.bouncingBall(color: color ?? context.colors.buttonActive, size: size),
    );
  }
}
