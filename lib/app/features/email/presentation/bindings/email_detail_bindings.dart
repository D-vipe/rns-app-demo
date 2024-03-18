import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_detail_controller.dart';

class EmailDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmailDetailController(), fenix: true);
  }
}
