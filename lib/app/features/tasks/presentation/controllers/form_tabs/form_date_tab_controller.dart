import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_create_controller.dart';
import 'package:rns_app/app/utils/helper_utils.dart';

class DateFormTabController extends GetxController {
  static DateFormTabController get to => Get.find();

  final Rxn<DateTime> deadlineDate = Rxn(null);
  final TextEditingController deadlineDateController = TextEditingController();
  final TextEditingController deadlineTimeController = TextEditingController();
  final Rxn<DateTime> plannedStartDate = Rxn(null);
  final TextEditingController plannedStartDateController = TextEditingController();
  final TextEditingController plannedStartimeController = TextEditingController();
  final TextEditingController totalTimeController = TextEditingController();
  final TextEditingController totalDevelopmentTimeController = TextEditingController();
  final TextEditingController totalTestTimeController = TextEditingController();
  final Rxn<String> deadlineDateError = Rxn(null);

  final deadlineDateFocus = FocusNode();
  final plannedstartDateFocus = FocusNode();
  final plannedTimeFocus = FocusNode();
  final developmentTimeFocus = FocusNode();
  final testingTimeFocus = FocusNode();

  late final ScrollController scrollController;

  @override
  void onInit() {
    scrollController = ScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    deadlineDate.listen((_) => _dedadLineListener());
    plannedStartDate.listen((_) => _dedadLineListener());
    deadlineDateFocus.addListener(
        () => HelperUtils.hideBottomSheetActionButton(deadlineDateFocus, TasksCreateController.to.hideActionButton));
    plannedstartDateFocus.addListener(() =>
        HelperUtils.hideBottomSheetActionButton(plannedstartDateFocus, TasksCreateController.to.hideActionButton));
    plannedTimeFocus.addListener(
        () => HelperUtils.hideBottomSheetActionButton(plannedTimeFocus, TasksCreateController.to.hideActionButton));
    developmentTimeFocus.addListener(
        () => HelperUtils.hideBottomSheetActionButton(developmentTimeFocus, TasksCreateController.to.hideActionButton));
    testingTimeFocus.addListener(
        () => HelperUtils.hideBottomSheetActionButton(testingTimeFocus, TasksCreateController.to.hideActionButton));
    super.onReady();
  }

  @override
  void onClose() {
    deadlineDateController.dispose();
    deadlineTimeController.dispose();
    plannedStartDateController.dispose();
    plannedStartimeController.dispose();
    totalTimeController.dispose();
    totalDevelopmentTimeController.dispose();
    totalTestTimeController.dispose();
    deadlineDateFocus.dispose();
    plannedstartDateFocus.dispose();
    plannedTimeFocus.dispose();
    developmentTimeFocus.dispose();
    testingTimeFocus.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _dedadLineListener() {
    if (deadlineDate.value != null &&
        plannedStartDate.value != null &&
        deadlineDate.value!.isBefore(plannedStartDate.value!)) {
      deadlineDateError.value = 'tasks_error_deadline'.tr;
    } else {
      deadlineDateError.value = null;
    }
  }

  void pickDate(Rxn<DateTime> modifiedValue, TextEditingController input) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final locale = Get.locale;

    modifiedValue.value = await showDatePicker(
      context: Get.context!,
      initialDate: modifiedValue.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.utc(2100),
      locale: locale,
    ).then((value) {
      if (value != null) {
        input.text = DateFormat('dd.MM.yyyy').format(value);
      }
      return value;
    });
  }

  void resetDateFormTab() {
    deadlineDate.value = null;
    deadlineDateController.text = '';
    deadlineTimeController.text = '';
    plannedStartDate.value = null;
    plannedStartDateController.text = '';
    plannedStartimeController.text = '';
    totalTimeController.text = '';
    totalDevelopmentTimeController.text = '';
    totalTestTimeController.text = '';
    deadlineDateError.value = null;
  }
}
