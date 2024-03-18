import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_detail_model.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/comment_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/files_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/general_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/detail/tabs/bugs_tab.dart';
import 'package:rns_app/app/features/tasks/presentation/views/detail/tabs/comments_tab.dart';
import 'package:rns_app/app/features/tasks/presentation/views/detail/tabs/files_tab.dart';
import 'package:rns_app/app/features/tasks/presentation/views/detail/tabs/task_tab.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/utils/extensions.dart';

class TasksDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  static TasksDetailController get to => Get.find();

  final repository = RepositoryModule.tasksRepository();

  final Rxn<TaskDetail> data = Rxn<TaskDetail>(null);
  final RxList<SelectObject> editStatusList = <SelectObject>[].obs;
  final RxList<SelectObject> editExecutorList = <SelectObject>[].obs;

  final List<SelectObject> unmodifiedExecutors = <SelectObject>[];
  final List<SelectObject> unmodifiedStatuses = <SelectObject>[];

  final RxBool loadingData = false.obs;
  final RxBool loadingError = false.obs;
  final RxBool processingUpdate = false.obs;
  final RxBool applyChangesDebouncer = false.obs;
  final RxBool refreshing = false.obs;
  final RxInt currentTabIndex = 0.obs;
  String errorMessage = '';

  double homeScrollPosition = 0.0;

  final List<String> detailTabTitles = [
    'tasks_tabs_task'.tr,
    'tasks_tabs_comments'.tr,
    'tasks_tabs_files'.tr,
    'tasks_tabs_bugs'.tr
  ];
  final List<Widget> detailTabs = const [TaskTab(), CommentsTab(), FilesTab(), BugsTab()];

  late TabController tabController;
  late ScrollController filesScrollController;
  late ScrollController bugsScrollController;

  @override
  void onInit() {
    Get.lazyPut(() => GeneralTabController());
    tabController = TabController(vsync: this, length: detailTabs.length);
    tabController.addListener(_tabSwitchListener);
    filesScrollController = ScrollController();
    bugsScrollController = ScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    getData();
    homeScrollPosition = HomeController.to.scrollController.offset;
    // Если не сделать этого, то позиция скрола сохраняется после перехода на детальную страницу и пропадает tabbar, контент уезжает наверх
    HomeController.to.scrollController.jumpTo(0);
    HomeController.to.disableScroll.value = true;
    super.onReady();
  }

  @override
  void onClose() {
    HomeController.to.disableScroll.value = false;
    tabController.dispose();
    filesScrollController.dispose();
    bugsScrollController.dispose();
    super.onClose();
  }

  void _tabSwitchListener() {
    if (!tabController.indexIsChanging) {
      currentTabIndex.value = tabController.index;
      switch (tabController.index) {
        case 1:
          HomeController.to.floatingActionBtn.value = FloatingActionButton(
            onPressed: CommentTabController.to.openAddCommentDialog,
            // mini: true,
            child: Icon(
              Icons.add,
              color: Get.context!.colors.white,
            ),
          );
          break;
        case 2:
          HomeController.to.floatingActionBtn.value = FloatingActionButton(
            onPressed: FilesTabController.to.openAddFileDialog,
            child: Icon(
              Icons.add,
              color: Get.context!.colors.white,
            ),
          );
          break;
        default:
          HomeController.to.floatingActionBtn.value = null;
          if (Get.isRegistered<CommentTabController>()) {
            CommentTabController.to.renderedIds.clear();
          }
          break;
      }
    }
  }

  Future<void> getData({bool refreshing = false}) async {
    if (!refreshing) loadingData.value = true;

    try {
      final (TaskDetail?, List<SelectObject>, List<SelectObject>) combinedData =
          await repository.getTaskDetail(taskId: TasksController.to.detailTaskId!);

      if (combinedData.$1 != null) {
        data.value = combinedData.$1;

        // radioExecutor.value = SelectObject(id: data.value!.executorId, title: data.value!.executor);
      }
      editStatusList.value = combinedData.$2;
      editExecutorList.value = combinedData.$3;

      unmodifiedExecutors.clear();
      unmodifiedStatuses.clear();
      unmodifiedStatuses.addAll(List<SelectObject>.from(editStatusList));
      unmodifiedExecutors.addAll(List<SelectObject>.from(editExecutorList));
    } catch (e) {
      final String cleanError = e.toString().cleanException();
      loadingError.value = true;
      errorMessage = cleanError;
    }

    if (!refreshing) loadingData.value = false;
  }

  Future<void> scrollListener(ScrollController scrollController) async {
    if (scrollController.position.userScrollDirection == ScrollDirection.forward && scrollController.offset < -125) {
      if (refreshing.value) {
        return;
      } else {
        refreshing.value = true;
        // Без этой задержки происходит дергание элементов, когда их мало или нет
        // из-за быстрого ответа от сервера
        await Future.delayed(const Duration(milliseconds: 300), () async {
          await getData(refreshing: true).then((value) {
            refreshing.value = false;
          });
        });
      }
    }
  }

  String getTabCounter(int index) {
    if (loadingData.value) {
      return detailTabTitles[index].toUpperCase();
    } else {
      if (data.value != null) {
        String counterString = '';
        switch (index) {
          case 1:
            final int commentCounter = data.value!.comments.length;
            counterString = commentCounter > 0 ? '($commentCounter)' : '';
            return '${detailTabTitles[index].toUpperCase()} $counterString';
          case 2:
            final int filesCounter = data.value!.files.length;
            counterString = filesCounter > 0 ? '($filesCounter)' : '';
            return '${detailTabTitles[index].toUpperCase()} $counterString';
          case 3:
            final int bugCounter = data.value!.bugs.length;
            counterString = bugCounter > 0 ? '(${data.value!.bugCount})' : '';
            return '${detailTabTitles[index].toUpperCase()} $counterString';
          default:
            return detailTabTitles[index].toUpperCase();
        }
      } else {
        return detailTabTitles[index].toUpperCase();
      }
    }
  }

  // void openAddCommentDialog() {}
}
