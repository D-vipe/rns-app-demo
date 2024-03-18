import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rns_app/app/uikit/general_models/slidable_widget_action.dart';
import 'package:rns_app/app/uikit/slide_lists/slidable_child_widget.dart';

class SlideListItemAlt extends StatelessWidget {
  final int index;
  final List<SlidableWidgetAction> startActions;
  final List<SlidableWidgetAction> endActions;
  final Widget child;
  final double extentRatio;
  final double startExtentRatio;
  final bool enabled;
  const SlideListItemAlt({
    super.key,
    required this.index,
    required this.child,
    required this.startActions,
    required this.endActions,
    this.enabled = true,
    this.extentRatio = .55,
    this.startExtentRatio = .55,
  });

  @override
  Widget build(BuildContext context) {
    final ValueKey itemKey = ValueKey(index);

    return Slidable(
      key: itemKey,
      dragStartBehavior: DragStartBehavior.down,
      enabled: enabled,
      startActionPane: startActions.isNotEmpty
          ? ActionPane(
              extentRatio: startExtentRatio,
              motion: const ScrollMotion(),
              children: [
                SlidableChild(
                  index: index,
                  actions: startActions,
                ),
              ],
            )
          : null,
      endActionPane: endActions.isNotEmpty
          ? ActionPane(
              extentRatio: extentRatio,
              motion: const ScrollMotion(),
              children: [
                Builder(builder: (context) {
                  return SlidableChild(
                    index: index,
                    actions: endActions,
                  );
                }),
              ],
            )
          : null,
      child: child,
    );
  }
}
