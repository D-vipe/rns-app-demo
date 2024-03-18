import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/general/domain/entities/selected_file_model.dart';
import 'package:rns_app/app/features/general/presentation/controllers/media_gallery_controller.dart';
import 'package:rns_app/app/features/general/presentation/views/components/media_gallery_bottomsheet.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_create_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/view_models/added_file_view_model.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/helper_utils.dart';

class FormFilesTabController extends GetxController with GetTickerProviderStateMixin {
  static FormFilesTabController get to => Get.find();

  final _filesRepo = RepositoryModule.filesRepository();

  final RxList<SelectObject> availableFileTypes = <SelectObject>[].obs;
  List<AssetEntity> recentPhotos = <AssetEntity>[];
  RxList<Rx<AddedFileViewModel>> pickedFiles = <Rx<AddedFileViewModel>>[].obs;
  final RxBool loadingTypes = false.obs;

  late ScrollController scrollController;

  @override
  void onInit() {
    scrollController = ScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    getFileTypes();
    super.onReady();
  }

  @override
  void onClose() {
    for (var el in pickedFiles) {
      el.value.animationController.dispose();
      el.value.commentController.dispose();
    }
    super.onClose();
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

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      // if (emptyFile.value) emptyFile.value = false;
      List<File> files = result.paths.map((path) => File(path!)).toList();

      // check if selected files were previously selected
      for (final (index, item) in files.indexed) {
        bool notPickedYet = true;
        for (var picked in pickedFiles) {
          if (item.path == picked.value.item.pickedFile?.path && picked.value.showed == true) notPickedYet = false;
        }
        if (notPickedYet) {
          SelectedFile newPickedFile = SelectedFile(
              fileName: result.files[index].name, pickedFile: File(result.files[index].path!), pickedPhoto: null);

          final String fileSize = await HelperUtils.getFileSize(newPickedFile.pickedFile!, 1);
          newPickedFile = newPickedFile.updateSize(fileSize);

          final FocusNode addedFocusNode = FocusNode();

          addedFocusNode.addListener(
              () => HelperUtils.hideBottomSheetActionButton(addedFocusNode, TasksCreateController.to.hideActionButton));

          pickedFiles.add(
            AddedFileViewModel(
              item: newPickedFile,
              fileType: null,
              animationController: AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 500),
              ),
              commentController: TextEditingController(),
              focusNode: addedFocusNode,
              showed: false,
              error: null,
            ).obs,
          );

          pickedFiles.refresh();
          await Future.delayed(const Duration(milliseconds: 100), () {
            pickedFiles.last.value = pickedFiles.last.value.copyWith(
              showed: true,
              fileType: null,
              error: null,
            );
            pickedFiles.last.value.animationController.forward();
          });
        }
      }
    }
  }

  Future<void> pickPhoto() async {
    if (!Get.isRegistered<MediaGalleryController>()) {
      Get.put(MediaGalleryController());
      List<AssetEntity> selectedPhotos = [];
      for (var element in pickedFiles) {
        if (element.value.item.pickedPhoto != null) {
          selectedPhotos.add(element.value.item.pickedPhoto!);
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
      for (var element in pickedFiles) {
        if (element.value.item.pickedPhoto == entity) {
          matchFound == true;
          // remove matching element
          pickedFiles.removeWhere((e) => e == element);
        }
      }

      if (matchFound == false) {
        // add entities to this List. If modal is closed, not applied. Remove all recently added photos

        recentPhotos.add(entity);

        final FocusNode addedFocusNode = FocusNode();

        addedFocusNode.addListener(
            () => HelperUtils.hideBottomSheetActionButton(addedFocusNode, TasksCreateController.to.hideActionButton));

        pickedFiles.add(AddedFileViewModel(
          item: SelectedFile(fileName: photoName, pickedFile: null, pickedPhoto: entity),
          fileType: null,
          animationController: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          ),
          commentController: TextEditingController(),
          focusNode: addedFocusNode,
          showed: false,
          error: null,
        ).obs);
        // if (emptyFile.value) emptyFile.value = false;
      }
      pickedFiles.refresh();
      await Future.delayed(const Duration(milliseconds: 100), () {
        pickedFiles.last.value = pickedFiles.last.value.copyWith(showed: true, fileType: null, error: null);
        pickedFiles.last.value.animationController.forward();
      });
    } else {
      recentPhotos.add(entity);
      final FocusNode addedFocusNode = FocusNode();

      addedFocusNode.addListener(
          () => HelperUtils.hideBottomSheetActionButton(addedFocusNode, TasksCreateController.to.hideActionButton));

      pickedFiles.add(AddedFileViewModel(
        item: SelectedFile(fileName: photoName, pickedFile: null, pickedPhoto: entity),
        fileType: null,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        ),
        commentController: TextEditingController(),
        focusNode: addedFocusNode,
        showed: false,
        error: null,
      ).obs);
      pickedFiles.refresh();
      await Future.delayed(const Duration(milliseconds: 100), () {
        pickedFiles.last.value = pickedFiles.last.value.copyWith(showed: true, fileType: null, error: null);
        pickedFiles.last.value.animationController.forward();
      });
    }
  }

  void _removeRecentlyAddedPhotos() {
    if (recentPhotos.isNotEmpty) {
      for (var photo in recentPhotos) {
        var searchedItem = pickedFiles.firstWhereOrNull((element) => element.value.item.pickedPhoto == photo);

        if (searchedItem != null) {
          searchedItem.value.animationController.reverse().then(
                (value) => searchedItem.value = searchedItem.value.copyWith(
                  showed: false,
                  fileType: searchedItem.value.fileType,
                  error: null,
                ),
              );
        }
      }

      recentPhotos.clear();
      // pickedFiles.refresh();
    }
  }

  Future<void> removeAddedFileWidget(int index) async {
    pickedFiles[index].value.animationController.reverse().then((value) {
      pickedFiles[index].value =
          pickedFiles[index].value.copyWith(fileType: pickedFiles[index].value.fileType, showed: false, error: null);
    });
  }

  void onFileTypeChange(int index, {SelectObject? newValue}) {
    pickedFiles[index].value = pickedFiles[index].value.copyWith(fileType: newValue, error: null);
  }

  void resetFileTypeValue(int index) {
    pickedFiles[index].value = pickedFiles[index].value.copyWith(fileType: null, error: null);
  }

  void resetFilesFormTab() {
    recentPhotos = [];
    pickedFiles.value = [];
  }
}
