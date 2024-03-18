import 'package:get/get.dart';

class EmployeeFilterController extends GetxController {
  static EmployeeFilterController get to => Get.find();

  void clearFilters() {
    Get.log('Clear employee filters');
  }
}
