import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_detail_model.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_detail_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/detail/tabs/components/status_block_widget.dart';
import 'package:rns_app/app/uikit/form_widgets/select/custom_select_bottom_modal.dart';
import 'package:rns_app/app/uikit/form_widgets/select/single_select_widget.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';

class GeneralTabController extends GetxController with GetTickerProviderStateMixin {
  final Rxn<TaskDetail> data = Rxn(null);
  final Rxn<SelectObject> selectedNewStatus = Rxn(null);
  final Rxn<SelectObject> selectedNewExecutor = Rxn(null);
  final Rxn<SelectObject> radioExecutor = Rxn(null);

  TasksDetailController get _parentController => TasksDetailController.to;

  final TextEditingController searchController = TextEditingController();

  late ScrollController scrollController;
  late AnimationController animationController;

  Timer? _debouncer;
  String previousSearch = '';
  final RxBool searching = false.obs;
  final RxBool processingUpdate = false.obs;
  final RxBool applyChangesDebouncer = false.obs;

  @override
  void onInit() {
    _initAnimationController();
    scrollController = ScrollController();
    ever(TasksDetailController.to.data, (callback) => data.value = TasksDetailController.to.data.value);
    super.onInit();
  }

  @override
  void onReady() {
    scrollController.addListener(() => _parentController.scrollListener(scrollController));
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _initAnimationController() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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

  void onExecutorChange(bool? value, int index) {
    radioExecutor.value = _parentController.editExecutorList[index];
    selectedNewExecutor.value = _parentController.editExecutorList[index];
  }

  void openExtendedSelectModal(SelectType type) {
    if (type == SelectType.status) {
      searchController.addListener(
        () => _searchList(
            data: _parentController.editStatusList,
            input: searchController,
            unmodifiedData: _parentController.unmodifiedStatuses),
      );
    } else {
      searchController.addListener(
        () => _searchList(
            data: _parentController.editExecutorList,
            input: searchController,
            unmodifiedData: _parentController.unmodifiedExecutors),
      );
    }
    Get.bottomSheet(
      GestureDetector(
        onTap: () => FocusScope.of(Get.context!).unfocus(),
        child: Obx(
          () => CustomSelectBottomWidget(
            title: type == SelectType.user ? 'tasks_title_executor'.tr : 'tasks_label_status'.tr,
            clearHandler: () => clearSelectFilter(type),
            closeHandler: () {
              Get.back();
              // noExecutor.value = false;
            },
            saveHandler: () => applySelectedValue(type),
            processing: processingUpdate.value,
            children: [
              if (type == SelectType.status) const StatusBlockWidget(),
              if (type == SelectType.user)
                Obx(
                  () => SingleSelectWidget(
                    items: _parentController.editExecutorList,
                    refresher: () => _parentController.getData(),
                    onChange: onExecutorChange,
                    searchController: searchController,
                    selectedVal: radioExecutor.value,
                    loadingData: _parentController.loadingData.value,
                    error: '',
                    animationController: animationController,
                    searching: searching.value,
                    searchLabel: 'tasks_placeholder_search'.tr,
                    searchTitle: 'tasks_label_fioSearch'.tr,
                    listTitle: 'label_chooseOption'.tr,
                    disabled: false,
                  ),
                )
            ],
          ),
        ),
      ),
      // backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: false,
    ).then((value) {
      animationController.reverse();
      // Очищаем строку поиска
      searchController.text = '';
      if (type == SelectType.user) {
        _parentController.editExecutorList.value = List<SelectObject>.from(_parentController.unmodifiedExecutors);
      } else {
        _parentController.editStatusList.value = List<SelectObject>.from(_parentController.unmodifiedStatuses);
      }

      if (type == SelectType.status) {
        searchController.removeListener(
          () => _searchList(
              data: _parentController.editStatusList,
              input: searchController,
              unmodifiedData: _parentController.unmodifiedStatuses),
        );
      } else {
        searchController.removeListener(
          () => _searchList(
              data: _parentController.editExecutorList,
              input: searchController,
              unmodifiedData: _parentController.unmodifiedExecutors),
        );
      }
    });
    // Если у нас еще висит снэк с предыдущим предупреждением
    if (applyChangesDebouncer.value) {
      Get.closeAllSnackbars();
    }
    animationController.forward();
  }

  void clearSelectFilter(SelectType type) {
    switch (type) {
      case SelectType.user:
        radioExecutor.value = (data.value?.executor != null && data.value?.executorId != null)
            ? SelectObject(id: data.value!.executorId!, title: data.value!.executor!)
            : (data.value?.executor == null && data.value?.executorId != null)
                ? SelectObject(id: data.value!.executorId!, title: 'tasks_label_noExecutor'.tr)
                : null;
        selectedNewExecutor.value = null;

        break;
      case SelectType.status:
        selectedNewStatus.value = null;
        break;
      default:
        break;
    }

    searchController.text = '';
    // SnackbarService.info('tasks_message_executorFilterCleared'.tr, snackDebounce: debounceClearSearchable);
  }

  void selectStatus(SelectObject? value) {
    if (value == selectedNewStatus.value) {
      selectedNewStatus.value = null;
    } else {
      selectedNewStatus.value = value;
    }
  }

  Future<void> applySelectedValue(SelectType type) async {
    processingUpdate.value = true;
    if (type == SelectType.user) {
      if (selectedNewExecutor.value == null) {
        if (!applyChangesDebouncer.value) {
          applyChangesDebouncer.value = true;
          SnackbarService.error('tasks_error_noNewExecutor'.tr, snackDebounce: applyChangesDebouncer);
        }
      } else {
        try {
          final bool updatedExecutor = await _parentController.repository
              .editTaskExecutor(taskId: TasksController.to.detailTaskId!, executorId: selectedNewExecutor.value!.id);

          if (updatedExecutor) {
            // обновим значения на странице
            if (data.value != null) {
              data.value = data.value!
                  .copyWith(executor: selectedNewExecutor.value?.title, executorId: selectedNewExecutor.value?.id);
            }
            Get.back();
          } else {
            SnackbarService.error('error_general'.tr);
          }
        } catch (e) {
          final String cleanError = e.toString().cleanException();
          SnackbarService.error(cleanError);
        }
      }
    }

    if (type == SelectType.status) {
      if (selectedNewStatus.value != null) {
        try {
          final List<SelectObject>? updatedStatuses = await _parentController.repository.editTaskStatus(
              taskId: TasksController.to.detailTaskId!, statusId: int.parse(selectedNewStatus.value!.id));

          if (updatedStatuses != null) {
            _parentController.editStatusList.value = List.from(updatedStatuses);
            _parentController.unmodifiedStatuses.clear();
            _parentController.unmodifiedStatuses.addAll(List.from(updatedStatuses));

            // Необходимо запросить данные задачи повторно (мог измениться исполнитель);
            await TasksDetailController.to.getData();

            Get.back();
          } else {
            SnackbarService.error('error_general'.tr);
          }
        } catch (e) {
          final String cleanError = e.toString().cleanException();
          SnackbarService.error(cleanError);
        }
      } else {
        if (!applyChangesDebouncer.value) {
          applyChangesDebouncer.value = true;
          SnackbarService.error('tasks_error_noNewStatus'.tr, snackDebounce: applyChangesDebouncer);
        }
      }
    }

    processingUpdate.value = false;
  }
}
