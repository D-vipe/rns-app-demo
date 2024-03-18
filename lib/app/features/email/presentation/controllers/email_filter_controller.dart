import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/email/domain/models/email_filter_model.dart';
import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_controller.dart';
import 'package:rns_app/app/features/email/presentation/views/filter/components/email_filter_bottomsheet.dart';

import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';

class EmailFilterController extends GetxController with GetTickerProviderStateMixin {
  static EmailFilterController get to => Get.find();
  final _repository = RepositoryModule.emailRepository();

  final List<SelectObject> unmodifiedUsers = <SelectObject>[];
  final RxList<SelectObject> usersList = <SelectObject>[].obs;
  final RxList<Importance> importanceList = <Importance>[].obs;

  final TextEditingController searchTermController = TextEditingController();
  final TextEditingController searchUserController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController selectedUserController = TextEditingController();

  final Rxn<DateTime> selectedStartDate = Rxn(null);
  final Rxn<DateTime> selectedEndDate = Rxn(null);
  final Rxn<String> startDateError = Rxn(null);
  final Rxn<String> endDateError = Rxn(null);

  final Rxn<SelectObject> selectedUser = Rxn(null);
  final Rxn<SelectObject> radioUser = Rxn(null);
  final RxList<Importance> selectedImportance = <Importance>[].obs;

  final RxBool loadingData = false.obs;
  final RxBool animationsFinished = false.obs;
  final RxBool applyingFilters = false.obs;
  final RxBool onlyUnread = false.obs;

  final RxBool searching = false.obs;
  final RxBool debounceClearSearchable = false.obs;

  final Rxn<String> userError = Rxn(null);

  Timer? _debouncer;
  String previousSearch = '';

  List<String> combinedError = [];
  late AnimationController animationController;
  late AnimationController bottomAnimationController;

  @override
  void onInit() {
    _initAnimationController();
    super.onInit();
  }

  @override
  void onReady() {
    _prepareFilters();
    searchUserController
        .addListener(() => _searchList(data: usersList, input: searchUserController, unmodifiedData: unmodifiedUsers));
    selectedUser.listen((_) {
      selectedUser.value == null ? null : selectedUserController.text = selectedUser.value!.title;
    });
    selectedStartDate.listen((_) => _dateListener());
    selectedEndDate.listen((_) => _dateListener(beginPeriod: false));

    _checkSavedFilter();
    super.onReady();
  }

  void _initAnimationController() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    bottomAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _checkSavedFilter() {
    final EmailFilterModel filters = EmailController.to.incoming
        ? EmailController.to.incomingFilters.value
        : EmailController.to.outGoingFilters.value;

    selectedUser.value = filters.recepient;
    radioUser.value = filters.recepient;
    searchTermController.text = filters.searchTitle;
    selectedStartDate.value = filters.dateFrom;
    selectedEndDate.value = filters.dateTo;
    selectedImportance.value = filters.importance;
    onlyUnread.value = filters.onlyUnread ?? false;
  }

  Future<void> _prepareFilters() async {
    loadingData.value = true;
    animationsFinished.value = false;
    importanceList.value = Importance.values.toList();

    await getUsersList();

    unmodifiedUsers.clear();
    unmodifiedUsers.addAll(List<SelectObject>.from(usersList));

    if (combinedError.isNotEmpty) {
      SnackbarService.error(combinedError.join('\n'), duration: 10);
    }
    loadingData.value = false;
    animationController.forward().then((value) => animationsFinished.value = true);
  }

  Future<void> getUsersList() async {
    try {
      usersList.value = await _repository.getEmployeeBoxes();
    } catch (e) {
      combinedError.add(e.toString().cleanException());
    }
  }

  void onRecepientChange(bool? value, int index) {
    radioUser.value = usersList[index];
    userError.value = null;
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
        bottomAnimationController.reverse().then((value) {
          searching.value = true;
          data.value = [];

          for (var item in unmodifiedData) {
            if (item.title.toLowerCase().contains(input.text.toLowerCase())) {
              filteredList.add(item);
            }
          }

          data.value = filteredList;
          searching.value = false;
          bottomAnimationController.forward();
        });
      } else if (input.text.isEmpty && previousSearch != input.text) {
        FocusScope.of(Get.context!).unfocus();
        bottomAnimationController.reverse().then((value) {
          searching.value = true;
          data.value = [];
          data.value = List<SelectObject>.from(unmodifiedData);
          searching.value = false;
          bottomAnimationController.forward();
        });
      }

      previousSearch = input.text;
    });
  }

  void _dateListener({bool beginPeriod = true}) {
    if (beginPeriod) {
      selectedStartDate.value == null
          ? null
          : startDateController.text = DateFormat('dd.MM.yyyy').format(selectedStartDate.value!);
      if (startDateError.value != null && selectedStartDate.value != null) {
        startDateError.value = null;
      }
    } else {
      selectedEndDate.value == null
          ? null
          : endDateController.text = DateFormat('dd.MM.yyyy').format(selectedEndDate.value!);
      if (endDateError.value != null && selectedEndDate.value != null) {
        endDateError.value = null;
      }
    }
  }

  void pickDate({bool beginPeriod = true}) async {
    // Убираем фокус с последнего элемента тут и после вызова дейстпикера, таким образом
    // мы избегаем "прыжков", когда фокус менеджер пытается дать фокус последнему инпуту при
    // изменении навигации с помощью вызова Get
    FocusManager.instance.primaryFocus?.unfocus();
    final locale = Get.locale;
    if (beginPeriod) {
      selectedStartDate.value = await showDatePicker(
        context: Get.context!,
        initialDate: selectedStartDate.value ?? DateTime.now(),
        firstDate: DateTime.utc(2000),
        lastDate: DateTime.utc(2100),
        locale: locale,
      ).then((value) {
        FocusManager.instance.primaryFocus?.unfocus();
        return value;
      });
    } else {
      selectedEndDate.value = await showDatePicker(
        context: Get.context!,
        initialDate: selectedEndDate.value ?? DateTime.now(),
        firstDate: DateTime.utc(2000),
        lastDate: DateTime.utc(2100),
        locale: locale,
      ).then((value) {
        FocusManager.instance.primaryFocus?.unfocus();
        return value;
      });
    }

    _validatePickedDates();
  }

  void _validatePickedDates() {
    if (selectedStartDate.value != null && selectedEndDate.value != null) {
      if (selectedStartDate.value!.isAfter(selectedEndDate.value!)) {
        startDateError.value = 'messages_error_startDate'.tr;
      } else {
        startDateError.value = null;
      }

      if (selectedEndDate.value!.isBefore(selectedStartDate.value!)) {
        endDateError.value = 'messages_error_endDate'.tr;
      } else {
        endDateError.value = null;
      }
    }
  }

  void selectImportance(Importance? value) {
    final List<Importance> processing = List.from(selectedImportance);
    if (processing.contains(value)) {
      processing.removeWhere((element) => element == value);
    } else if (value != null) {
      processing.add(value);
    }
    selectedImportance.value = processing;
    selectedImportance.refresh();
    Get.log('AFTER IMPORTANCE REFRESH');
  }

  void clearSelectFilter() {
    radioUser.value = null;
    selectedUser.value = null;

    searchUserController.text = '';
    usersList.value = List<SelectObject>.from(unmodifiedUsers);

    if (!debounceClearSearchable.value) {
      debounceClearSearchable.value = true;
      SnackbarService.info('tasks_message_executorFilterCleared'.tr, snackDebounce: debounceClearSearchable);
    }
  }

  void clearFilters() {
    searchTermController.text = '';
    selectedStartDate.value = null;
    startDateController.text = '';
    selectedEndDate.value = null;
    endDateController.text = '';
    selectedUser.value = null;
    selectedUserController.text = '';
    selectedImportance.value = [];
    onlyUnread.value = false;
  }

  void applySelectedValue() {
    selectedUser.value = radioUser.value;
  }

  void openExtendedSelectModal() {
    Get.bottomSheet(
      const EmailFilterBottomSheet(),
      isScrollControlled: true,
      useRootNavigator: false,
    ).then((value) {
      bottomAnimationController.reverse();
      // Очищаем строку поиска
      if (value == null || value == false) {
        searchUserController.text = '';
        usersList.value = List<SelectObject>.from(unmodifiedUsers);
        radioUser.value = null;
        selectedUserController.text = '';
        selectedUser.value = null;
      }
    });
    bottomAnimationController.forward();
  }

  void applyFilters() {
    applyingFilters.value = true;
    if (EmailController.to.incoming) {
      EmailController.to.incomingFilters.value = EmailController.to.incomingFilters.value.copyWith(
        searchTitle: searchTermController.text,
        recepient: selectedUser.value,
        dateFrom: selectedStartDate.value,
        dateTo: selectedEndDate.value,
        importance: selectedImportance,
        onlyUnread: onlyUnread.value,
      );

    } else {
      EmailController.to.outGoingFilters.value = EmailController.to.outGoingFilters.value.copyWith(
        searchTitle: searchTermController.text,
        recepient: selectedUser.value,
        dateFrom: selectedStartDate.value,
        dateTo: selectedEndDate.value,
        importance: selectedImportance,
        onlyUnread: onlyUnread.value,
      );

    }

    EmailController.to.showListScreen();
  }

}
