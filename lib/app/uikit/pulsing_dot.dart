import 'package:flutter/material.dart';
import 'package:rns_app/app/utils/extensions.dart';

class PulsingDotWidget extends StatefulWidget {
  final bool visible;
  final Color? color;

  const PulsingDotWidget({
    super.key,
    required this.visible,
    this.color,
  });

  @override
  State<PulsingDotWidget> createState() => _PulsingDotWidgetState();
}

class _PulsingDotWidgetState extends State<PulsingDotWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    if (widget.visible) _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 3.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: 4.0,
          height: 4.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.visible ? (widget.color ?? context.colors.error) : Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: widget.visible
                      ? widget.color != null
                          ? widget.color!.withOpacity(.8)
                          : context.colors.error.withOpacity(.8)
                      : Colors.transparent,
                  blurRadius: _animation.value,
                  spreadRadius: _animation.value,
                )
              ]),
        ),
        const SizedBox(
          width: 10.0,
        )
      ],
    );
  }
}
