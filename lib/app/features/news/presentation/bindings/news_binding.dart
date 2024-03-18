import 'package:get/get.dart';
import 'package:rns_app/app/features/news/presentation/controllers/news_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewsController());
  }
}
