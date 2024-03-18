import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/tasks/domain/models/coexecutor_model.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_create.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_create_form.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_description_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_create_controller.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';

const int limit = 25;

class GeneralFormTabController extends GetxController with GetTickerProviderStateMixin {
  static GeneralFormTabController get to => Get.find();
  final repository = RepositoryModule.tasksRepository();

  final RxList<SelectObject> projects = <SelectObject>[].obs;
  final RxList<SelectObject> taskLifeCycles = <SelectObject>[].obs;
  final RxList<SelectObject> taskType = <SelectObject>[].obs;
  final RxList<SelectObject> urgencyList = <SelectObject>[].obs;
  final RxList<SelectObject> executorsList = <SelectObject>[].obs;
  final RxList<SelectObject> curatorsList = <SelectObject>[].obs;
  final RxList<SelectObject> spList = <SelectObject>[].obs;
  final RxList<SelectObject> stageList = <SelectObject>[].obs;
  final RxList<SelectObject> moduleList = <SelectObject>[].obs;
  final RxList<SelectObject> versionList = <SelectObject>[].obs;
  final RxList<SelectObject> initTypeList = <SelectObject>[].obs;

  final RxList<Rx<Coexecutor>> selectedCoexecutors = <Rx<Coexecutor>>[].obs;

  final Rxn<SelectObject> selectedProject = Rxn(null);
  final Rxn<SelectObject> selectedLifeCycle = Rxn(null);
  final Rxn<SelectObject> selectedTaskType = Rxn(null);
  final Rxn<SelectObject> selectedUrgency = Rxn(null);
  final Rxn<SelectObject> selectedExecutor = Rxn(null);
  final Rxn<SelectObject> selectedResponsible = Rxn(null);
  final Rxn<SelectObject> selectedInitiator = Rxn(null);
  final Rxn<SelectObject> selectedSp = Rxn(null);
  final Rxn<SelectObject> selectedModule = Rxn(null);
  final Rxn<SelectObject> selectedStage = Rxn(null);
  final Rxn<SelectObject> selectedVersion = Rxn(null);
  final Rxn<SelectObject> selectedInitType = Rxn(null);

  final RxBool loadingData = false.obs;
  final RxBool loadingDependentData = false.obs;
  final RxBool fetchingProjects = false.obs;
  final RxBool errorLoading = false.obs;

  final RxnString projectError = RxnString(null);
  final RxnString taskTypeError = RxnString(null);
  final RxnString lifeCycleError = RxnString(null);
  final RxnString responsibleError = RxnString(null);
  final RxnString executorError = RxnString(null);
  final RxnString initiatorError = RxnString(null);
  final RxnString urgencyError = RxnString(null);
  final RxnString spError = RxnString(null);
  final RxnString stageError = RxnString(null);
  final RxnString moduleError = RxnString(null);
  final RxnString versionError = RxnString(null);

  final RxBool isTaskError = false.obs;
  final RxBool isTaskPrioritet = false.obs;

  final RxBool debounceAddCoexecutorWarning = false.obs;

  late final ScrollController scrollController;

  @override
  void onInit() {
    scrollController = ScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    prepareFormData();
    _initCoexecutor();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    selectedCoexecutors.map((element) => element.value.animationController.dispose());
    super.onClose();
  }

  Future<void> prepareFormData() async {
    fetchingProjects.value = true;
    try {
      projects.value = await repository.getProjects();
    } catch (e) {
      errorLoading.value = true;
      SnackbarService.error(e.toString().cleanException());
    }

    fetchingProjects.value = false;
  }

  void _initCoexecutor() {
    selectedCoexecutors.add(
      Coexecutor(
              data: null,
              animationController: AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 500),
              ),
              showed: true)
          .obs,
    );

    selectedCoexecutors[0].value.animationController.forward();
  }

  Future<void> _getDataByProjectId() async {
    GeneralFormTabController.to.loadingDependentData.value = true;
    try {
      if (selectedProject.value != null) {
        selectedLifeCycle.value = null;
        selectedTaskType.value = null;
        selectedUrgency.value = null;
        selectedExecutor.value = null;
        selectedResponsible.value = null;
        selectedSp.value = null;
        selectedStage.value = null;
        selectedModule.value = null;
        selectedVersion.value = null;
        selectedInitType.value = null;

        isTaskError.value = false;
        isTaskPrioritet.value = false;

        DescriptionTabController.to.additionalFields.value = [];

        TasksCreateController.to.resetErrors();

        TasksCreateController.to.formInitialData =
            await repository.prepareFormData(projectId: selectedProject.value!.id);

        final TaskCreateForm? formData = TasksCreateController.to.formInitialData;
        if (TasksCreateController.to.formInitialData != null) {
          taskLifeCycles.value = formData!.taskLifeCycles;
          taskType.value = formData.taskTypes;
          urgencyList.value = formData.taskUrgencies;
          executorsList.value = formData.executors;
          curatorsList.value = formData.curators;
          spList.value = formData.taskSPs;
          stageList.value = formData.projectStages;
          moduleList.value = formData.taskModules;
          versionList.value = formData.versions;
          initTypeList.value = formData.taskInitTypes;

          // Подготовить предзаполненные поля
          _prepareFieldsFormTaskEntity(formData.task);

          // обновить Description tab
          DescriptionTabController.to.prepareAdditionalFields();
        }
      }
    } catch (e) {
      SnackbarService.error(e.toString().cleanException());
    }
    GeneralFormTabController.to.loadingDependentData.value = false;
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
      case SelectType.lifeCycle:
        if (value != selectedLifeCycle.value) {
          selectedLifeCycle.value = value;
        }
        break;
      case SelectType.taskType:
        if (value != null && taskTypeError.value != null) {
          taskTypeError.value = null;
        }
        selectedTaskType.value = value;
        break;
      case SelectType.urgency:
        if (value != null) {
          urgencyError.value = null;
        }
        selectedUrgency.value = value;
        break;
      case SelectType.responsible:
        if (value != null) {
          responsibleError.value = null;
        }
        selectedResponsible.value = value;
        break;
      case SelectType.executor:
        if (value != null) {
          executorError.value = null;
        }
        selectedExecutor.value = value;
        break;
      case SelectType.initiator:
        if (value != null) {
          initiatorError.value = null;
        }
        selectedInitiator.value = value;
        break;
      case SelectType.sp:
        if (value != null) {
          spError.value = null;
        }
        selectedSp.value = value;
        break;
      case SelectType.module:
        if (value != null) {
          moduleError.value = null;
        }
        selectedModule.value = value;
        break;
      case SelectType.stage:
        if (value != null) {
          stageError.value = null;
        }
        selectedStage.value = value;
        break;
      case SelectType.version:
        if (value != null) {
          versionError.value = null;
        }
        selectedVersion.value = value;
        break;
      case SelectType.initType:
        selectedInitType.value = value;
        break;
      default:
        break;
    }
  }

  void onCoexecutorSelect(SelectObject? value, int index) {
    selectedCoexecutors[index].value = selectedCoexecutors[index].value.copyWith(showed: true, data: value);
  }

  void coexecutorDrop(int index) {
    selectedCoexecutors[index].value = selectedCoexecutors[index].value.copyWith(showed: true, data: null);
  }

  void dropSelectedProject() {
    selectedProject.value = null;

    selectedLifeCycle.value = null;
    selectedTaskType.value = null;
    selectedUrgency.value = null;
    selectedExecutor.value = null;
    selectedResponsible.value = null;
    selectedInitiator.value = null;
    selectedSp.value = null;
    selectedStage.value = null;
    selectedModule.value = null;
    selectedVersion.value = null;
    selectedInitType.value = null;

    DescriptionTabController.to.additionalFields.value = [];
  }

  Future<void> addNewCoexecutor() async {
    if (!_checkCoexecutorsLength()) return;
    selectedCoexecutors.add(
      Coexecutor(
              data: null,
              animationController: AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 500),
              ),
              showed: false)
          .obs,
    );

    selectedCoexecutors.refresh();
    await Future.delayed(const Duration(milliseconds: 100), () {
      selectedCoexecutors.last.value =
          selectedCoexecutors.last.value.copyWith(showed: true, data: selectedCoexecutors.last.value.data);
      selectedCoexecutors.last.value.animationController.forward().then((value) => scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 200)));
    });
  }

  bool _checkCoexecutorsLength() {
    if (executorsList.isEmpty) {
      if (!debounceAddCoexecutorWarning.value) {
        debounceAddCoexecutorWarning.value = true;
        SnackbarService.warning('tasks_error_emptyCoexecutors'.tr, snackDebounce: debounceAddCoexecutorWarning);
      }

      return false;
    }
    if (selectedCoexecutors.length < limit) {
      return true;
    } else {
      SnackbarService.warning(
          'tasks_error_coexecutorsLength'.trParams({'limit': limit.toString(), 'icon': '\u{1F95A}'}));
      return false;
    }
  }

  Future<void> removeCoexecutor(int index) async {
    // Не удаляем элемент из массива, чтобы не ломать анимации
    selectedCoexecutors[index].value.animationController.reverse().then(
          (value) => selectedCoexecutors[index].value =
              selectedCoexecutors[index].value.copyWith(showed: false, data: selectedCoexecutors[index].value.data),
        );
  }

  void _prepareFieldsFormTaskEntity(TaskCreate data) {
    if (data.taskLifecycleId != null) {
      selectedLifeCycle.value =
          taskLifeCycles.firstWhereOrNull((element) => element.id == data.taskLifecycleId.toString());
    }

    if (data.taskTypeId != null) {
      selectedTaskType.value = taskType.firstWhereOrNull((element) => element.id == data.taskTypeId.toString());
    }

    if (data.urgencyId != null) {
      selectedUrgency.value = urgencyList.firstWhereOrNull((element) => element.id == data.urgencyId.toString());
    }

    if (data.curatorId != null) {
      selectedResponsible.value = curatorsList.firstWhereOrNull((element) => element.id == data.curatorId.toString());
    }

    if (data.initiatorId != null) {
      selectedInitiator.value = curatorsList.firstWhereOrNull((element) => element.id == data.initiatorId.toString());
    }

    if (data.executorId != null) {
      selectedExecutor.value = executorsList.firstWhereOrNull((element) => element.id == data.executorId.toString());
    }

    if (data.moduleId != null) {
      selectedModule.value = moduleList.firstWhereOrNull((element) => element.id == data.moduleId.toString());
    }

    if (data.taskSPId != null) {
      selectedSp.value = spList.firstWhereOrNull((element) => element.id == data.taskSPId.toString());
    }

    if (data.projectStageId != null) {
      selectedStage.value = stageList.firstWhereOrNull((element) => element.id == data.projectStageId.toString());
    }

    if (data.versionId != null) {
      selectedVersion.value = versionList.firstWhereOrNull((element) => element.id == data.versionId.toString());
    }

    if (data.initTypeId != null) {
      selectedInitType.value = initTypeList.firstWhereOrNull((element) => element.id == data.initTypeId.toString());
    }

    isTaskError.value = data.isError;
    isTaskPrioritet.value = data.isPriopritet;
  }

  void resetGeneralFormTab() {
    taskLifeCycles.value = [];
    taskType.value = [];
    urgencyList.value = [];
    executorsList.value = [];
    curatorsList.value = [];
    spList.value = [];
    stageList.value = [];
    moduleList.value = [];
    versionList.value = [];
    initTypeList.value = [];

    selectedCoexecutors.value = [];

    selectedProject.value = null;
    selectedLifeCycle.value = null;
    selectedTaskType.value = null;
    selectedUrgency.value = null;
    selectedExecutor.value = null;
    selectedResponsible.value = null;
    selectedInitiator.value = null;
    selectedSp.value = null;
    selectedModule.value = null;
    selectedStage.value = null;
    selectedVersion.value = null;
    selectedInitType.value = null;

    projectError.value = null;
    lifeCycleError.value = null;
    taskTypeError.value = null;
    responsibleError.value = null;
    executorError.value = null;
    initiatorError.value = null;
    urgencyError.value = null;
    spError.value = null;
    stageError.value = null;
    moduleError.value = null;
    versionError.value = null;

    isTaskError.value = false;
    isTaskPrioritet.value = false;
  }
}
