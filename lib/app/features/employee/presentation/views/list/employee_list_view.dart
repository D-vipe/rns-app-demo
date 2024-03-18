import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/employee/presentation/controllers/employee_list_controller.dart';
import 'package:rns_app/app/features/employee/presentation/views/list/components/employee_list_item_widget.dart';
import 'package:rns_app/app/uikit/app_animated_list_item.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/empty_data_widget.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class EmployeeListView extends GetView<EmployeeListController> {
  const EmployeeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // без этого цвета page transition выглядит немного коряво
      color: context.colors.backgroundPrimary,
      padding: const EdgeInsets.only(
          top: 16.0, bottom: 0.0, left: AppConstraints.screenPadding, right: AppConstraints.screenPadding),
      child: Obx(
        () => controller.loadingData.value
            ? const Loader()
            : controller.loadingError.value
                ? Center(
                    child: Text(
                      controller.errorMessage,
                      style: context.textStyles.bodyBold,
                    ),
                  )
                : _ListBody(
                    controller: controller,
                  ),
      ),
    );
  }
}

class _ListBody extends StatelessWidget {
  const _ListBody({
    required this.controller,
  });

  final EmployeeListController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.itemList.isEmpty
          ? EmptyDataWidget(
              message: 'employees_refreshPage'.tr,
              refresh: () => controller.refreshPage(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Obx(
                    () => controller.refreshing.value
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Loader(
                              size: 15,
                              btn: true,
                              color: context.colors.main,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  IgnorePointer(
                    ignoring: controller.refreshing.value,
                    child: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          controller.itemList.length,
                          (index) => AppAnimatedListItem(
                            index: index,
                            alreadyRendered: false,
                            child: EmployeeListItemWidget(
                              item: controller.itemList[index],
                              last: controller.itemList.length - 1 == index,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => controller.isLoadingMore.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Loader(
                              size: 15,
                              btn: true,
                              color: context.colors.main,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(
                    height: 62.0,
                  ),
                ],
              ),
            ),
    );
  }
}
