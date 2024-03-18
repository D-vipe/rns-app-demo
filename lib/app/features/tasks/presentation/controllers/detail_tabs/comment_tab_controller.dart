import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_comment.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_detail_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/views/detail/tabs/components/new_comment_form.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';

class CommentTabController extends GetxController {
  static CommentTabController get to => Get.find();
  TasksDetailController get _parentController => TasksDetailController.to;

  final TextEditingController commentController = TextEditingController();
  final RxList<TaskComment> data = <TaskComment>[].obs;
  final RxBool addingComment = false.obs;
  final RxString commentError = ''.obs;

  final List<int> renderedIds = [];

  late ScrollController scrollController;

  @override
  void onInit() {
    scrollController = ScrollController();
    commentController.addListener(_resetCommentError);
    data.value = TasksDetailController.to.data.value?.comments ?? [];
    ever(TasksDetailController.to.data, (callback) => data.value = TasksDetailController.to.data.value?.comments ?? []);
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var item in data) {
        renderedIds.add(item.id);
      }
    });
  }

  @override
  void onReady() {
    scrollController.addListener(() => _parentController.scrollListener(scrollController));
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    commentController.dispose();
    super.onClose();
  }

  void _resetCommentError() {
    if (commentController.text != '' && commentError.value.isNotEmpty) {
      commentError.value = '';
    }
  }

  void openAddCommentDialog() {
    Get.bottomSheet(
      const NewCommentFormWidget(),
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      useRootNavigator: true,
    ).then((value) {
      addingComment.value = false;
      commentController.text = '';
    });
  }

  Future<void> addNewComment() async {
    FocusScope.of(Get.context!).unfocus();
    addingComment.value = true;
    try {
      if (commentController.text.isEmpty) {
        commentError.value = 'tasks_error_emptyComment'.tr;
        addingComment.value = false;
        return;
      } else {
        await _parentController.repository
            .addNewComment(taskId: TasksController.to.detailTaskId!, comment: commentController.text)
            .then((value) async {
          if (value) {
            commentController.text = '';

            // Обновим данные
            await _parentController
                .getData()
                .then((value) => data.value = _parentController.data.value?.comments ?? []);

            Get.back();
          } else {
            SnackbarService.error('tasks_error_comment'.tr);
          }
        });
      }
    } catch (e) {
      final cleanError = e.toString().cleanException();

      SnackbarService.error(cleanError);
    }
    addingComment.value = false;
  }
}
