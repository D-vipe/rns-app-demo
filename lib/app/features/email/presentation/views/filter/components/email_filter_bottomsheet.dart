import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_filter_controller.dart';
import 'package:rns_app/app/uikit/form_widgets/select/custom_select_bottom_modal.dart';
import 'package:rns_app/app/uikit/form_widgets/select/single_select_widget.dart';

class EmailFilterBottomSheet extends GetView<EmailFilterController> {
  const EmailFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).unfocus(),
      child: CustomSelectBottomWidget(
        title: 'tasks_title_executor'.tr,
        clearHandler: () => controller.clearSelectFilter(),
        closeHandler: () {
          Get.back(result: null);
        },
        saveHandler: () {
          controller.applySelectedValue();
          Get.back(result: true);
        },
        children: [
          Obx(
            () => SingleSelectWidget(
              items: controller.usersList,
              refresher: () => controller.getUsersList(),
              onChange: controller.onRecepientChange,
              searchController: controller.searchUserController,
              selectedVal: controller.radioUser.value,
              loadingData: controller.loadingData.value,
              error: controller.userError.value,
              animationController: controller.bottomAnimationController,
              searching: controller.searching.value,
              searchLabel: 'tasks_placeholder_search'.tr,
              searchTitle: 'tasks_label_fioSearch'.tr,
              listTitle: 'label_chooseOption'.tr,
              disabled: false,
            ),
          )
        ],
      ),
    );
  }
}
