import 'package:get/get.dart';
import 'package:rns_app/app/features/employee/presentation/controllers/employee_filter_controller.dart';

class EmployeeFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeFilterController());
  }
}
