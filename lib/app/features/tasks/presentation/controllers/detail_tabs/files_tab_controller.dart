import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/general/domain/entities/app_file_model.dart';
import 'package:rns_app/app/features/general/presentation/controllers/media_gallery_controller.dart';
import 'package:rns_app/app/features/general/presentation/views/components/media_gallery_bottomsheet.dart';
import 'package:rns_app/app/features/general/domain/entities/selected_file_model.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_detail_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/detail/tabs/components/new_file_form.dart';
import 'package:rns_app/app/features/tasks/presentation/views/detail/tabs/components/selected_files_dialog.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/helper_utils.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class FilesTabController extends GetxController with GetSingleTickerProviderStateMixin {
  final _filesRepo = RepositoryModule.filesRepository();
  static FilesTabController get to => Get.find();
  TasksDetailController get _parentController => TasksDetailController.to;
  late ScrollController scrollController;
  late AnimationController animationController;

  final TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionFocus = FocusNode();
  final RxString descriptionError = ''.obs;

  final RxList<SelectObject> availableFileTypes = <SelectObject>[].obs;
  final RxBool loadingTypes = false.obs;
  final Rxn<SelectObject> selectedFileType = Rxn(null);

  final RxBool downloading = false.obs;
  final RxBool savingForm = false.obs;
  final RxBool hideActionBtn = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt uploadingProgress = 0.obs;

  final RxList<Rx<AppFile>> data = <Rx<AppFile>>[].obs;

  List<AssetEntity> recentPhotos = <AssetEntity>[];
  RxList<SelectedFile> pickedFiles = <SelectedFile>[].obs;

  RxBool emptyFile = false.obs;

  Rxn<String> fileTypeError = Rxn(null);

  late Directory? directory;
  late ScrollController addedFilesScrollController;
  bool dirDownloadExists = true;

  @override
  void onInit() {
    scrollController = ScrollController();
    addedFilesScrollController = ScrollController();
    data.value = _parentController.data.value?.files.map((e) => Rx<AppFile>(e)).toList() ?? <Rx<AppFile>>[];
    ever(_parentController.data,
        (_) => data.value = _parentController.data.value?.files.map((e) => Rx<AppFile>(e)).toList() ?? <Rx<AppFile>>[]);
    _initSaveDir();
    _initAnimationController();
    super.onInit();
  }

  @override
  void onReady() {
    scrollController.addListener(() => _parentController.scrollListener(scrollController));
    descriptionFocus.addListener(() => HelperUtils.hideBottomSheetActionButton(descriptionFocus, hideActionBtn));
    getFileTypes();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    descriptionController.dispose();
    addedFilesScrollController.dispose();
    descriptionFocus.dispose();
    super.onClose();
  }

  void _initAnimationController() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> getFileTypes() async {
    loadingTypes.value = true;
    try {
      availableFileTypes.value = await _filesRepo.getFileTypes();
    } catch (e) {
      final String errorMessage = e.toString().cleanException();
      Get.log(errorMessage, isError: true);
    }
    loadingTypes.value = false;
  }

  Future<void> _initSaveDir() async {
    directory = await _filesRepo.initSaveDir();
    await _checkIfFileSaved();
  }

  Future<void> _checkIfFileSaved() async {
    for (var item in data) {
      await _filesRepo.checkIfFileSaved(fileName: item.value.title, directory: directory!).then((value) {
        if (value && !item.value.downloaded) {
          item.value = item.value.copyWith(downloaded: true, downloadProgress: '100');
        }
      });
    }
  }

  Future<void> openFile(AppFile item) async {
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

  Future<dynamic> downloadFile(Rx<AppFile> file) async {
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
          .downloadFile(item: file.value, directory: directory!, progressValue: progressValue)
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

  void openAddFileDialog() {
    Get.bottomSheet(
      Obx(
        () => PopScope(
          onPopInvoked: (didPop) => TasksController.to.onWillPop(didPop),
          canPop: false,
          child: IgnorePointer(
            ignoring: savingForm.value,
            child: GestureDetector(
              onTap: () => FocusScope.of(Get.context!).unfocus(),
              child: const NewFileFormWidget(),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      isDismissible: false,
      enableDrag: false,
    ).then((value) {
      // Reset variables relevant to form
      savingForm.value = false;
      clearSelectFilter();
    });
    animationController.forward();
  }

  void onFileTypeSelect(bool? value, int index) {
    if (selectedFileType.value == availableFileTypes[index]) {
      selectedFileType.value = null;
    } else {
      fileTypeError.value = null;
      selectedFileType.value = availableFileTypes[index];
    }
  }

  void clearSelectFilter() {
    pickedFiles.value = [];
    selectedFileType.value = null;
    recentPhotos.clear();
    descriptionController.text = '';
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      if (emptyFile.value) emptyFile.value = false;
      List<File> files = result.paths.map((path) => File(path!)).toList();

      // check if selected files were previously selected
      for (final (index, item) in files.indexed) {
        bool notPickedYet = true;
        for (var picked in pickedFiles) {
          if (item.path == picked.pickedFile?.path) notPickedYet = false;
        }
        if (notPickedYet) {
          pickedFiles.add(
            SelectedFile(
                fileName: result.files[index].name, pickedFile: File(result.files[index].path!), pickedPhoto: null),
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
        pickedFiles.add(SelectedFile(fileName: photoName, pickedFile: null, pickedPhoto: entity));
        if (emptyFile.value) emptyFile.value = false;
      }
      pickedFiles.refresh();
    } else {
      recentPhotos.add(entity);
      pickedFiles.add(SelectedFile(fileName: photoName, pickedFile: null, pickedPhoto: entity));
      if (emptyFile.value) emptyFile.value = false;
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

  bool _validateForm() {
    bool result = true;
    if (pickedFiles.isEmpty) {
      result = false;
      emptyFile.value = true;
    }
    if (selectedFileType.value == null) {
      result = false;
      fileTypeError.value = 'tasks_error_chooseFileType'.tr;
    }

    return result;
  }

  Future<bool> saveFile() async {
    FocusScope.of(Get.context!).unfocus();
    bool result = false;
    savingForm.value = true;
    if (_validateForm()) {
      try {
        uploadingProgress.value = 0;

        _showUploadingSnack();

        await _parentController.repository
            .uploadTaskFiles(
          taskId: TasksController.to.detailTaskId!,
          fileTypeId: int.parse(selectedFileType.value!.id),
          description: descriptionController.text,
          files: pickedFiles,
          progressValue: uploadingProgress,
        )
            .then((value) async {
          result = value;
          if (value) {
            // close bottom sheet and upload snackbar
            Get.back(closeOverlays: true);
            SnackbarService.success('tasks_message_filesSaved'.tr);

            await _parentController.getData().then((_) => data.value =
                _parentController.data.value?.files.map((e) => Rx<AppFile>(e)).toList() ?? <Rx<AppFile>>[]);
          } else {
            SnackbarService.error('tasks_error_uploadFile'.tr);
          }
          savingForm.value = false;
        });
      } catch (e) {
        SnackbarService.error(e.toString().cleanException());
        savingForm.value = false;
      }
    } else {
      savingForm.value = false;
    }

    return result;
  }

  Future<void> showSelectedFilesDialog() async {
    Get.dialog(
      const SelectedFilesDialog(),
      // barrierDismissible: false,
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
              () => Text('Загрузка файлов: ${uploadingProgress.value}%'),
            ),
            Expanded(
              child: Center(
                child: Obx(
                  () => LinearProgressIndicator(
                    minHeight: 5.0,
                    value: uploadingProgress.value / 100,
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
}
