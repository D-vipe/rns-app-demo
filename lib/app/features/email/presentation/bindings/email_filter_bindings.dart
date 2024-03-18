import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_filter_controller.dart';

class EmailFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmailFilterController());
  }
}
