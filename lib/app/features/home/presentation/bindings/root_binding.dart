import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RootController(), permanent: true);
  }
}
