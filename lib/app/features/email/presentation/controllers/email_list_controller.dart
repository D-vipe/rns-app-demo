import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/email/domain/models/email_filter_model.dart';
import 'package:rns_app/app/features/email/domain/models/email_list_item.dart';
import 'package:rns_app/app/features/email/domain/models/email_model.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_controller.dart';
import 'package:rns_app/app/features/email/presentation/views/list/components/email_batch_bootom_nav.dart';

import 'package:rns_app/app/features/email/presentation/views/list/components/email_list_fragment.dart';
import 'package:rns_app/app/features/home/presentation/controllers/appbar_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/bottomnav_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/dialogs/app_confirm_dialog.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/routes/app_pages.dart';

class EmailListController extends GetxController with GetTickerProviderStateMixin {
  static EmailListController get to => Get.find();
  final _repository = RepositoryModule.emailRepository();

  final int limit = 25;
  int pageIncoming = 1;
  int pageOutgoing = 1;
  bool noMoreIncomingToLoad = false;
  bool noMoreOutgoingToLoad = false;

  // Возможно, придется разделить эти переменные для двух табов
  final RxBool loadingData = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool loadingError = false.obs;
  final RxBool refreshing = false.obs;
  final RxBool disableScroll = false.obs;
  final RxBool batchMode = false.obs;
  bool batchMarkRead = true;
  final RxInt currentTabIndex = 0.obs;
  String errorMessage = '';

  late TabController tabController;
  late ScrollController incomingScrollController;
  late ScrollController outgoingScrollController;
  double incomingScrollPosition = 0.0;
  double outgoingScrollPosition = 0.0;

  final RxList<EmailListItem> incomingEmail = <EmailListItem>[].obs;
  final RxList<EmailListItem> outgoingEmail = <EmailListItem>[].obs;
  final RxList<EmailListItem> selectedEmails = <EmailListItem>[].obs;

  final List<int> renderedIds = [];

  final List<Widget> tabs = [const EmailListFragment(incoming: true), const EmailListFragment(incoming: false)];

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 2);
    incomingScrollController = ScrollController();
    outgoingScrollController = ScrollController();
    tabController.addListener(_tabSwitchListener);
    super.onInit();
  }

  @override
  void onReady() {
    HomeController.to.scrollController.jumpTo(0);
    HomeController.to.disableScroll.value = true;
    incomingScrollController.addListener(() => _scrollListener(incomingScrollController));
    outgoingScrollController.addListener(() => _scrollListener(outgoingScrollController));
    getData();
    super.onReady();
  }

  @override
  void onClose() {
    HomeController.to.disableScroll.value = false;
    incomingScrollController.dispose();
    outgoingScrollController.dispose();
    super.onClose();
  }

  void _tabSwitchListener() {
    if (!tabController.indexIsChanging) {
      currentTabIndex.value = tabController.index;
      if (batchMode.value) {
        toggleBatchMode();
      }
      switch (tabController.index) {
        case 0:
          // Выставяем значение в соответствии с табом, чтобы можно было опираться
          // на него с других экранов модуля
          EmailController.to.incoming = true;
          if (incomingEmail.isEmpty) {
            getData();
          }
          break;
        case 1:
          EmailController.to.incoming = false;
          if (outgoingEmail.isEmpty) {
            getData();
          }
          break;
      }
      EmailController.to.checkFiltersActive();
    }
  }

  Future<void> getData({bool loadingMore = false, bool pullToRefresh = false, bool applyFilter = false}) async {
    if (applyFilter) {
      renderedIds.clear();
      if (tabController.index == 0) {
        pageIncoming = 1;
      } else {
        pageOutgoing = 1;
      }
    }

    int _pageToLoad = tabController.index == 0 ? pageIncoming : pageOutgoing;
    if (!loadingMore && !pullToRefresh) {
      loadingData.value = true;
    } else if (loadingMore) {
      _pageToLoad = tabController.index == 0 ? pageIncoming + 1 : pageOutgoing + 1;
    }

    final EmailFilterModel filters =
        tabController.index == 0 ? EmailController.to.incomingFilters.value : EmailController.to.outGoingFilters.value;
    try {
      final List<EmailListItem> newItems = await _repository.getEmails(
          filter: filters, limit: limit, page: _pageToLoad, incoming: tabController.index == 0);

      if (newItems.isEmpty) {
        if (tabController.index == 0) {
          noMoreIncomingToLoad = true;
        } else {
          noMoreOutgoingToLoad = true;
        }
      } else if (loadingMore) {
        if (tabController.index == 0) {
          pageIncoming = _pageToLoad;
        } else {
          pageOutgoing = _pageToLoad;
        }

        final List<EmailListItem> updatedItems = List.from(tabController.index == 0 ? incomingEmail : outgoingEmail);
        updatedItems.addAll(newItems);

        if (tabController.index == 0) {
          incomingEmail.value = updatedItems;
        } else {
          outgoingEmail.value = updatedItems;
        }
      } else {
        if (tabController.index == 0) {
          incomingEmail.value = newItems;
          incomingEmail.refresh();
        } else {
          outgoingEmail.value = newItems;
          outgoingEmail.refresh();
        }
      }

      // Добавим отрендеренные id элементов, чтобы избежать ненужной повторной анимации
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var item in incomingEmail) {
          if (!renderedIds.contains(item.id)) {
            renderedIds.add(item.id);
          }
        }
        for (var item in outgoingEmail) {
          if (!renderedIds.contains(item.id)) {
            renderedIds.add(item.id);
          }
        }
      });
    } catch (e) {
      errorMessage = e.toString().cleanException();
      loadingError.value = true;
    }

    loadingData.value = false;
    isLoadingMore.value = false;
  }

  Future<void> _scrollListener(ScrollController scrollController) async {
    if (scrollController.position.maxScrollExtent - scrollController.offset < 220.0 &&
        scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (isLoadingMore.value) {
        return;
      }

      if (tabController.index == 0 ? !noMoreIncomingToLoad : !noMoreOutgoingToLoad) {
        isLoadingMore.value = true;
        await getData(loadingMore: true);
      }
    }

    if (scrollController.position.userScrollDirection == ScrollDirection.forward && scrollController.offset < -125) {
      if (refreshing.value) {
        return;
      } else {
        refreshing.value = true;
        disableScroll.value = true;

        // сбросим все значения
        if (tabController.index == 0) {
          pageIncoming = 1;
          noMoreIncomingToLoad = false;
        } else {
          pageOutgoing = 1;
          noMoreOutgoingToLoad = false;
        }
        // Без этой задержки происходит дергание элементов, когда их мало или нет
        // из-за быстрого ответа от сервера
        await Future.delayed(const Duration(milliseconds: 300), () async {
          await getData(pullToRefresh: true).then((value) {
            refreshing.value = false;
            disableScroll.value = false;
          });
        });
      }
    }
  }

  void readEmail({required int id, required String from, required bool incoming, String? replyTo}) async {
    // Так как контроллер стал permanent, необходимо отключить это перед переходом
    HomeController.to.disableScroll.value = false;
    // Сохраним позицию скрола табов
    if (incoming) {
      incomingScrollPosition = incomingScrollController.offset;
    } else {
      outgoingScrollPosition = outgoingScrollController.offset;
    }

    EmailController.to.readEmailId = id;
    EmailController.to.emailFrom = from;
    EmailController.to.incoming = incoming;
    EmailController.to.currentRoute.value = Routes.EMAILDETAIL;
  }

  Future<void> toggleEmailRead(int index) async {
    try {
      incomingEmail[index] = await _repository.toggleRead(email: incomingEmail[index]);
      incomingEmail.refresh();
    } catch (e) {
      SnackbarService.error(e.toString().cleanException());
    }
  }

  Future<bool> deleteEmail(int index) async {
    bool res = false;
    final EmailListItem email = currentTabIndex.value == 0 ? incomingEmail[index] : outgoingEmail[index];

    final bool? answer = await Get.dialog(
      AppConfirmDialog(
        height: 220,
        message: 'messages_message_delete'.trParams({'sender': email.title}),
        confirmLabel: 'button_yes'.tr,
        cancelLabel: 'button_cancel'.tr,
      ),
      barrierColor: Colors.black.withOpacity(.6),
    );

    if (answer == true) {
      try {
        res = await _repository.deleteEmail(
            emailId: currentTabIndex.value == 0 ? incomingEmail[index].id : outgoingEmail[index].id,
            incoming: currentTabIndex.value == 0);

        if (res) {
          List<EmailListItem> updatedList =
              List<EmailListItem>.from(currentTabIndex.value == 0 ? incomingEmail : outgoingEmail);
          updatedList.removeWhere((element) => element == email);
          if (currentTabIndex.value == 0) {
            incomingEmail.value = updatedList;
          } else {
            outgoingEmail.value = updatedList;
          }
          SnackbarService.success('messages_message_deleteSuccess'.tr);
        } else {
          SnackbarService.error('messages_error_delete'.tr);
        }
      } catch (e) {
        SnackbarService.error(e.toString().cleanException());
      }
    }

    return res;
  }

  // Только для входящих писем
  Future<void> toggleEmailImportance(int index) async {
    try {
      incomingEmail[index] = await _repository.changeImportance(email: incomingEmail[index]);
      incomingEmail.refresh();
    } catch (e) {
      SnackbarService.error(e.toString().cleanException());
    }
  }

  void toggleBatchMode() {
    batchMode.value = !batchMode.value;
    AppBarController appBar = AppBarController.to;
    if (batchMode.value) {
      // Изменим верхнее меню
      HomeController.to.floatingActionBtn.value = null;
      appBar.actionAsset.value = null;
      appBar.actionAsset2.value = null;
      appBar.actionName.value = 'button_cancelBatch'.tr;
      appBar.actionFun = () => toggleBatchMode();
      BottomNavController.to.navItemsList.value = const EmailBatchBottomNav();
      Get.log('BATCH MODE ENABLED');
    } else {
      selectedEmails.value = [];
      EmailController.to.enableEmailListUi(appBar);
      BottomNavController.to.reset();
      Get.log('BATCH MODE DISABLED');
    }
  }

  String readActionName() {
    String result = 'messages_button_read'.tr.toUpperCase();
    if (selectedEmails.isNotEmpty) {
      // если все выбранные уже были ранее открыты
      bool onlyRead = true;
      for (var item in selectedEmails) {
        if (item.unread) {
          onlyRead = false;
          batchMarkRead = true;
        }
      }

      if (onlyRead) {
        result = 'messages_button_unRead'.tr.toUpperCase();
        batchMarkRead = false;
      }
    }

    return result;
  }

  Future<void> batchRead() async {
    try {
      final List<EmailListItem> updatedItems =
          await _repository.batchToggleRead(items: selectedEmails, markRead: batchMarkRead);
      final List<EmailListItem> updatedList = [];
      for (var item in incomingEmail) {
        for (var upd in updatedItems) {
          if (item.id == upd.id) {
            item = item.copyWith(unread: upd.unread);
          }
        }
        updatedList.add(item);
      }
      incomingEmail.value = List.from(updatedList);
      toggleBatchMode();
    } catch (e) {
      SnackbarService.error(e.toString().cleanException());
    }
  }

  Future<bool> batchDelete() async {
    bool res = false;
    final bool? answer = await Get.dialog(
      AppConfirmDialog(
        height: 220,
        message: 'messages_message_deleteMulti'.tr,
        confirmLabel: 'button_yes'.tr,
        cancelLabel: 'button_cancel'.tr,
      ),
      barrierColor: Colors.black.withOpacity(.6),
    );
    if (answer == true) {
      try {
        res = await _repository.deleteEmailMulti(items: selectedEmails, incoming: currentTabIndex.value == 0);

        if (res) {
          List<EmailListItem> updatedList =
              List<EmailListItem>.from(currentTabIndex.value == 0 ? incomingEmail : outgoingEmail);

          for (var item in selectedEmails) {
            updatedList.removeWhere((element) => element == item);
          }
          if (currentTabIndex.value == 0) {
            incomingEmail.value = updatedList;
          } else {
            outgoingEmail.value = updatedList;
          }
          toggleBatchMode();
          SnackbarService.success('messages_message_deleteMultiSuccess'.tr);
        } else {
          SnackbarService.error('messages_error_delete'.tr);
        }
      } catch (e) {
        SnackbarService.error(e.toString().cleanException());
      }
    }

    return res;
  }

  Future<void> replyTo(int index, bool multiple) async {
    Get.dialog(
      const Loader(
        btn: true,
      ),
      barrierDismissible: false,
    );

    try {
      // Опция ответить только у входящих
      final EmailListItem email = incomingEmail[index];
      Get.log('reply to: ${email.title}');

      final Email? data = await _repository.getEmailDetail(id: email.id, incoming: true);

      Get.back();
      if (data == null) {
        SnackbarService.error('error_general'.tr);
      } else {
        EmailController.to.replyTo = multiple
            ? (data.fromList.length > 1 ? data.fromList.join('; ') : data.fromList.first)
            : data.fromList.first;
        EmailController.to.parentIncomingId = email.id;
        EmailController.to.replyTopic = 'Re: ${data.title}';
        EmailController.to.currentRoute.value = Routes.EMAILCREATE;
      }
    } catch (e) {
      Get.back();
      SnackbarService.error(e.toString().cleanException());
    }
  }

  void selectEmail(bool incoming, int index) {
    final EmailListItem item = incoming ? incomingEmail[index] : outgoingEmail[index];

    if (!selectedEmails.contains(item)) {
      selectedEmails.add(item);
    } else {
      selectedEmails.removeWhere((element) => element == item);
    }

    selectedEmails.refresh();
  }
}
