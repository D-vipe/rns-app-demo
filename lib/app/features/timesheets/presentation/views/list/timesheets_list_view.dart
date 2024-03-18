import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/timesheets/domain/models/ts_item_model.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/ts_list_controller.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/empty_data_widget.dart';
import 'package:rns_app/app/uikit/slide_lists/slide_list_item.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/app_decorations.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';
import 'package:rns_app/resources/resources.dart';

class TimesheetsListView extends GetView<TsListController> {
  const TimesheetsListView({super.key});

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

  final TsListController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.tsList.isEmpty
          ? EmptyDataWidget(
              message: 'timeSheets_refreshPage'.tr,
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
                      () => Wrap(
                        children: List.generate(
                          controller.tsList.length,
                          (index) => SlideListItem(
                            index: index,
                            deleteAction: (int index) => controller.deleteTimeSheet(controller.tsList[index]),
                            editAction: (int index) => controller.processEdit(controller.tsList[index]),
                            copyAction: (int index) => controller.processCopy(controller.tsList[index]),
                            child: _ListItem(
                              item: controller.tsList[index],
                              last: controller.tsList.length - 1 == index,
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

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.item,
    required this.last,
  });

  final TsItem item;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: last ? 0.0 : 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: AppDecorations.tsItem(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(219, 0, 255, 0.08),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  item.taskName,
                  style: context.textStyles.labelContrast.copyWith(
                    color: const Color.fromRGBO(219, 0, 255, 0.87),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppIcons.schedule),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    item.timeGap,
                    style: context.textStyles.labelContrast.copyWith(
                      fontWeight: FontWeight.w400,
                      color: item.overlapping ? context.colors.error : context.colors.background,
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            item.projectTitle,
            style: context.textStyles.header2,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            item.description,
            style: context.textStyles.body,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: context.colors.background,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  item.workTypeName,
                  style: context.textStyles.labelContrast.copyWith(
                    color: const Color.fromRGBO(0, 0, 0, 0.6),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(AppIcons.arrowUpRight),
              )
            ],
          )
        ],
      ),
    );
  }
}
