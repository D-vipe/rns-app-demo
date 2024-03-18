import 'package:get/get.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/timesheets_controller.dart';

class TimeSheetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TimeSheetController());
  }
}
