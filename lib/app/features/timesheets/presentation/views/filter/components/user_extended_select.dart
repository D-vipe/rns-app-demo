import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/ts_filter_controller.dart';
import 'package:rns_app/app/uikit/form_widgets/select/custom_select_bottom_modal.dart';
import 'package:rns_app/app/uikit/form_widgets/select/single_select_widget.dart';

class UserExtendedSelect extends GetView<TSFilterController> {
  const UserExtendedSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
        () => GestureDetector(
          onTap: () => FocusScope.of(Get.context!).unfocus(),
          child: CustomSelectBottomWidget(
            title: 'timeSheets_employer'.tr,
            closeHandler: () => Get.back(),
            clearHandler: () => controller.clearEmployerFilter(),
            saveHandler: () {
              controller.applyEmployer();
              Get.back();
            },
            children: [
              SingleSelectWidget(
                items: controller.employersList,
                refresher: () => controller.getAvailableUsersList(),
                onChange: controller.onEmployerChange,
                searchController: controller.searchController,
                selectedVal: controller.radioEmployer.value,
                loadingData: controller.loadingData.value,
                error: controller.executorError.value,
                animationController: controller.animationController,
                searching: controller.searching.value,
                searchLabel: 'timeSheets_fioSearch'.tr,
                searchTitle: 'timeSheets_fioSearch'.tr,
                listTitle: 'timeSheets_projectEmployer'.tr,
                disabled: false,
              )
            ],
          ),
        ),
      );
  }
}
