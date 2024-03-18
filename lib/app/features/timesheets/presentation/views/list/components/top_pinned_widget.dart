import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/ts_list_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';

class TopPinnedWidgetTs extends GetView<TsListController> {
  const TopPinnedWidgetTs({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Opacity(
        opacity: controller.tsList.isEmpty ? 0 : 1,
        child: Container(
          padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.backgroundPrimary,
              borderRadius: BorderRadius.circular(18.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1.0, -0.0),
                            end: const Offset(0.0, 0.0),
                          ).animate(animation),
                          child: child,
                        );
                      },
                      child: Text(
                        key: ValueKey<String>(controller.selectedDate.value),
                        controller.selectedDate.value,
                        style: context.textStyles.body.copyWith(fontSize: 12.0),
                      ),
                    )),
                const SizedBox(
                  width: 5.0,
                ),
                Obx(() => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: const Offset(0.0, 0.0),
                          ).animate(animation),
                          child: child,
                        );
                      },
                      child: Text(
                        key: ValueKey<String>(controller.totalTimesheetsTime.value),
                        controller.totalTimesheetsTime.value,
                        style: context.textStyles.bodyBold.copyWith(fontSize: 12.0),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
