import 'package:flutter/material.dart';

class AppAnimatedListItem extends StatefulWidget {
  const AppAnimatedListItem({
    super.key,
    required this.index,
    required this.child,
    required this.alreadyRendered,
    this.animationController,
  });

  final int index;
  final Widget child;
  final bool alreadyRendered;
  final AnimationController? animationController;

  @override
  State<AppAnimatedListItem> createState() => _AppAnimatedListItemState();
}

class _AppAnimatedListItemState extends State<AppAnimatedListItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = widget.animationController ??
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        );
    super.initState();
  }

  @override
  void dispose() {
    if (widget.animationController == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation<Offset> itemAnimation = Tween<Offset>(
      begin:
          widget.alreadyRendered ? Offset(0.0 * (widget.index + 1.5), 0.0) : Offset(-1.0 * (widget.index + 1.5), 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastEaseInToSlowEaseOut,
      ),
    );

    if (widget.animationController == null) {
      _animationController.forward();
    }

    return SlideTransition(
      position: itemAnimation,
      child: widget.child,
    );
  }
}
