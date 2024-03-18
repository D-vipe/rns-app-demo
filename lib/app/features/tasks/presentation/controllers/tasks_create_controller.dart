import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_create_form.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_date_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_description_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_files_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_general_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/view_models/added_file_view_model.dart';
import 'package:rns_app/app/features/tasks/presentation/views/create/components/tabs/date_form_tab.dart';
import 'package:rns_app/app/features/tasks/presentation/views/create/components/tabs/description_form_tab.dart';
import 'package:rns_app/app/features/tasks/presentation/views/create/components/tabs/file_form_tab.dart';
import 'package:rns_app/app/features/tasks/presentation/views/create/components/tabs/general_form_tab.dart';
import 'package:rns_app/app/features/tasks/presentation/views/create/components/uploading_snack.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/dialogs/app_confirm_dialog.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/routes/app_pages.dart';

class TasksCreateController extends GetxController with GetSingleTickerProviderStateMixin {
  static TasksCreateController get to => Get.find();
  final repository = RepositoryModule.tasksRepository();

  TaskCreateForm? formInitialData;

  final RxBool processingForm = false.obs;
  final RxBool hideActionButton = false.obs;

  final RxInt currentTabIndex = 0.obs;
  final RxInt uploadingProgress = 0.obs;

  final Rxn<String> errorMessage = Rxn(null);
  final RxBool validationErrorDebouncer = false.obs;

  late TabController tabController;

  final List<Widget> formTabs = const [GeneralFormTab(), DateFormTab(), DescriptionFormTab(), FileFormTab()];
  final List<String> tabTitles = [
    'tasks_createTab_general'.tr,
    'tasks_createTab_deadline'.tr,
    'tasks_createTab_description'.tr,
    'tasks_createTab_docs'.tr,
  ];

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: formTabs.length);
    tabController.addListener(_tabSwitchListener);
    super.onInit();
  }

  @override
  void onReady() {
    HomeController.to.enableScrollBody.value = true;
    HomeController.to.disableScroll.value = true;
    super.onReady();
  }

  @override
  void onClose() {
    HomeController.to.disableScroll.value = false;
    HomeController.to.enableScrollBody.value = false;
    super.onClose();
  }

  void _tabSwitchListener() {
    if (!tabController.indexIsChanging) {
      hideActionButton.value = false;
      currentTabIndex.value = tabController.index;
    }
  }

  void resetForm() {
    GeneralFormTabController.to.resetGeneralFormTab();
    DateFormTabController.to.resetDateFormTab();
    DescriptionTabController.to.resetDescriptionFormTab();
    FormFilesTabController.to.resetFilesFormTab();
  }

  Future<void> saveTask() async {
    processingForm.value = true;
    if (_validateForm()) {
      final GeneralFormTabController general = GeneralFormTabController.to;
      final DescriptionTabController description = DescriptionTabController.to;
      final DateFormTabController dateTab = DateFormTabController.to;
      final FormFilesTabController filesTab = FormFilesTabController.to;

      Get.dialog(
        const Loader(
          btn: true,
        ),
        barrierDismissible: false,
      );

      try {
        Map<String, String> dopFields = {};

        if (description.additionalFields.isNotEmpty) {
          for (var element in description.additionalFields) {
            dopFields[element.item.id.toString()] = element.controller.text;
          }
        }

        final List<String> dopExecutorsIds = [];

        for (var exec in general.selectedCoexecutors) {
          if (exec.value.data != null) {
            dopExecutorsIds.add(exec.value.data!.id);
          }
        }

        final int? result = await repository.createTask(
          id: formInitialData?.task.id,
          projectId: general.selectedProject.value!.id,
          taskTypeId: general.selectedTaskType.value?.id,
          urgencyId: general.selectedUrgency.value?.id,
          taskLifecycleId: general.selectedLifeCycle.value?.id,
          curatorId: general.selectedResponsible.value?.id,
          initiatorId: general.selectedInitiator.value?.id,
          executorId: general.selectedExecutor.value?.id,
          moduleId: general.selectedModule.value?.id,
          taskSPId: general.selectedSp.value?.id,
          projectStageId: general.selectedStage.value?.id,
          versionId: general.selectedVersion.value?.id,
          isError: general.isTaskError.value,
          isPriopritet: general.isTaskPrioritet.value,
          initTypeId: general.selectedInitType.value?.id,
          deadline: dateTab.deadlineDate.value,
          deadlineTime: dateTab.deadlineTimeController.text,
          plannedDate: dateTab.plannedStartDate.value,
          plannedDateTime: dateTab.plannedStartimeController.text,
          planTime: dateTab.totalTimeController.text,
          plannedTimeDevelop: dateTab.totalTimeController.text,
          plannedTimeTest: dateTab.totalTimeController.text,
          dopExecutors: dopExecutorsIds,
          brief: description.briefController.text,
          description: description.descriptionController.text,
          dopFields: dopFields,
        );

        if (result != null) {
          // Создадим новый массив, убрав оттуда "удаленные элементы"
          final List<AddedFileViewModel> shownFiles = [];
          for (var pickedFile in filesTab.pickedFiles) {
            if (pickedFile.value.showed) {
              shownFiles.add(pickedFile.value);
            }
          }
          if (shownFiles.isNotEmpty) {
            final RxString fileName = ''.obs;
            final RxString filesCount = '1 / ${shownFiles.length}'.obs;
            _showUploadingSnack(fileName, uploadingProgress, filesCount);

            for (int index = 0; index < shownFiles.length; index++) {
              fileName.value = shownFiles[index].item.fileName;
              uploadingProgress.value = 0;
              filesCount.value = '${index + 1} / ${shownFiles.length}';

              try {
                await repository.uploadTaskFiles(
                    taskId: result,
                    fileTypeId: int.parse(shownFiles[index].fileType!.id),
                    description: shownFiles[index].commentController.text,
                    files: [shownFiles[index].item],
                    progressValue: uploadingProgress);

                if (index + 1 == shownFiles.length) {
                  TasksController.to.closeOverlays = true;
                  TasksController.to.taskWasCreated = true;
                  TasksController.to.currentRoute.value = Routes.TASKSLIST;
                }
              } catch (e) {
                SnackbarService.error(e.toString().cleanException());
              }
            }
          } else {
            TasksController.to.closeOverlays = true;
            TasksController.to.taskWasCreated = true;
            TasksController.to.currentRoute.value = Routes.TASKSLIST;
          }
        }
      } catch (e) {
        if (Get.isDialogOpen == true) {
          Get.back(closeOverlays: true);
        }
        SnackbarService.error(e.toString().cleanException());
      }
    }

    processingForm.value = false;
  }

  Future<bool> quitTsCreateDialog() async {
    final bool? res = await Get.dialog(
      AppConfirmDialog(
        height: 250.0,
        message: 'tasks_message_closeCreateForm'.tr,
        confirmLabel: 'button_yes'.tr,
        cancelLabel: 'button_cancel'.tr,
      ),
      barrierColor: Colors.black.withOpacity(.6),
    );

    return res ?? false;
  }

  bool _validateForm() {
    final GeneralFormTabController general = GeneralFormTabController.to;
    final DescriptionTabController description = DescriptionTabController.to;
    final FormFilesTabController filesTab = FormFilesTabController.to;

    bool res = true;
    if (general.selectedProject.value == null) {
      res = false;
      if (currentTabIndex.value != 0) {
        _reportGeneralTabError();
      }
      general.projectError.value = 'error_needInput'.tr;
    }

    if (general.selectedTaskType.value == null) {
      res = false;
      if (currentTabIndex.value != 0) {
        _reportGeneralTabError();
      }
      general.taskTypeError.value = 'error_needInput'.tr;
    }

    if (general.selectedLifeCycle.value == null) {
      res = false;
      if (currentTabIndex.value != 0) {
        _reportGeneralTabError();
      }
      general.lifeCycleError.value = 'error_selectField'.tr;
    }

    if (general.selectedResponsible.value == null) {
      res = false;
      if (currentTabIndex.value != 0) {
        _reportGeneralTabError();
      }
      general.responsibleError.value = 'error_needInput'.tr;
    }

    if (general.selectedExecutor.value == null && formInitialData?.isCanNoExecutor == false) {
      res = false;
      if (currentTabIndex.value != 0) {
        _reportGeneralTabError();
      }
      general.executorError.value = 'error_needInput'.tr;
    }

    if (general.selectedInitiator.value == null) {
      res = false;
      if (currentTabIndex.value != 0) {
        _reportGeneralTabError();
      }
      general.initiatorError.value = 'error_needInput'.tr;
    }

    if (formInitialData?.isSpObligatory == true && general.selectedSp.value == null) {
      res = false;
      if (currentTabIndex.value != 0) {
        _reportGeneralTabError();
      }
      general.spError.value = 'error_selectField'.tr;
    }

    if (formInitialData?.isStageObligatory == true && general.selectedStage.value == null) {
      res = false;
      if (currentTabIndex.value != 0) {
        _reportGeneralTabError();
      }
      general.stageError.value = 'error_selectField'.tr;
    }

    if (formInitialData?.isModuleObligatory == true && general.selectedModule.value == null) {
      res = false;
      if (currentTabIndex.value != 0) {
        _reportGeneralTabError();
      }
      general.moduleError.value = 'error_selectField'.tr;
    }

    if (formInitialData?.isVersionObligatory == true && general.selectedVersion.value == null) {
      res = false;
      if (currentTabIndex.value != 0) {
        _reportGeneralTabError();
      }
      general.versionError.value = 'error_selectField'.tr;
    }

    if (description.briefController.text == '') {
      res = false;
      if (currentTabIndex.value != 2) {
        if (validationErrorDebouncer.value == false) {
          validationErrorDebouncer.value = true;
          SnackbarService.error('tasks_error_formValidation'.trParams({'info': 'tasks_error_descriptionTab'.tr}),
              snackDebounce: validationErrorDebouncer);
        }
      }

      description.briefError.value = 'error_needInput'.tr;
    }

    if (description.additionalFields.isNotEmpty) {
      bool additionalFieldError = false;
      for (var additionalField in description.additionalFields) {
        if (additionalField.item.isObligatory && additionalField.controller.text.isEmpty) {
          res = false;
          additionalFieldError = true;
          additionalField.error.value = 'error_needInput'.tr;
        }
      }

      if (additionalFieldError) {
        if (currentTabIndex.value != 2) {
          if (validationErrorDebouncer.value == false) {
            validationErrorDebouncer.value = true;
            SnackbarService.error('tasks_error_formValidation'.trParams({'info': 'tasks_error_descriptionTab'.tr}),
                snackDebounce: validationErrorDebouncer);
          }
        }
      }
    }

    if (filesTab.pickedFiles.isNotEmpty) {
      for (int i = 0; i < filesTab.pickedFiles.length; i++) {
        if (filesTab.pickedFiles[i].value.fileType == null && filesTab.pickedFiles[i].value.showed == true) {
          res = false;
          final AddedFileViewModel copiedObject = filesTab.pickedFiles[i].value
              .copyWith(fileType: filesTab.pickedFiles[i].value.fileType, error: 'tasks_error_chooseFileType'.tr);
          filesTab.pickedFiles[i].value = copiedObject;
        }
      }

      filesTab.pickedFiles.refresh();

      if (currentTabIndex.value != 3) {
        _reportFilesTabError();
      }
    }

    return res;
  }

  void _reportGeneralTabError() {
    if (validationErrorDebouncer.value == false) {
      validationErrorDebouncer.value = true;
      SnackbarService.error('tasks_error_formValidation'.trParams({'info': 'tasks_error_generalTab'.tr}),
          snackDebounce: validationErrorDebouncer);
    }
  }

  void _reportFilesTabError() {
    if (validationErrorDebouncer.value == false) {
      validationErrorDebouncer.value = true;
      SnackbarService.error('tasks_error_formValidation'.trParams({'info': 'tasks_error_filesTab'.tr}),
          snackDebounce: validationErrorDebouncer);
    }
  }

  void resetErrors() {
    final GeneralFormTabController general = GeneralFormTabController.to;
    final DescriptionTabController description = DescriptionTabController.to;

    general.projectError.value = null;
    general.responsibleError.value = null;
    general.executorError.value = null;
    general.initiatorError.value = null;
    general.spError.value = null;
    general.stageError.value = null;
    general.moduleError.value = null;
    general.versionError.value = null;
    description.briefError.value = null;
  }

  void _showUploadingSnack(Rx<String> fileName, RxInt progress, RxString filesCount) {
    SnackbarService.uploadProgress(
      UploadingTaskFilesSnack(
        fileName: fileName,
        progress: progress,
        uploadCount: filesCount,
      ),
    );
  }
}
