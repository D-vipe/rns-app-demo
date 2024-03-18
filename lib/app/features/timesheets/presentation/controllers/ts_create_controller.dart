import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/timesheets/domain/enums/form_action.dart';
import 'package:rns_app/app/features/timesheets/domain/models/ts_item_model.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/timesheets_controller.dart';
import 'package:rns_app/app/uikit/dialogs/app_confirm_dialog.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/routes/app_pages.dart';

class TsCreateController extends GetxController {
  final _repository = RepositoryModule.tsRepository();

  static TsCreateController get to => Get.find();

  final RxList<SelectObject> projects = <SelectObject>[].obs;
  final RxList<SelectObject> tasks = <SelectObject>[].obs;
  final RxList<SelectObject> activities = <SelectObject>[].obs;

  final RxBool fetchingProjects = false.obs;
  final RxBool fetchingTasks = false.obs;
  final RxBool fetchingActivities = false.obs;

  final RxBool processingForm = false.obs;
  final RxBool preparingFromCopiedTsItem = false.obs;

  final Rxn<SelectObject> selectedProject = Rxn(null);
  final Rxn<SelectObject> selectedTask = Rxn(null);
  final Rxn<SelectObject> selectedActivity = Rxn(null);

  final RxnString projectError = RxnString(null);
  final RxnString taskError = RxnString(null);
  final RxnString activityError = RxnString(null);
  final RxnString dateError = RxnString(null);
  final RxnString timeGapError1 = RxnString(null);
  final RxnString timeGapError2 = RxnString(null);

  final RxBool debounceTasksSnack = false.obs;
  final RxBool debounceActivitiesSnack = false.obs;
  final RxBool debounceSendForm = false.obs;

  late TextEditingController searchController;

  late final TextEditingController dateController;
  late final TextEditingController timeStartController;
  late final TextEditingController timeEndController;
  late final TextEditingController descriptionController;

  late final FocusNode timeStartFN;
  late final FocusNode timeEndFN;
  late final FocusNode descriptionFN;

  late final ScrollController scrollController;

  final Rxn<DateTime> date = Rxn(DateTime.now());
  final dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void onInit() {
    scrollController = ScrollController();
    searchController = TextEditingController();
    dateController = TextEditingController();
    timeStartController = TextEditingController();
    timeEndController = TextEditingController();
    descriptionController = TextEditingController();

    timeStartFN = FocusNode()..addListener(_focusNodeListener);
    timeEndFN = FocusNode()..addListener(_focusNodeListener);
    descriptionFN = FocusNode()..addListener(_focusNodeListener);

    timeStartController.addListener(() => _timeGapListener());
    timeEndController.addListener(() => _timeGapListener(start: false));
    date.listen((_) => date.value == null ? null : dateController.text = DateFormat('dd.MM.yyyy').format(date.value!));
    super.onInit();
  }

  @override
  void onReady() {
    HomeController.to.enableScrollBody.value = true;
    _getProjects();
    dateController.text = DateFormat('dd.MM.yyyy').format(date.value!);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    dateController.dispose();
    searchController.dispose();
    timeStartController.dispose();
    timeEndController.dispose();
    descriptionController.dispose();

    timeStartFN.dispose();
    timeEndFN.dispose();
    descriptionFN.dispose();

    // Очистим данные контроллера списка о скопированном объекте
    // и сбросим тип формы на всякий случай
    TimeSheetController.to.formItem = null;
    TimeSheetController.to.formType = FormActionType.create;
    super.onClose();
  }

  void _focusNodeListener() async {
    if (timeStartFN.hasFocus || timeEndFN.hasFocus || descriptionFN.hasFocus) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 400));
      await Future.delayed(const Duration(milliseconds: 550), () async {
        await scrollController.animateTo(scrollController.position.maxScrollExtent,
            curve: Curves.easeIn, duration: const Duration(milliseconds: 400));
      });
    }

    if (!timeStartFN.hasFocus) {
      _isTimeGapValid();
    }

    if (!timeEndFN.hasFocus) {
      _isTimeGapValid(start: false);
    }
  }

  void _timeGapListener({bool start = true}) {
    if (start) {
      if (timeStartController.text.isNotEmpty && timeGapError1.value != null) {
        timeGapError1.value = null;
      }

      if (timeStartController.text.length == 5) {
        timeStartFN.unfocus();
      }
      // Значение начала времени выполнения не может быть больше конца
      if (timeEndController.text.isNotEmpty &&
          timeEndController.text.length == 5 &&
          timeStartController.text.length == 5) {
        final DateTime startDate = DateTime.parse('${dateFormat.format(date.value!)} ${timeStartController.text}');
        final DateTime endDate = DateTime.parse('${dateFormat.format(date.value!)} ${timeEndController.text}');

        if (startDate.isAfter(endDate)) {
          timeGapError1.value = 'timeSheets_error_startTime'.tr;
        }
      }
    } else {
      if (timeEndController.text.isNotEmpty && timeGapError2.value != null) {
        timeGapError2.value = null;
      }

      if (timeEndController.text.length == 5) {
        timeEndFN.unfocus();
      }

      // Значение конца времени выполнения не может быть меньше конца
      if (timeEndController.text.length == 5 &&
          timeStartController.text.length == 5 &&
          timeStartController.text.isNotEmpty) {
        final DateTime startDate = DateTime.parse('${dateFormat.format(date.value!)} ${timeStartController.text}');
        final DateTime endDate = DateTime.parse('${dateFormat.format(date.value!)} ${timeEndController.text}');

        if (startDate.isAfter(endDate)) {
          timeGapError2.value = 'timeSheets_error_endTime'.tr;
        }
      }
    }
  }

  Future<void> _getProjects() async {
    fetchingProjects.value = true;
    if (projects.isEmpty) {
      fetchingActivities.value = true;
      fetchingTasks.value = true;
    }
    try {
      projects.value = await _repository.getProjects();

      if (TimeSheetController.to.formItem != null) {
        await _prepareFormFromTsItem();
      }
    } catch (e) {
      final String errorMessage = e.toString().cleanException();
      SnackbarService.error(errorMessage);
    }
    fetchingProjects.value = false;
    fetchingActivities.value = false;
    fetchingTasks.value = false;
  }

  Future<void> _getActivitiesByTask() async {
    taskError.value = null;
    fetchingActivities.value = true;
    try {
      activities.value = await _repository.getActivities(
          projectId: int.tryParse(selectedProject.value!.id) ?? 0, taskId: int.tryParse(selectedTask.value!.id) ?? 0);

      if (activities.isNotEmpty && selectedActivity.value != null && !activities.contains(selectedActivity.value)) {
        selectedActivity.value = null;
      }
    } catch (e) {
      final String errorMessage = e.toString().cleanException();
      SnackbarService.error(errorMessage);
    }

    fetchingActivities.value = false;
  }

  Future<void> _getDataByProjectId() async {
    projectError.value = null;
    fetchingTasks.value = true;
    fetchingActivities.value = true;
    try {
      final (List<SelectObject>, List<SelectObject>) projectParams =
          await _repository.getProjectParams(projectId: int.tryParse(selectedProject.value!.id) ?? 0);

      if (projectParams.$1.isNotEmpty) {
        tasks.value = projectParams.$1;
        if (selectedTask.value != null && !tasks.contains(selectedTask.value)) {
          selectedTask.value = null;
        }
      } else {
        tasks.value = [];
      }

      if (projectParams.$2.isNotEmpty) {
        activities.value = projectParams.$2;
        if (selectedActivity.value != null && !activities.contains(selectedActivity.value)) {
          selectedActivity.value = null;
        }
      }
    } catch (e) {
      final String errorMessage = e.toString().cleanException();
      SnackbarService.error(errorMessage);
    }

    fetchingActivities.value = false;
    fetchingTasks.value = false;
  }

  Future<void> _prepareFormFromTsItem() async {
    preparingFromCopiedTsItem.value = true;
    bool errorsOccured = false;
    final TsItem copiedItem = TimeSheetController.to.formItem!;
    for (var project in projects) {
      if (project.title == copiedItem.projectTitle) {
        selectedProject.value = project;
        break;
      }
    }
    //  Если удалось найти проект, продолжаем
    await _getDataByProjectId();
    if (tasks.isNotEmpty) {
      for (var task in tasks) {
        if (task.title.contains('№ ${copiedItem.taskName}')) {
          selectedTask.value = task;
          break;
        }
      }
    }

    if (selectedTask.value != null) {
      await _getActivitiesByTask();
    }

    if (activities.isNotEmpty) {
      for (var activity in activities) {
        if (activity.title == copiedItem.workTypeName) {
          selectedActivity.value = activity;
          break;
        }
      }
    }

    // Обновим дату, возьмем из фильтра, так как по нему загружается список
    date.value = TimeSheetController.to.filters.value.date;

    // Если ТШ на редактирование, то надо обработать timeGap
    if (TimeSheetController.to.formType == FormActionType.edit) {
      final List<String> initialValue = copiedItem.timeGap.split(' ');
      // Первым элементом идет высчитанный промежуток. Он не нужен
      if (initialValue.length > 1) {
        final List<String> gaps = initialValue[1].split('-');
        timeStartController.text = gaps.first;
        timeEndController.text = gaps.last;
      }

      if (timeStartController.text.isEmpty || timeEndController.text.isEmpty) {
        errorsOccured = true;
      }
    }

    descriptionController.text = copiedItem.description;

    if (selectedTask.value == null || selectedActivity.value == null) {
      errorsOccured = true;
    }

    preparingFromCopiedTsItem.value = false;
    if (errorsOccured) {
      SnackbarService.warning(
        'timeSheets_error_processFormFromCopyFail'.tr,
      );
    }
  }

  void onChange(SelectObject? value, SelectType? selectType) async {
    switch (selectType) {
      case SelectType.project:
        if (value != selectedProject.value) {
          selectedProject.value = value;
          if (value != null) {
            await _getDataByProjectId();
          }
        }

        break;
      case SelectType.task:
        if (value != selectedTask.value) {
          selectedTask.value = value;
          if (value != null) {
            await _getActivitiesByTask();
          }
        }
        break;
      case SelectType.activity:
        if (value != null) {
          activityError.value = null;
        }
        selectedActivity.value = value;
        break;
      default:
        break;
    }
  }

  void disabledSelectWarning(SelectType selectType) async {
    switch (selectType) {
      case SelectType.task:
        if (tasks.isEmpty && debounceTasksSnack.value == false) {
          debounceTasksSnack.value = true;
          if (selectedProject.value == null) {
            SnackbarService.warning('timeSheets_messages_chooseProject'.tr, snackDebounce: debounceTasksSnack);
          } else {
            SnackbarService.warning('timeSheets_messages_noTasksAvailable'.tr, snackDebounce: debounceTasksSnack);
          }
          return;
        }
        break;
      case SelectType.activity:
        if (activities.isEmpty && debounceActivitiesSnack.value == false) {
          debounceActivitiesSnack.value = true;
          if (tasks.isEmpty) {
            SnackbarService.warning('timeSheets_messages_chooseProject'.tr, snackDebounce: debounceActivitiesSnack);
            return;
          }
          SnackbarService.warning('timeSheets_messages_chooseTask'.tr);
          return;
        }
        break;
      default:
        return;
    }
  }

  void pickDate() async {
    final locale = Get.locale;
    date.value = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.utc(2000),
      lastDate: DateTime.utc(2100),
      locale: locale,
    );
  }

  void resetForm() {
    // projects.value = [];
    tasks.value = [];
    activities.value = [];
    fetchingProjects.value = false;
    fetchingTasks.value = false;
    fetchingActivities.value = false;
    selectedProject.value = null;
    selectedTask.value = null;
    selectedActivity.value = null;
    projectError.value = null;
    taskError.value = null;
    activityError.value = null;
    timeGapError1.value = null;
    timeGapError2.value = null;
    debounceTasksSnack.value = false;
    debounceActivitiesSnack.value = false;
    timeStartController.text = '';
    timeEndController.text = '';
    descriptionController.text = '';
  }

  Future<void> createNewTS() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    processingForm.value = true;
    if (!_isFormValid()) {
      if (debounceSendForm.value == false) {
        debounceSendForm.value = true;
        SnackbarService.error('timeSheets_error_notValidForm'.tr, snackDebounce: debounceSendForm);
      }
    } else {
      try {
        final TsItem? copiedItem = TimeSheetController.to.formItem;
        final FormActionType formType = TimeSheetController.to.formType;
        final bool tsSaved = await _repository.createTimeSheet(
          projectId: int.tryParse(selectedProject.value!.id) ?? 0,
          taskId: int.tryParse(selectedTask.value!.id) ?? 0,
          workTypeId: int.tryParse(selectedActivity.value!.id) ?? 0,
          date: date.value!,
          start: DateTime.parse('${dateFormat.format(date.value!)} ${timeStartController.text}'),
          end: DateTime.parse('${dateFormat.format(date.value!)} ${timeEndController.text}'),
          comment: descriptionController.text,
          tsId: formType == FormActionType.edit ? copiedItem?.id : null,
        );

        if (tsSaved) {
          SnackbarService.success('timeSheets_messages_tsSaved'.tr);
          TimeSheetController.to.currentRoute.value = Routes.TSLIST;
          TimeSheetController.to.delegate.toNamed(Routes.TSLIST);
        } else {
          SnackbarService.error('timeSheets_error_save'.trParams({'value': ''}));
        }
      } catch (e) {
        final String errorMessage = e.toString().cleanException();
        SnackbarService.error(errorMessage);
      }
    }

    processingForm.value = false;
  }

  bool _isFormValid() {
    bool valid = true;
    if (selectedProject.value == null) {
      projectError.value = 'timeSheets_error_selectField'.tr;
      valid = false;
    }
    if (selectedTask.value == null) {
      taskError.value = 'timeSheets_error_selectField'.tr;
      valid = false;
    }

    if (selectedActivity.value == null) {
      activityError.value = 'timeSheets_error_selectField'.tr;
      valid = false;
    }
    if (date.value == null) {
      dateError.value = 'timeSheets_error_selectField'.tr;
      valid = false;
    }

    if (timeStartController.text.isEmpty) {
      timeGapError1.value = 'timeSheets_error_fieldEmpty'.tr;
      valid = false;
    } else {
      valid = valid = _isTimeGapValid(start: false);
    }

    if (timeEndController.text.isEmpty) {
      timeGapError2.value = 'timeSheets_error_fieldEmpty'.tr;
      valid = false;
    } else {
      valid = _isTimeGapValid(start: false);
    }

    return valid;
  }

  bool _isTimeGapValid({bool start = true}) {
    bool res = true;
    if (start) {
      if (timeStartController.text.isNotEmpty && timeStartController.text.length < 5) {
        timeGapError1.value = 'timeSheets_error_wrongFormat'.tr;
        res = false;
      }
    } else {
      if (timeEndController.text.isNotEmpty && timeEndController.text.length < 5) {
        timeGapError2.value = 'timeSheets_error_wrongFormat'.tr;
        res = false;
      }
    }
    return res;
  }

  Future<bool> quitTsCreateDialog() async {
    final bool? res = await Get.dialog(
      AppConfirmDialog(
        height: 250.0,
        message: 'timeSheets_messages_quitForm'.tr,
        confirmLabel: 'button_yes'.tr,
        cancelLabel: 'button_cancel'.tr,
      ),
      barrierColor: Colors.black.withOpacity(.6),
    );

    return res ?? false;
  }

  void dropSelectedProject() {
    selectedProject.value = null;
    selectedTask.value = null;
    selectedActivity.value = null;
    tasks.value = [];
    activities.value = [];
  }
}
