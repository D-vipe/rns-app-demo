import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_description_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/create/components/additional_field_widget.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class DescriptionFormTab extends GetView<DescriptionTabController> {
  const DescriptionFormTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        controller: controller.scrollController,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 24.0,
            ),
            Text(
              'tasks_label_brief'.tr,
              style: context.textStyles.header2,
            ),
            const SizedBox(
              height: 6.0,
            ),
            Obx(
              () => AppTextField(
                hintText: 'tasks_placeholder_brief'.tr,
                labelText: 'tasks_label_brief'.tr,
                textEditingController: controller.briefController,
                errorMessage: controller.briefError.value,
                focusNode: controller.briefFocus,
                fieldError: controller.briefError.value != null,
                maxLines: 3,
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Text(
              'tasks_label_description'.tr,
              style: context.textStyles.header2,
            ),
            const SizedBox(
              height: 6.0,
            ),
            AppTextField(
              hintText: 'tasks_placeholder_description'.tr,
              labelText: 'tasks_label_description'.tr,
              textEditingController: controller.descriptionController,
              focusNode: controller.descriptionFocus,
              errorMessage: null,
              fieldError: false,
              maxLines: 8,
            ),
            Obx(
              () => controller.additionalFields.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 12.0,
                        ),
                        ...List.generate(
                          controller.additionalFields.length,
                          (index) => DescriptionAdditionalField(
                            viewModel: controller.additionalFields[index],
                          ),
                        )
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 65.0),
          ],
        ),
      ),
    );
  }
}
