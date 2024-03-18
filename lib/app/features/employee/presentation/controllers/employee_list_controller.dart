import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/employee/domain/model/employee_list_item.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';

class EmployeeListController extends GetxController {
  final _repository = RepositoryModule.employeeRepository();

  final int limit = 25;
  int page = 1;
  final RxBool loadingData = false.obs;
  final RxBool loadingError = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool refreshing = false.obs;

  final RxBool debounceWarningSnack = false.obs;

  final RxList<EmployeeListItem> itemList = <EmployeeListItem>[].obs;

  String errorMessage = '';
  bool noMoreToLoad = false;

  @override
  void onReady() {
    HomeController.to.scrollController.addListener(_scrollListener);
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
    // final TimeSheetFilterModel filters = TimeSheetController.to.filters.value;
    try {
      final List<EmployeeListItem> newItems = await _repository.getEmployees(
        fio: null,
        limit: limit,
        page: _pageToLoad,
      );

      if (newItems.isEmpty) {
        noMoreToLoad = true;
      } else if (loadingMore) {
        page = _pageToLoad;
        final List<EmployeeListItem> updatedItems = List.from(itemList);
        updatedItems.addAll(newItems);
        itemList.value = updatedItems;
      } else {
        itemList.value = newItems;
        itemList.refresh();
      }
    } catch (e) {
      errorMessage = e.toString().cleanException();
      loadingError.value = true;
    }

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
}
