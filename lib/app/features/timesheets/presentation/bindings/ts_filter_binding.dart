import 'package:get/get.dart';
import 'package:rns_app/app/features/timesheets/presentation/controllers/ts_filter_controller.dart';

class TSFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TSFilterController());
  }

}