import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/email/domain/models/additional_field_model.dart';
import 'package:rns_app/app/features/email/domain/models/mailbox_model.dart';
import 'package:rns_app/app/features/email/domain/models/receiver_type_enum.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_controller.dart';
import 'package:rns_app/app/features/email/presentation/views/create/components/employees_email_select_widget.dart';
import 'package:rns_app/app/features/email/presentation/views/create/components/personal_email_select_widget.dart';
import 'package:rns_app/app/features/general/presentation/controllers/media_gallery_controller.dart';
import 'package:rns_app/app/features/general/presentation/views/components/media_gallery_bottomsheet.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/general/domain/entities/selected_file_model.dart';
import 'package:rns_app/app/uikit/dialogs/app_confirm_dialog.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/helper_utils.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class EmailCreateController extends GetxController with GetTickerProviderStateMixin {
  static EmailCreateController get to => Get.find();
  final _repository = RepositoryModule.emailRepository();

  final RxBool loadingData = false.obs;
  final RxBool sendToError = false.obs;
  final RxBool messageError = false.obs;
  final Rxn<String> errorMessage = Rxn(null);
  List<String> combinedError = [];
  final RxBool sendingForm = false.obs;
  final RxInt sendingProgress = 0.obs;

  final RxList<MailBox> personalMailBoxes = <MailBox>[].obs;
  final RxList<SelectObject> employeesMailBoxes = <SelectObject>[].obs;

  final RxBool highImportance = false.obs;
  final RxBool delayedSend = false.obs;

  final Rxn<MailBox> selectedMailBox = Rxn(null);

  final TextEditingController sendFrom = TextEditingController();
  final TextEditingController themeController = TextEditingController();
  // строчка всех пользователей, кому необходимо отправить письмо
  final TextEditingController sendTo = TextEditingController();
  // строчка всех пользователей, кому необходимо отправить копию
  final TextEditingController copyTo = TextEditingController();
  // строчка всех пользователей, кому необходимо отправить скрытую копию
  final TextEditingController secretCopyTo = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final List<ReceiverType> shownFields = <ReceiverType>[];
  final List<Rx<AdditionalField>> additionalFields = [];

  final Rxn<DateTime> date = Rxn(DateTime.now());
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final RxnString timeDelayedError = RxnString(null);
  final RxnString dateError = RxnString(null);

  List<AssetEntity> recentPhotos = <AssetEntity>[];
  RxList<SelectedFile> pickedFiles = <SelectedFile>[].obs;

  late AnimationController bottomSheetListAnimation;
  late AnimationController dateAnimation;
  late AnimationController filesAnimation;

  @override
  void onInit() {
    bottomSheetListAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    dateAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.onInit();
  }

  @override
  void onReady() {
    // HomeController.to.scrollController.jumpTo(0);
    HomeController.to.disableScroll.value = false;
    ever(selectedMailBox, (_) => sendFrom.text = selectedMailBox.value?.title ?? '');
    sendTo.addListener(() => _sendToListener());
    messageController.addListener(() => _messageListener());
    date.listen((_) => _dateListener());
    timeController.addListener(() => _timeListener());

    _addFields();
    _getData();
    super.onReady();
  }

  @override
  void onClose() {
    sendFrom.dispose();
    themeController.dispose();
    sendTo.dispose();
    copyTo.dispose();
    secretCopyTo.dispose();
    messageController.dispose();
    dateController.dispose();
    timeController.dispose();
    for (var field in additionalFields) {
      field.value.animationController.dispose();
    }
    // При возвращении к списку, сбросим скрол основной + заблокируем его, чтобы он не мешал скролу списка писем
    HomeController.to.scrollController.jumpTo(0);
    HomeController.to.disableScroll.value = true;
    EmailController.to.replyTo = null;
    EmailController.to.replyTopic = null;

    super.onClose();
  }

  void _sendToListener() {
    if (sendTo.text.isNotEmpty && sendToError.value) {
      sendToError.value = false;
    }
  }

  void _messageListener() {
    if (messageController.text.isEmpty && messageError.value) {
      messageError.value = false;
    }
  }

  void _addFields() {
    additionalFields.addAll([
      AdditionalField(
        type: ReceiverType.copy,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        ),
        showed: false,
      ).obs,
      AdditionalField(
        type: ReceiverType.secretCopy,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        ),
        showed: false,
      ).obs,
    ]);
  }

  void _dateListener() {
    date.value == null ? null : dateController.text = DateFormat('dd.MM.yyyy').format(date.value!);
    if (dateError.value != null && date.value != null) {
      dateError.value = null;
    }
  }

  void _timeListener() {
    if (timeController.text.isNotEmpty && timeDelayedError.value != null) {
      timeDelayedError.value = null;
    }
  }

  Future<void> _getData() async {
    loadingData.value = true;
    await Future.wait([
      _getUserEmailBoxes(),
      _getEmployeeEmails(),
    ]).then((_) {
      if (combinedError.isNotEmpty) {
        SnackbarService.error(combinedError.join('\n'), duration: 10);
      }
    });

    // Заполним данные по отправке, если была выбрана опция "ответить"
    sendTo.text = EmailController.to.replyTo ?? '';
    themeController.text = EmailController.to.replyTopic ?? '';

    loadingData.value = false;
  }

  Future<void> _getUserEmailBoxes() async {
    try {
      personalMailBoxes.value = await _repository.getAvailableBoxes();
      if (personalMailBoxes.isNotEmpty) {
        for (var item in personalMailBoxes) {
          if (item.isChecked == true) {
            selectedMailBox.value = item;
          }
        }
      }
    } catch (e) {
      combinedError.add(e.toString().cleanException());
    }
  }

  Future<void> _getEmployeeEmails() async {
    try {
      employeesMailBoxes.value = await _repository.getEmployeeBoxes();
    } catch (e) {
      combinedError.add(e.toString().cleanException());
    }
  }

  void changePersonalMailBox(MailBox value) {
    selectedMailBox.value = value;
    Get.back();
  }

  void changeAdditionalFields(SelectObject value, {required ReceiverType type}) {
    switch (type) {
      case ReceiverType.to:
        if (sendTo.text.isNotEmpty) {
          sendTo.text = '${sendTo.text}; ${value.id}';
        } else {
          sendTo.text = value.id;
        }
        break;
      case ReceiverType.copy:
        if (copyTo.text.isNotEmpty) {
          copyTo.text = '${copyTo.text}; ${value.id}';
        } else {
          copyTo.text = value.id;
        }
        break;
      case ReceiverType.secretCopy:
        if (secretCopyTo.text.isNotEmpty) {
          secretCopyTo.text = '${secretCopyTo.text}; ${value.id}';
        } else {
          secretCopyTo.text = value.id;
        }
        break;
      default:
        break;
    }

    // Get.back();
  }

  void addAdditionalFields() {
    if (shownFields.length == 2) return;
    if (shownFields.isEmpty) {
      shownFields.add(ReceiverType.copy);
    } else {
      if (shownFields.contains(ReceiverType.copy)) {
        shownFields.add(ReceiverType.secretCopy);
      } else {
        shownFields.add(ReceiverType.copy);
      }
    }

    for (var field in additionalFields) {
      if (shownFields.contains(field.value.type) && !field.value.showed) {
        field.value = field.value.copyWith(showed: true);
        field.value.animationController.forward();
      }
    }
  }

  void removeAdditionalField(ReceiverType type) {
    for (var field in additionalFields) {
      if (field.value.type == type) {
        field.value.animationController.reverse().then(
          (value) {
            field.value = field.value.copyWith(showed: false);
            shownFields.removeWhere((element) => element == type);
            if (type == ReceiverType.copy) {
              copyTo.text = '';
            } else {
              secretCopyTo.text = '';
            }
          },
        );
      }
    }
  }

  void changeImportance(bool? value) {
    if (MediaQuery.of(Get.context!).viewInsets.bottom > 0.0) {
      FocusManager.instance.primaryFocus?.unfocus();
      return;
    } else {
      highImportance.value = value ?? highImportance.value;
    }
  }

  void toggleDelayed(bool? value) {
    if (MediaQuery.of(Get.context!).viewInsets.bottom > 0.0) {
      FocusManager.instance.primaryFocus?.unfocus();
      return;
    } else {
      delayedSend.value = value ?? delayedSend.value;
      if (value == true) {
        dateAnimation.forward();
      }
      if (value == false) {
        dateAnimation.reverse().then((value) {
          date.value = null;
          dateController.text = '';
          timeController.text = '';
          dateError.value = null;
          timeDelayedError.value = null;
        });
      }
    }
  }

  Future<bool> _validateForm() async {
    bool isValid = true;

    if (sendTo.text.isEmpty) {
      isValid = false;
      sendToError.value = true;
      return isValid;
    }

    if (themeController.text.isEmpty) {
      final bool res = await Get.dialog(
        AppConfirmDialog(
          height: 250,
          message: 'messages_message_emptyTheme'.tr,
          confirmLabel: 'button_yes'.tr,
          cancelLabel: 'button_cancel'.tr,
        ),
        barrierColor: Colors.black.withOpacity(.6),
      );
      if (!res) {
        isValid = false;
      }
    }

    if (delayedSend.value) {
      if (dateController.text.isEmpty) {
        dateError.value = 'messages_error_delayedDate'.tr;
        isValid = false;
      }
      if (timeController.text.isEmpty) {
        timeDelayedError.value = 'messages_error_delayedTime'.tr;
        isValid = false;
      }
    }

    return isValid;
  }

  Future<void> sendEmail() async {
    sendingForm.value = true;
    try {
      if (await _validateForm()) {
        sendingProgress.value = 0;
        if (pickedFiles.isNotEmpty) {
          _showUploadingSnack();
        }

        final bool res = await _repository.sendEmail(
          fromMailboxId: int.parse(selectedMailBox.value!.id),
          to: sendTo.text,
          copy: copyTo.text,
          copyHide: secretCopyTo.text,
          theme: themeController.text,
          body: messageController.text,
          footer: selectedMailBox.value?.sign ?? '',
          sendDate: date.value,
          sendTime: timeController.text.isNotEmpty ? timeController.text : null,
          files: pickedFiles,
          progressValue: sendingProgress,
          parentIncomingId: EmailController.to.parentIncomingId,
          parentOutgoingId: EmailController.to.parentOutgoingId,
        );

        if (res) {
          if (pickedFiles.isNotEmpty) {
            Get.back(closeOverlays: true);
          }
          SnackbarService.info('messages_message_sendSuccess'.tr);
          resetCreateForm();
        } else {
          SnackbarService.error('messages_error_sendEmail'.tr);
        }
      }
    } catch (e) {
      SnackbarService.error(e.toString().cleanException());
    }
    sendingForm.value = false;
  }

  void openPersonalMailboxList() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.bottomSheet(
      const PersonalEmailselectWidget(),
      isScrollControlled: false,
      useRootNavigator: true,
    ).then((value) {
      bottomSheetListAnimation.reverse();
    });

    bottomSheetListAnimation.forward();
  }

  void openEmployeeMailboxList(ReceiverType type) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.bottomSheet(
      EmployeesEmailSelectWidget(
        type: type,
      ),
      isScrollControlled: false,
      useRootNavigator: true,
    ).then((value) {
      bottomSheetListAnimation.reverse();
    });

    bottomSheetListAnimation.forward();
  }

  void pickDate() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final locale = Get.locale;
    date.value = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.utc(2100),
      locale: locale,
    );
  }

  void _showUploadingSnack() {
    SnackbarService.uploadProgress(
      Container(
        height: 66,
        width: Get.width,
        margin: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text('Загрузка файлов: ${sendingProgress.value}%'),
            ),
            Expanded(
              child: Center(
                child: Obx(
                  () => LinearProgressIndicator(
                    minHeight: 5.0,
                    value: sendingProgress.value / 100,
                    backgroundColor: Get.context!.colors.background,
                    color: Get.context!.colors.buttonActive,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetCreateForm() {
    selectedMailBox.value = personalMailBoxes.first;
    sendTo.text = '';
    copyTo.text = '';
    secretCopyTo.text = '';
    themeController.text = '';
    messageController.text = '';
    highImportance.value = false;
    delayedSend.value = false;
    pickedFiles.clear();
    pickedFiles.refresh();
    recentPhotos.clear();
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      // check if selected files were previously selected
      for (final (index, item) in files.indexed) {
        bool notPickedYet = true;
        for (var picked in pickedFiles) {
          if (item.path == picked.pickedFile?.path) notPickedYet = false;
        }
        if (notPickedYet) {
          SelectedFile pickedFile = SelectedFile(
              fileName: result.files[index].name, pickedFile: File(result.files[index].path!), pickedPhoto: null);

          final String fileSize = await HelperUtils.getFileSize(pickedFile.pickedFile!, 1);
          pickedFile = pickedFile.updateSize(fileSize);

          pickedFiles.add(
            pickedFile,
          );
        }
      }
    }
  }

  Future<void> pickPhoto() async {
    if (!Get.isRegistered<MediaGalleryController>()) {
      Get.put(MediaGalleryController());
      List<AssetEntity> selectedPhotos = [];
      for (var item in pickedFiles) {
        if (item.pickedPhoto != null) {
          selectedPhotos.add(item.pickedPhoto!);
        }
      }

      MediaGalleryController.to.chosenEntities.value = selectedPhotos;
    }

    Get.bottomSheet(
      GestureDetector(
        onTap: () => FocusScope.of(Get.context!).unfocus(),
        child: MediaGalleryBottomSheet(
          closeHandler: () => Get.back(result: false),
          onSelect: _onSelectPhoto,
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: false,
      isDismissible: false,
      enableDrag: false,
    ).then((value) {
      if (value != true) {
        _removeRecentlyAddedPhotos();
      } else {
        recentPhotos.clear();
      }
      Get.delete<MediaGalleryController>();
    });
  }

  Future<void> _onSelectPhoto(AssetEntity entity) async {
    final String photoName = await entity.titleAsync;

    if (pickedFiles.isNotEmpty) {
      // check all items that have pickedPhoto. If match found, remove element
      bool matchFound = false;
      for (var item in pickedFiles) {
        if (item.pickedPhoto == entity) {
          matchFound == true;
          // remove matching element
          pickedFiles.removeWhere((element) => element == item);
        }
      }

      if (matchFound == false) {
        // add entities to this List. If modal is closed, not applied. Remove all recently added photos
        recentPhotos.add(entity);

        SelectedFile selectedFile = SelectedFile(fileName: photoName, pickedFile: null, pickedPhoto: entity);

        final File? fileFromAsset = await selectedFile.pickedPhoto!.file;

        if (fileFromAsset != null) {
          final String fileSize = await HelperUtils.getFileSize(fileFromAsset, 1);
          selectedFile = selectedFile.updateSize(fileSize);
        }

        pickedFiles.add(selectedFile);

        // if (emptyFile.value) emptyFile.value = false;
      }
      pickedFiles.refresh();
    } else {
      recentPhotos.add(entity);
      pickedFiles.add(SelectedFile(fileName: photoName, pickedFile: null, pickedPhoto: entity));
      // if (emptyFile.value) emptyFile.value = false;
      pickedFiles.refresh();
    }
  }

  void _removeRecentlyAddedPhotos() {
    if (recentPhotos.isNotEmpty) {
      for (var photo in recentPhotos) {
        pickedFiles.removeWhere((element) => element.pickedPhoto == photo);
      }

      recentPhotos.clear();
      pickedFiles.refresh();
    }
  }

  void removePickedFile(int index) {
    pickedFiles.removeAt(index);
    pickedFiles.refresh();
    if (pickedFiles.isEmpty && Get.isDialogOpen == true) {
      Get.back();
    }
  }

  Future<bool> quitCreateDialog() async {
    final bool? res = await Get.dialog(
      AppConfirmDialog(
        height: 250.0,
        message: 'messages_message_closeCreateForm'.tr,
        confirmLabel: 'button_yes'.tr,
        cancelLabel: 'button_cancel'.tr,
      ),
      barrierColor: Colors.black.withOpacity(.6),
    );

    return res ?? false;
  }
}
