import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_logic_controller.dart';

class HomeLogicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeLogicController(),
    );
  }
}
