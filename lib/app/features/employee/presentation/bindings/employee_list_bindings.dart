import 'package:get/get.dart';
import 'package:rns_app/app/features/employee/presentation/controllers/employee_list_controller.dart';

class EmployeeListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeListController());
  }
}
