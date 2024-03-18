import 'package:get/get.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/ts_create_controller.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/ts_list_controller.dart';

class TsChildrenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TsListController());
    Get.lazyPut(() => TsCreateController(), fenix: true);
  }
}
