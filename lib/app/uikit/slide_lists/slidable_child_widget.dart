import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rns_app/app/uikit/general_models/slidable_widget_action.dart';
import 'package:rns_app/app/utils/extensions.dart';

class SlidableChild extends StatelessWidget {
  const SlidableChild({
    super.key,
    required this.index,
    required this.actions,
  });

  final int index;
  final List<SlidableWidgetAction> actions;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Expanded(
        child: Container(
          height: double.infinity,
          color: context.colors.backgroundPrimary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...List.generate(
                actions.length,
                (index) => Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await actions[index].onTap(index).then((value) {
                        Slidable.of(context)?.close();
                      });
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                      color: context.colors.inputBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: actions[index].icon,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
