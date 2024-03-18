import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_list_controller.dart';

class EmailListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EmailListController(), permanent: true);
  }
}
