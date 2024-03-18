import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_date_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_description_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_files_tab_controller.dart';
import 'package:rns_app/app/features/tasks/presentation/controllers/form_tabs/form_general_tab_controller.dart';

class TaskFormTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GeneralFormTabController());
    Get.lazyPut(() => DateFormTabController());
    Get.lazyPut(() => DescriptionTabController());
    Get.lazyPut(() => FormFilesTabController());
  }
}
