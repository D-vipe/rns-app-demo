import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_controller.dart';


class EmailCoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmailController());
  }
}
