import 'package:get/get.dart';
import 'package:rns_app/app/features/employee/presentation/controllers/employee_controller.dart';

class EmployeesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeController());
  }
}
