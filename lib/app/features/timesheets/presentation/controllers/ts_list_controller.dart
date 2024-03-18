import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/timesheets/domain/enums/form_action.dart';
import 'package:rns_app/app/features/timesheets/domain/models/timesheet_filter_model.dart';
import 'package:rns_app/app/features/timesheets/domain/models/ts_item_model.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/timesheets_controller.dart';
import 'package:rns_app/app/features/timesheets/presentation/views/list/components/floating_action_button.dart';
import 'package:rns_app/app/features/timesheets/presentation/views/list/components/top_pinned_widget.dart';
import 'package:rns_app/app/uikit/dialogs/app_confirm_dialog.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/routes/app_pages.dart';

class TsListController extends GetxController {
  final _repository = RepositoryModule.tsRepository();

  final int limit = 10;
  int page = 1;
  final RxBool loadingData = false.obs;
  final RxBool loadingError = false.obs;
  final RxString selectedDate = ''.obs;
  final RxString totalTimesheetsTime = ''.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool refreshing = false.obs;

  final RxBool debounceWarningSnack = false.obs;

  final RxList<TsItem> tsList = <TsItem>[].obs;

  String errorMessage = '';
  bool noMoreToLoad = false;

  @override
  void onReady() {
    HomeController.to.scrollController.addListener(_scrollListener);
    HomeController.to.setTopPinnedWidget(
        widget: const TopPinnedWidgetTs(),
        leftPosition: Get.width / 2 - 58,
        bottomPosition: -46,
        topPosition: null,
        rightPosition: null);
    HomeController.to.floatingActionBtn.value = const TsFloatingActionButton();
    _getData();
    super.onReady();
  }

  @override
  void onClose() {
    HomeController.to.topPinnedWidget.value = null;
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
    final TimeSheetFilterModel filters = TimeSheetController.to.filters.value;
    try {
      final List<TsItem> newItems = await _repository.getTimesheets(
        date: filters.date,
        executorId: filters.executor?.id ?? '',
        limit: limit,
        page: _pageToLoad,
      );

      if (newItems.isEmpty) {
        noMoreToLoad = true;
      } else if (loadingMore) {
        page = _pageToLoad;
        final List<TsItem> updatedItems = List.from(tsList);
        updatedItems.addAll(newItems);
        tsList.value = updatedItems;
      } else {
        tsList.value = newItems;
        tsList.refresh();
      }
      _countTotalTimeSpent();
      _checkTimeIntersections();
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

  void _countTotalTimeSpent() {
    if (tsList.isNotEmpty) {
      int totalMinutes = 0;
      for (var item in tsList) {
        totalMinutes += item.timeDuration;
      }

      String twoDigits(int n) {
        if (n >= 10) return '$n';
        return '0$n';
      }

      final Duration totalDuration = Duration(minutes: totalMinutes);

      selectedDate.value = DateFormat('dd.MM.yyyy').format(TimeSheetController.to.filters.value.date);
      totalTimesheetsTime.value =
          '${twoDigits(totalDuration.inHours)}:${twoDigits(totalDuration.inMinutes.remainder(60))}';
    }
  }

  Future<void> processEdit(TsItem item) async {
    TimeSheetController.to.formType = FormActionType.edit;
    TimeSheetController.to.formItem = item;
    SnackbarService.info(
      'timeSheets_messages_editForm'.tr,
    );
    await Future.delayed(const Duration(milliseconds: 600), () {
      TimeSheetController.to.currentRoute.value = Routes.TSCREATE;
      TimeSheetController.to.delegate.toNamed(Routes.TSCREATE);
    });
  }

  Future<void> processCopy(TsItem item) async {
    TimeSheetController.to.formType = FormActionType.copy;
    TimeSheetController.to.formItem = item;
    SnackbarService.info(
      'timeSheets_messages_copyForm'.tr,
    );
    await Future.delayed(const Duration(milliseconds: 600), () {
      TimeSheetController.to.currentRoute.value = Routes.TSCREATE;
      TimeSheetController.to.delegate.toNamed(Routes.TSCREATE);
    });
  }

  Future<bool> deleteTimeSheet(TsItem item) async {
    bool deleted = false;
    final List<String> timeGapList = item.timeGap.split(' ');
    String timeGap = '';
    if (timeGapList.length > 1) {
      timeGap = timeGapList.last;
    }

    final bool? res = await Get.dialog(
      AppConfirmDialog(
        height: 220,
        message: 'timeSheets_messages_delete'.trParams(
            {'date': '${DateFormat('dd.MM.yyyy').format(TimeSheetController.to.filters.value.date)} $timeGap'}),
        confirmLabel: 'button_yes'.tr,
        cancelLabel: 'button_cancel'.tr,
      ),
      barrierColor: Colors.black.withOpacity(.6),
    );

    if (res == true) {
      try {
        await _repository.deleteTimeSheet(id: item.id).then((value) {
          if (value == true) {
            deleted = true;
            List<TsItem> updatedList = List<TsItem>.from(tsList);
            updatedList.removeWhere((element) => element == item);
            tsList.value = updatedList;
            _countTotalTimeSpent();
            SnackbarService.success('timeSheets_messages_deleteSuccess'.tr);
          } else {
            SnackbarService.success('timeSheets_error_delete'.tr);
          }
        });
      } catch (e) {
        final String errorMessage = e.toString().cleanException();
        SnackbarService.error(errorMessage);
      }
    }

    return deleted;
  }

  void _checkTimeIntersections() {
    // bool noIntersections = true;

    bool doDateTimesIntersect(
        DateTime dateTime1Start, DateTime dateTime1End, DateTime dateTime2Start, DateTime dateTime2End) {
      return dateTime1Start.isBefore(dateTime2End) && dateTime2Start.isBefore(dateTime1End);
    }

    (DateTime, DateTime) getDateTimePair(TsItem _item) {
      final List<String> splitTimeGap = _item.timeGap.split(' ').last.split('-');
      final String selectionDate = DateFormat('yyyy-MM-dd').format(TimeSheetController.to.filters.value.date);

      final DateTime dateStart = DateTime.parse('$selectionDate ${splitTimeGap.first}');
      final DateTime dateEnd = DateTime.parse('$selectionDate ${splitTimeGap.last}');

      return (dateStart, dateEnd);
    }

    if (tsList.isNotEmpty) {
      List<TsItem> modifiedList = List<TsItem>.from(tsList);
      for (var item in modifiedList) {
        try {
          final (DateTime, DateTime) datePair = getDateTimePair(item);

          for (var _item in modifiedList) {
            if (item != _item) {
              final (DateTime, DateTime) _datePair = getDateTimePair(_item);

              if (doDateTimesIntersect(datePair.$1, datePair.$2, _datePair.$1, _datePair.$2)) {
                // noIntersections = false;
                item.overlapping = true;
                _item.overlapping = true;
              }
            }
          }
        } catch (e) {
          Get.log(e.toString(), isError: true);
        }
      }

      tsList.value = modifiedList;
    }
  }
}
