import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/email/domain/models/email_model.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_controller.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_list_controller.dart';
import 'package:rns_app/app/features/email/presentation/views/detail/components/context_menu_widget.dart';
import 'package:rns_app/app/features/general/domain/entities/app_file_model.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailDetailController extends GetxController {
  static EmailDetailController get to => Get.find();
  final _repository = RepositoryModule.emailRepository();
  final _filesRepo = RepositoryModule.filesRepository();

  final RxBool loadingData = false.obs;
  final RxBool loadingError = false.obs;
  final RxBool openingUrl = false.obs;
  final RxDouble webViewHeight = 0.0.obs;
  final RxBool downloading = false.obs;
  final RxList<Rx<AppFile>> attachments = <Rx<AppFile>>[].obs;

  late Directory? directory;
  bool dirDownloadExists = true;

  RxInt loadProgress = 0.obs;
  bool finalRefresh = false;

  String errorMessage = '';
  final Rxn<Email> data = Rxn(null);

  @override
  void onInit() {
    _initSaveDir();
    _getData();
    super.onInit();
  }

  @override
  void onClose() {
    // При переходе обратно к списку, восстановим положение скрола, уберем флаг unread
    // это сделано для того, чтобы можно было сохранять положение скрола у списка почты
    for (final (index, item) in EmailController.to.incoming
        ? EmailListController.to.incomingEmail.indexed
        : EmailListController.to.outgoingEmail.indexed) {
      if (item.id == EmailController.to.readEmailId) {
        EmailController.to.incoming
            ? EmailListController.to.incomingEmail[index] = item.copyWith(unread: false)
            : EmailListController.to.outgoingEmail[index] = item.copyWith(unread: false);
        EmailController.to.incoming
            ? EmailListController.to.incomingEmail.refresh()
            : EmailListController.to.outgoingEmail.refresh();
      }
    }

    // Вернем вверх основной скролл приложения, который находится на самом верхнем уровне
    // из-за того, что на разных экранах используется то основной скролл, то индивидуальный для экрана,
    // при переходах на другие экраны, имеющие скролл, могут возникать казусы
    HomeController.to.scrollController.jumpTo(0);

    // Вернем позиции скрола
    if (EmailController.to.incoming && Get.isRegistered<EmailListController>()) {
      if (EmailListController.to.incomingScrollController.hasClients) {
        EmailListController.to.incomingScrollController.jumpTo(EmailListController.to.incomingScrollPosition);
      }
    } else if (Get.isRegistered<EmailListController>()) {
      if (EmailListController.to.outgoingScrollController.hasClients) {
        EmailListController.to.outgoingScrollController.jumpTo(EmailListController.to.outgoingScrollPosition);
      }
    }

    EmailController.to.readEmailId = null;
    EmailController.to.emailFrom = null;
    super.onClose();
  }

  Future<void> _initSaveDir() async {
    directory = await _filesRepo.initSaveDir();
  }

  Future<void> _checkIfFileSaved() async {
    for (var item in attachments) {
      await _filesRepo.checkIfFileSaved(fileName: item.value.title, directory: directory!).then((value) {
        if (value && !item.value.downloaded) {
          item.value = item.value.copyWith(downloaded: true, downloadProgress: '100');
        }
      });
    }
  }

  Future<void> _getData() async {
    loadingData.value = false;
    loadingData.value = true;
    try {
      data.value = await _repository.getEmailDetail(
          id: EmailController.to.readEmailId ?? 0, incoming: EmailController.to.incoming);

      if (data.value?.fileData.isNotEmpty ?? false) {
        attachments.value = data.value?.fileData.map((e) => Rx<AppFile>(e)).toList() ?? <Rx<AppFile>>[];
      }
    } catch (e) {
      loadingError.value = true;
      errorMessage = e.toString().cleanException();
    }
    await _checkIfFileSaved();
    loadingData.value = false;
  }

  Future<NavigationActionPolicy> overrideUrlLoading(
      InAppWebViewController _controller, NavigationAction navigationAction) async {
    // пока разберем только два варианта: OTHER и LINK_ACTIVATED

    // В андройде не распознает NavigationType
    if (GetPlatform.isAndroid) {
      final RequestFocusNodeHrefResult? link = await _controller.requestFocusNodeHref();
      if (link != null) {
        await _openEmailLink(link.url.toString());
      } else {
        SnackbarService.error('messages_error_urlValidity'.tr);
      }
    } else {
      if (navigationAction.navigationType == NavigationType.OTHER) {
        return NavigationActionPolicy.ALLOW;
      } else if (navigationAction.navigationType == NavigationType.LINK_ACTIVATED) {
        final RequestFocusNodeHrefResult? link = await _controller.requestFocusNodeHref();
        if (link != null) {
          await _openEmailLink(link.url.toString());
        } else {
          SnackbarService.error('messages_error_urlValidity'.tr);
        }
      }
    }

    return NavigationActionPolicy.CANCEL;
  }

  Future<void> _openEmailLink(String? url) async {
    // Для предотвращения повторного срабатывания в момент выполнения асинхронного запроса
    if (openingUrl.value == true) {
      return;
    }
    openingUrl.value = true;
    bool urlOpened = false;
    if (url != null) {
      try {
        final Uri _url = Uri.parse(url);
        urlOpened = await launchUrl(_url);
        if (!urlOpened) {
          SnackbarService.error('messages_error_urlLaunch'.tr);
        }
      } catch (e) {
        SnackbarService.error('messages_error_urlException'.tr);
      }
    } else {
      SnackbarService.error('messages_error_urlValidity'.tr);
    }

    openingUrl.value = false;
  }

  void webViewSizeChanged(_, Size oldSize, Size newSize) {
    if (oldSize.height != newSize.height && loadProgress.value != 100) {
      webViewHeight.value = newSize.height < 150.0 ? 150.0 : newSize.height;
    }
    if (loadProgress.value == 100 && !finalRefresh) {
      webViewHeight.value = newSize.height;
      finalRefresh = true;
    }
  }

  void onLoadProgress(InAppWebViewController viewController, int progress) async {
    loadProgress.value = progress;
    if (loadProgress.value == 100) {
      final int? contentHeight = await viewController.getContentHeight();

      webViewHeight.value = contentHeight != null ? contentHeight.toDouble() : 300.0;
    }
  }

  Future<void> downloadAttachment(Rx<AppFile> file) async {
    final RxString progressValue = '0'.obs;
    try {
      progressValue.listen((String value) {
        bool downloaded = (value == '100');
        file.value = file.value.copyWith(
          downloaded: downloaded,
          downloadProgress: value,
          saving: true,
        );
      });
      await _filesRepo
          .downloadFile(
        item: file.value,
        directory: directory!,
        progressValue: progressValue,
        url: file.value.url,
        emailId: EmailController.to.readEmailId,
      )
          .then((value) async {
        if (value) {
          file.value = file.value.copyWith(
            downloaded: true,
            saving: false,
          );
        } else {
          SnackbarService.error('error_general'.tr);
          file.value = file.value.copyWith(
            downloaded: false,
            saving: false,
          );
        }
      });
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  Future<void> openDownloadedFile(AppFile item) async {
    Get.dialog(
      const Loader(
        btn: true,
      ),
      barrierDismissible: false,
    );

    try {
      final String? message = await _filesRepo.openFile(directory: directory!, fileName: item.title);

      Get.back();

      if (message != null) {
        SnackbarService.error(message);
      }
    } catch (e) {
      Get.back();
      SnackbarService.error(e.toString().cleanException());
    }
  }

  void openActionsMenu() {
    Get.dialog(
      const ContextMenuWidget(),
      barrierDismissible: true,
    );
  }

  Future<void> replyTo(bool multiple) async {
    Get.back();
    if (data.value != null) {
      EmailController.to.replyTo = multiple
          ? (data.value!.fromList.length > 1 ? data.value!.fromList.join('; ') : data.value!.fromList.first)
          : data.value!.fromList.first;
      EmailController.to.parentIncomingId = data.value!.id;
      EmailController.to.replyTopic = 'Re: ${data.value!.title}';
      EmailController.to.currentRoute.value = Routes.EMAILCREATE;
    } else {
      SnackbarService.error('error_general'.tr);
    }
  }

  Future<void> forwardMail() async {
    Get.back();
    if (data.value != null) {
      EmailController.to.parentIncomingId = data.value!.id;
      EmailController.to.replyTopic = 'Fw: ${data.value!.title}';
      EmailController.to.currentRoute.value = Routes.EMAILCREATE;
    } else {
      SnackbarService.error('error_general'.tr);
    }
  }
}
