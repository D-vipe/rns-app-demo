import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_controller.dart';

class TasksCoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TasksController());
  }
}
