import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/view_models/additional_field_view_model.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_create_controller.dart';
import 'package:rns_app/app/utils/helper_utils.dart';

class DescriptionTabController extends GetxController {
  static DescriptionTabController get to => Get.find();

  final TextEditingController briefController = TextEditingController();
  final FocusNode briefFocus = FocusNode();
  final TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionFocus = FocusNode();
  final RxList<AdditionalFieldViewModel> additionalFields = <AdditionalFieldViewModel>[].obs;
  final RxnString briefError = RxnString(null);

  late ScrollController scrollController;

  @override
  void onInit() {
    scrollController = ScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    briefController.addListener(() {
      if (briefController.text.isNotEmpty && briefError.value != null) briefError.value = null;
    });
    briefFocus.addListener(
        () => HelperUtils.hideBottomSheetActionButton(briefFocus, TasksCreateController.to.hideActionButton));
    descriptionFocus.addListener(
        () => HelperUtils.hideBottomSheetActionButton(descriptionFocus, TasksCreateController.to.hideActionButton));
    super.onReady();
  }

  @override
  void onClose() {
    briefController.dispose();
    descriptionController.dispose();
    briefFocus.dispose();
    descriptionFocus.dispose();
    additionalFields.map((element) {
      element.controller.dispose();
      element.focusNode.dispose();
    });
    scrollController.dispose();
    super.onClose();
  }

  void prepareAdditionalFields() {
    if (TasksCreateController.to.formInitialData?.additionalFields != null &&
        TasksCreateController.to.formInitialData!.additionalFields.isNotEmpty) {
      for (var element in TasksCreateController.to.formInitialData!.additionalFields) {
        final TextEditingController textController = TextEditingController();
        final FocusNode focusNode = FocusNode();

        // Добавим listener
        focusNode.addListener(
            () => HelperUtils.hideBottomSheetActionButton(focusNode, TasksCreateController.to.hideActionButton));

        final Rxn<String> errorMessage = Rxn(null);
        if (element.isObligatory) {
          textController.addListener(() => _inputListener(textController, errorMessage));
        }
        additionalFields.add(AdditionalFieldViewModel(
          item: element,
          controller: textController,
          focusNode: focusNode,
          error: errorMessage,
        ));
      }

      additionalFields.refresh();
    }
  }

  void _inputListener(TextEditingController controller, Rxn<String> errorMessage) {
    if (controller.text.isNotEmpty && errorMessage.value != null) {
      errorMessage.value = null;
    }
  }

  void resetDescriptionFormTab() {
    briefController.text = '';
    descriptionController.text = '';
    briefError.value = null;

    if (additionalFields.isNotEmpty) {
      for (var additionalField in additionalFields) {
        additionalField.controller.dispose();
      }

      additionalFields.clear();
      additionalFields.refresh();
    }
  }
}
