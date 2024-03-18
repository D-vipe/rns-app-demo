import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_bug.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_detail_controller.dart';

class BugsTabController extends GetxController {
  TasksDetailController get _parentController => TasksDetailController.to;

  final RxList<TaskBug> data = <TaskBug>[].obs;

  late ScrollController scrollController;

  @override
  void onInit() {
    scrollController = ScrollController();
    data.value = _parentController.data.value?.bugs ?? [];
    ever(_parentController.data, (_) => data.value = _parentController.data.value?.bugs ?? []);
    super.onInit();
  }

  @override
  void onReady() {
    scrollController.addListener(() => _parentController.scrollListener(scrollController));
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
