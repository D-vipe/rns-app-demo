import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/resources/resources.dart';

class SlideListItem extends StatelessWidget {
  final int index;
  final Future<void> Function(int index)? editAction;
  final Future<bool> Function(int index)? deleteAction;
  final Future<void> Function(int index)? copyAction;
  final Widget child;
  const SlideListItem({
    super.key,
    required this.index,
    required this.editAction,
    required this.deleteAction,
    required this.copyAction,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ValueKey itemKey = ValueKey(index);

    return Slidable(
      key: itemKey,
      dragStartBehavior: DragStartBehavior.down,
      startActionPane: ActionPane(
        extentRatio: .15,
        motion: const ScrollMotion(),
        children: [
          _SlidableChild(editAction: editAction, index: index, deleteAction: deleteAction, copyAction: copyAction),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: .15,
        motion: const ScrollMotion(),
        children: [
          Builder(builder: (context) {
            return _SlidableChild(
                editAction: editAction, index: index, deleteAction: deleteAction, copyAction: copyAction);
          }),
        ],
      ),
      child: child,
    );
  }
}

class _SlidableChild extends StatelessWidget {
  const _SlidableChild({
    required this.editAction,
    required this.index,
    required this.deleteAction,
    required this.copyAction,
  });

  final Future<void> Function(int index)? editAction;
  final int index;
  final Future<bool> Function(int index)? deleteAction;
  final Future<void> Function(int index)? copyAction;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Expanded(
        child: Container(
          height: double.infinity,
          margin: const EdgeInsets.only(bottom: 5.0),
          color: context.colors.backgroundPrimary,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (editAction != null)
                  SizedBox(
                    height: 35.0,
                    width: 35.0,
                    child: IconButton(
                      padding: const EdgeInsets.all(3),
                      onPressed: () async {
                        Slidable.of(context)?.close();
                        editAction!(index);
                      },
                      iconSize: 35,
                      icon: SvgPicture.asset(
                        AppIcons.editNote,
                      ),
                    ),
                  ),
                if (copyAction != null)
                  SizedBox(
                    height: 35.0,
                    width: 35.0,
                    child: IconButton(
                      padding: const EdgeInsets.all(3),
                      onPressed: () {
                        Slidable.of(context)?.close();
                        copyAction!(index);
                      },
                      icon: SvgPicture.asset(
                        AppIcons.flipToFront,
                      ),
                    ),
                  ),
                if (deleteAction != null)
                  SizedBox(
                    height: 35.0,
                    width: 35.0,
                    child: IconButton(
                      padding: const EdgeInsets.all(3),
                      onPressed: () async {
                        await deleteAction!(index).then((value) {
                          Slidable.of(context)?.close();
                        });
                      },
                      icon: SvgPicture.asset(
                        AppIcons.delete,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
