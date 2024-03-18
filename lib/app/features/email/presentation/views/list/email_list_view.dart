import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_list_controller.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/utils/extensions.dart';

class EmailListView extends GetView<EmailListController> {
  const EmailListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // без этого цвета page transition выглядит немного коряво
      color: context.colors.backgroundPrimary,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: Get.context!.colors.inputBackground,
            width: double.infinity,
            height: 48.0,
            child: TabBar(
              padding: EdgeInsets.zero,
              isScrollable: false,
              tabs: [
                Tab(
                  text: 'messages_title_incoming'.tr.toUpperCase(),
                ),
                Tab(
                  text: 'messages_title_outgoing'.tr.toUpperCase(),
                ),
              ],
              controller: controller.tabController,
              // labelPadding: EdgeInsets.zero,
            ),
          ),
          Obx(
            () => controller.loadingData.value
                ? const Expanded(child: Loader())
                : controller.loadingError.value
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.errorMessage,
                              style: context.textStyles.bodyBold,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            GestureDetector(
                              onTap: () => controller.getData(),
                              child: Text(
                                'button_refresh'.tr,
                                style: context.textStyles.body.copyWith(color: context.colors.buttonActive),
                              ),
                            )
                          ],
                        ),
                      )
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: controller.tabs[controller.currentTabIndex.value],
                      ),
          ),
        ],
      ),
    );
  }
}
