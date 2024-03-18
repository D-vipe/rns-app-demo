import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/home/domain/models/user_model.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/tasks/domain/models/tasks_filter_model.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/filter/components/tasks_filter_bottomsheet.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/helper_utils.dart';
import 'package:rns_app/app/utils/hive_service.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class TasksFilterController extends GetxController with GetSingleTickerProviderStateMixin {
  static TasksFilterController get to => Get.find();

  final User? user = HiveService.getUser();

  final List<SelectObject> unmodifiedExecutors = <SelectObject>[];
  final List<SelectObject> unmodifiedProjects = <SelectObject>[];

  final RxList<SelectObject> executors = <SelectObject>[].obs;
  final RxList<SelectObject> projects = <SelectObject>[].obs;
  final RxList<SelectObject> statuses = <SelectObject>[].obs;

  // контроллеры, с помощью которых будет отображаться выбранное значение
  final TextEditingController executorController = TextEditingController();
  final TextEditingController projectController = TextEditingController();
  final TextEditingController searchExecutor = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  final TextEditingController searchProject = TextEditingController();

  final Rxn<SelectObject> radioExecutor = Rxn(null);
  final Rxn<SelectObject> radioProject = Rxn(null);

  final Rxn<SelectObject> selectedExecutor = Rxn(null);
  final Rxn<SelectObject> selectedProject = Rxn(null);
  final Rxn<SelectObject> selectedStatus = Rxn(null);

  final RxBool loadingData = false.obs;
  final RxBool applyingFilters = false.obs;
  final RxBool noExecutor = false.obs;
  final RxBool onlyNew = false.obs;
  final RxBool hideFiltersActionBtn = false.obs;

  final Rxn<String> projectError = Rxn(null);
  final Rxn<String> executorError = Rxn(null);

  final RxBool searching = false.obs;
  final RxBool debounceClearSearchable = false.obs;

  Timer? _debouncer;
  String previousSearch = '';

  final _repository = RepositoryModule.tasksRepository();

  User? get _user => TasksController.to.user;
  List<String> combinedError = [];
  SelectObject? noExecutorData;

  late AnimationController animationController;

  @override
  void onInit() {
    _initAnimationController();
    super.onInit();
  }

  @override
  void onReady() {
    _prepareFilters();
    searchExecutor
        .addListener(() => _searchList(data: executors, input: searchExecutor, unmodifiedData: unmodifiedExecutors));
    searchProject
        .addListener(() => _searchList(data: projects, input: searchProject, unmodifiedData: unmodifiedProjects));

    selectedExecutor
        .listen((_) => selectedExecutor.value == null ? null : executorController.text = selectedExecutor.value!.title);

    selectedProject
        .listen((_) => selectedProject.value == null ? null : projectController.text = selectedProject.value!.title);

    searchFocus.addListener(() => HelperUtils.hideBottomSheetActionButton(searchFocus, hideFiltersActionBtn));

    final TasksFilterModel filters = TasksController.to.filters.value;
    // Проверим значения фильтра в TimeSheetController
    selectedExecutor.value = filters.executor;
    radioExecutor.value = filters.executor != noExecutorData ? filters.executor : null;
    selectedProject.value = filters.project;
    radioProject.value = filters.project;
    selectedStatus.value = filters.status;
    noExecutor.value = filters.noExecutor;
    onlyNew.value = filters.isNewTask ?? false;

    HomeController.to.floatingActionBtn.value = SizedBox(
      width: Get.width - AppConstraints.screenPadding * 2,
      child: AppButton(
        label: 'tasks_button_showTasks'.tr,
        onTap: applyFilters,
        processing: applyingFilters.value,
      ),
    );
    super.onReady();
  }

  @override
  void onClose() {
    HomeController.to.disableScroll.value = false;
    animationController.dispose();
    executorController.dispose();
    projectController.dispose();
    searchExecutor.dispose();
    searchProject.dispose();
    searchFocus.dispose();

    super.onClose();
  }

  void _initAnimationController() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> _prepareFilters() async {
    loadingData.value = true;
    await Future.wait([
      getAvailableExecutors(),
      getAvailableProjects(),
      _getStatuses(),
    ]).then((_) {
      if (combinedError.isNotEmpty) {
        SnackbarService.error(combinedError.join('\n'), duration: 10);
      }
    });
    loadingData.value = false;
  }

  Future<void> getAvailableExecutors() async {
    try {
      final (List<SelectObject>, String?) data = await _repository.getExecutors();
      executors.value = data.$1;
      if (data.$2 != null) {
        noExecutorData = SelectObject(id: data.$2!, title: 'tasks_label_noExecutor'.tr);
      }
    } catch (e) {
      combinedError.add(e.toString().cleanException());
    }
    unmodifiedExecutors.clear();
    unmodifiedExecutors.addAll(List<SelectObject>.from(executors));
  }

  Future<void> getAvailableProjects() async {
    try {
      projects.value = await _repository.getProjects();
    } catch (e) {
      combinedError.add(e.toString().cleanException());
    }
    unmodifiedProjects.clear();
    unmodifiedProjects.addAll(List<SelectObject>.from(projects));
  }

  Future<void> _getStatuses() async {
    try {
      statuses.value = await _repository.getStatuses();
      statuses.refresh();
    } catch (e) {
      combinedError.add(e.toString().cleanException());
    }
  }

  Future<void> _searchList(
      {required RxList<SelectObject> data,
      required TextEditingController input,
      required List<SelectObject> unmodifiedData}) async {
    if (_debouncer != null && _debouncer!.isActive) {
      _debouncer!.cancel();
    }

    _debouncer = Timer(const Duration(seconds: 1), () {
      List<SelectObject> filteredList = [];

      if (input.text.isNotEmpty && previousSearch != input.text) {
        FocusScope.of(Get.context!).unfocus();
        if (data.isEmpty) {
          searching.value = true;
        }
        animationController.reverse().then((value) {
          searching.value = true;
          data.value = [];

          for (var item in unmodifiedData) {
            if (item.title.toLowerCase().contains(input.text.toLowerCase())) {
              filteredList.add(item);
            }
          }

          data.value = filteredList;
          searching.value = false;
          animationController.forward();
        });
      } else if (input.text.isEmpty && previousSearch != input.text) {
        FocusScope.of(Get.context!).unfocus();
        animationController.reverse().then((value) {
          searching.value = true;
          data.value = [];
          data.value = List<SelectObject>.from(unmodifiedData);
          searching.value = false;
          animationController.forward();
        });
      }

      previousSearch = input.text;
    });
  }

  void applySelectedValue(SelectType type) {
    if (type == SelectType.user) {
      if (noExecutor.value) {
        selectedExecutor.value = noExecutorData;
        radioExecutor.value = null;
      } else {
        radioExecutor.value = user != null
            ? (executors.firstWhereOrNull((element) => element == SelectObject(id: user!.id, title: user!.fio)) ??
                executors.first)
            : executors.first;
        selectedExecutor.value = user != null
            ? (executors.firstWhereOrNull((element) => element == SelectObject(id: user!.id, title: user!.fio)) ??
                executors.first)
            : executors.first;
      }
    }

    if (type == SelectType.project) {
      selectedProject.value = radioProject.value;
    }
  }

  void selectStatus(SelectObject? value) {
    if (value == selectedStatus.value) {
      selectedStatus.value = null;
    } else {
      selectedStatus.value = value;
    }
  }

  void onExecutorChange(bool? value, int index) {
    radioExecutor.value = executors[index];
    executorError.value = null;
  }

  void onProjectChange(bool? value, int index) {
    radioProject.value = projects[index];
    projectError.value = null;
  }

  void clearSelectFilter(SelectType type) {
    switch (type) {
      case SelectType.user:
        if (_user != null) {
          radioExecutor.value = SelectObject(id: _user!.id, title: _user!.fio);
          selectedExecutor.value = SelectObject(id: _user!.id, title: _user!.fio);
          noExecutor.value = false;
        } else {
          radioExecutor.value = null;
          selectedExecutor.value = null;
          noExecutor.value = false;
        }

        searchExecutor.text = '';
        executors.value = List<SelectObject>.from(unmodifiedExecutors);

        break;
      case SelectType.project:
        radioProject.value = null;
        selectedProject.value = null;

        searchProject.text = '';
        projects.value = List<SelectObject>.from(unmodifiedProjects);
        break;
      default:
        break;
    }

    if (!debounceClearSearchable.value) {
      debounceClearSearchable.value = true;
      SnackbarService.info('tasks_message_executorFilterCleared'.tr, snackDebounce: debounceClearSearchable);
    }
  }

  void openExtendedSelectModal(SelectType type) {
    Get.bottomSheet(
      TasksFilterBottomSheet(type: type),
      // backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: false,
    ).then((value) {
      animationController.reverse();
      // Очищаем строку поиска
      if (type == SelectType.user) {
        searchExecutor.text = '';
        executors.value = List<SelectObject>.from(unmodifiedExecutors);
        // В случае, если фильтр по сотруднику не был применен, сбросим на предыдущее значение
        radioExecutor.value = selectedExecutor.value;
      } else {
        searchProject.text = '';
        projects.value = List<SelectObject>.from(unmodifiedProjects);
        // В случае, если фильтр по сотруднику не был применен, сбросим на предыдущее значение
        radioProject.value = selectedProject.value;
      }
    });
    animationController.forward();
  }

  void clearFilters() {
    if (_user != null) {
      radioExecutor.value = SelectObject(id: _user!.id, title: _user!.fio);
      selectedExecutor.value = SelectObject(id: _user!.id, title: _user!.fio);
    } else {
      radioExecutor.value = null;
      selectedExecutor.value = null;
      executorController.text = '';
    }
    noExecutor.value = false;
    selectedProject.value = null;
    selectedStatus.value = null;

    projectController.text = '';
    radioProject.value = null;

    searchExecutor.text = '';
    searchProject.text = '';

    onlyNew.value = false;
  }

  void applyFilters() {
    applyingFilters.value = true;

    TasksController.to.filters.value = TasksController.to.filters.value.copyWith(
      executor: selectedExecutor.value,
      status: selectedStatus.value,
      project: selectedProject.value,
      noExecutor: noExecutor.value,
      isNewTask: onlyNew.value,
    );

    TasksController.to.showListScreen();
  }
}
