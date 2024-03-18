import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/appbar_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/bottomnav_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.put(AppBarController());
    Get.put(BottomNavController());
  }
}
