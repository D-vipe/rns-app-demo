import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/home/domain/models/user_model.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/timesheets/domain/models/timesheet_filter_model.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/timesheets_controller.dart';
import 'package:rns_app/app/features/timesheets/presentation/views/filter/components/user_extended_select.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/routes/app_pages.dart';

class TSFilterController extends GetxController with GetSingleTickerProviderStateMixin {
  final Rxn<DateTime> date = Rxn(null);
  final RxList<SelectObject> employersList = <SelectObject>[].obs;
  List<SelectObject> rawList = <SelectObject>[];
  final TextEditingController dateController = TextEditingController();
  final TextEditingController employerController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final Rxn<SelectObject> radioEmployer = Rxn(null);
  final Rxn<SelectObject> employer = Rxn(null);
  final RxBool loadingData = false.obs;
  final RxBool applyingFilters = false.obs;
  final Rxn<String> dateError = Rxn(null);
  final Rxn<String> executorError = Rxn(null);
  final RxBool searching = false.obs;
  final RxBool debounceClearExecutor = false.obs;

  Timer? _debouncer;
  String previousSearch = '';

  static TSFilterController get to => Get.find();
  final _repository = RepositoryModule.tsRepository();

  User? get _user => TimeSheetController.to.user;

  late AnimationController animationController;

  @override
  void onInit() {
    _initAnimationController();
    super.onInit();
  }

  @override
  void onReady() {
    HomeController.to.disableScroll.value = true;
    getAvailableUsersList();

    // searchController.addListener(searchExecutor);
    searchController
        .addListener(() => _searchList(data: employersList, input: searchController, unmodifiedData: rawList));

    date.listen((_) {
      date.value == null ? null : dateController.text = DateFormat('dd.MM.yyyy').format(date.value!);
      dateError.value = null;
    });
    employer.listen((_) => employer.value == null ? null : employerController.text = employer.value!.title);

    final TimeSheetFilterModel filters = TimeSheetController.to.filters.value;

    // Проверим значения фильтра в TimeSheetController
    date.value = filters.date;
    employer.value = filters.executor;
    radioEmployer.value = filters.executor;

    super.onReady();
  }

  @override
  void onClose() {
    HomeController.to.disableScroll.value = false;
    animationController.dispose();
    super.onClose();
  }

  void _initAnimationController() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> getAvailableUsersList() async {
    loadingData.value = true;
    try {
      employersList.value = await _repository.getAvailableUsers();
    } catch (e) {
      final String errorMessage = e.toString().cleanException();
      SnackbarService.error(errorMessage);
    }

    rawList = List<SelectObject>.from(employersList);
    loadingData.value = false;
  }

  void clearFilters() {
    date.value = DateTime.now();
    if (_user != null) {
      radioEmployer.value = SelectObject(id: _user!.id, title: _user!.fio);
      employer.value = SelectObject(id: _user!.id, title: _user!.fio);
    } else {
      radioEmployer.value = null;
      employer.value = null;
      employerController.text = '';
    }
  }

  void clearEmployerFilter() {
    if (_user != null) {
      radioEmployer.value = SelectObject(id: _user!.id, title: _user!.fio);
      employer.value = SelectObject(id: _user!.id, title: _user!.fio);
    } else {
      radioEmployer.value = null;
      employer.value = null;
    }

    searchController.text = '';
    employersList.value = List<SelectObject>.from(rawList);
    SnackbarService.info('timeSheets_messages_executorFilterCleared'.tr, snackDebounce: debounceClearExecutor);
  }

  void applyEmployer() {
    employer.value = radioEmployer.value;
  }

  void pickDate() async {
    final locale = Get.locale;
    date.value = await showDatePicker(
      context: Get.context!,
      initialDate: TimeSheetController.to.filters.value.date,
      firstDate: DateTime.utc(2000),
      lastDate: DateTime.utc(2100),
      locale: locale,
    );
  }

  void onEmployerChange(bool? value, int index) {
    radioEmployer.value = employersList[index];
    executorError.value = null;
  }

  void openExtendedSelectModal() {
    Get.bottomSheet(
      const UserExtendedSelect(),
      // backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: false,
    ).then((value) {
      animationController.reverse();
      // Очищаем строку поиска
      searchController.text = '';
      employersList.value = List<SelectObject>.from(rawList);
      // В случае, если фильтр по сотруднику не был применен, сбросим на предыдущее значение
      radioEmployer.value = employer.value;
    });
    animationController.forward();
  }

  Future<void> searchExecutor() async {
    if (searchController.text.isNotEmpty && searchController.text.length >= 3) {
      if (_debouncer != null && _debouncer!.isActive) {
        _debouncer!.cancel();
      }

      _debouncer = Timer(const Duration(seconds: 1), () {
        // FocusScope.of(Get.context!).unfocus();
        List<SelectObject> filteredList = [];
        if (searchController.text.isNotEmpty &&
            searchController.text.length >= 2 &&
            previousSearch != searchController.text) {
          // Запустим анимацию скрытия списка пользователей
          if (employersList.isEmpty) {
            searching.value = true;
          }
          animationController.reverse().then((value) {
            searching.value = true;
            employersList.value = [];
            for (var employer in rawList) {
              if (employer.title.toLowerCase().contains(searchController.text.toLowerCase())) {
                filteredList.add(employer);
              }
            }

            previousSearch = searchController.text;
            employersList.value = filteredList;
            searching.value = false;
            animationController.forward();
          });
        } else if (searchController.text.isEmpty && previousSearch != searchController.text) {
          employersList.value = List<SelectObject>.from(rawList);
        }

        searching.value = false;
      });
    } else {
      employersList.value = List<SelectObject>.from(rawList);
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

  void applyFilters() {
    applyingFilters.value = true;
    if (date.value == null) {
      dateError.value = 'timeSheets_error_selectField'.tr;
      applyingFilters.value = false;
      return;
    }
    if (executorError.value != null) {
      executorError.value = 'timeSheets_error_selectField'.tr;
      applyingFilters.value = false;
      return;
    }

    TimeSheetController.to.filters.value =
        TimeSheetController.to.filters.value.copyWith(date: date.value, executor: radioEmployer.value);

    TimeSheetController.to.currentRoute.value = Routes.TSLIST;
    TimeSheetController.to.delegate.toNamed(Routes.TSLIST);
  }
}
