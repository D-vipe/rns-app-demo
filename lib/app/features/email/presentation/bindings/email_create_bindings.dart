import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_create_controller.dart';

class EmailCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmailCreateController());
  }
}
