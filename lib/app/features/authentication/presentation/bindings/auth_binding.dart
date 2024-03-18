import 'package:get/get.dart';
import 'package:rns_app/app/features/authentication/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}
