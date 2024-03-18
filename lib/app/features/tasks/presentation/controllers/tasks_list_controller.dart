import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_model.dart';
import 'package:rns_app/app/features/tasks/domain/models/tasks_filter_model.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/routes/app_pages.dart';

class TasksListController extends GetxController {
  final _repository = RepositoryModule.tasksRepository();

  final int limit = 10;
  int page = 1;

  final RxBool loadingData = false.obs;
  final RxBool loadingError = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool refreshing = false.obs;

  final RxBool debounceWarningSnack = false.obs;

  final RxList<Task> tasks = <Task>[].obs;

  String errorMessage = '';
  bool noMoreToLoad = false;

  @override
  void onReady() {
    HomeController.to.scrollController.addListener(_scrollListener);

    // Пришлось вынести оповещение об успешном создании задачи в этот контроллер.
    // из-за наслоения Get-окон происходила путаница и успешное уведомление в некоторых случаях закрывалось
    // до своего появления на экране
    if (TasksController.to.closeOverlays == true && TasksController.to.taskWasCreated == true) {
      Get.back(closeOverlays: true);
      TasksController.to.closeOverlays = false;
      SnackbarService.success('tasks_message_createSuccess'.tr);
    }

    _getData();
    super.onReady();
  }

  @override
  void onClose() {
    HomeController.to.scrollController.removeListener(_scrollListener);
    super.onClose();
  }

  Future<void> _getData({bool loadingMore = false, bool pullToRefresh = false}) async {
    int _pageToLoad = page;
    if (!loadingMore && !pullToRefresh) {
      loadingData.value = true;
    } else if (loadingMore) {
      _pageToLoad = page + 1;
    }
    final TasksFilterModel filters = TasksController.to.filters.value;
    try {
      final List<Task> newItems = await _repository.getTasks(
        filter: filters,
        limit: limit,
        page: _pageToLoad,
      );

      if (newItems.isEmpty) {
        noMoreToLoad = true;
      } else if (loadingMore) {
        page = _pageToLoad;
        final List<Task> updatedItems = List.from(tasks);
        updatedItems.addAll(newItems);
        tasks.value = updatedItems;
      } else {
        tasks.value = newItems;
        tasks.refresh();
      }
    } catch (e) {
      errorMessage = e.toString().cleanException();
      loadingError.value = true;
    }

    TasksController.to.checkFiltersActive();

    loadingData.value = false;
    isLoadingMore.value = false;
  }

  Future<void> _scrollListener() async {
    if (HomeController.to.scrollController.position.maxScrollExtent - HomeController.to.scrollController.offset <
            220.0 &&
        HomeController.to.scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (isLoadingMore.value) {
        return;
      }

      if (!noMoreToLoad) {
        isLoadingMore.value = true;
        await _getData(loadingMore: true);
      }
    }

    if (HomeController.to.scrollController.position.userScrollDirection == ScrollDirection.forward &&
        HomeController.to.scrollController.offset < -125) {
      if (refreshing.value) {
        return;
      } else {
        refreshing.value = true;
        HomeController.to.disableScroll.value = true;
        // сбросим все значения
        page = 1;
        noMoreToLoad = false;
        // Без этой задержки происходит дергание элементов, когда их мало или нет
        // из-за быстрого ответа от сервера
        await Future.delayed(const Duration(milliseconds: 300), () async {
          await _getData(pullToRefresh: true).then((value) {
            refreshing.value = false;
            HomeController.to.disableScroll.value = false;
          });
        });
      }
    }
  }

  void refreshPage() {
    page = 1;
    noMoreToLoad = false;
    _getData();
  }

  void openDetailView(int index) {
    TasksController.to.detailTaskId = tasks[index].id;
    TasksController.to.currentRoute.value = Routes.TASKSDETAIL;
  }
}
