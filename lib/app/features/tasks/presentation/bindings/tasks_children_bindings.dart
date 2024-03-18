import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/bugs_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/comment_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/files_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/detail_tabs/general_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_create_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_detail_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_filter_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/tasks_list_controller.dart';

class TasksChildrenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TasksListController(), fenix: true);
    Get.lazyPut(() => TasksCreateController(), fenix: true);
    Get.lazyPut(() => TasksDetailController(), fenix: true);
    Get.lazyPut(() => GeneralTabController(), fenix: true);
    Get.lazyPut(() => CommentTabController(), fenix: true);
    Get.lazyPut(() => FilesTabController(), fenix: true);
    Get.lazyPut(() => BugsTabController(), fenix: true);
    Get.lazyPut(() => TasksFilterController(), fenix: true);
  }
}
