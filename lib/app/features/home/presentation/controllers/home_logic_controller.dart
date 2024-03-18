import 'package:get/get.dart';
import 'package:rns_app/app/dependency/repository_module.dart';
import 'package:rns_app/app/features/home/domain/models/directions_model.dart';
import 'package:rns_app/app/features/home/domain/models/news_item.dart';
import 'package:rns_app/app/features/home/domain/models/plan_info.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/configs/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeLogicController extends GetxController {
  final _repository = RepositoryModule.homeRepository();

  final Rxn<PlanInfo> plan = Rxn(null);
  final Rxn<NewsItem> news = Rxn(null);
  final RxList<Direction> directions = <Direction>[].obs;
  final RxBool loadingData = false.obs;
  final Rxn<String> errorMessage = Rxn(null);
  final RxBool generalErrorDebouncer = false.obs;
  final RxBool launchingUrl = false.obs;

  @override
  void onReady() {
    if (!HomeController.to.loggingOutProcess) {
      getData();
    }
    super.onReady();
  }

  Future<void> getData() async {
    loadingData.value = true;
    try {
      final data = await _repository.getMainScreen();

      news.value = data.$1;
      plan.value = data.$2;
      directions.value = data.$3;
    } catch (e) {
      final String error = e.toString().cleanException();
      if (generalErrorDebouncer.value == false) {
        generalErrorDebouncer.value = true;
        SnackbarService.error(error, duration: 30, snackDebounce: generalErrorDebouncer);
      }
    }
    loadingData.value = false;
  }

  void openUrl(String _url) async {
    launchingUrl.value = true;
    if (!await launchUrl(Uri.parse(_url))) {
      SnackbarService.error('error_launchUrl'.tr);
    }
    launchingUrl.value = false;
  }

  void openNews() {
    HomeController.to.navigateTo(Routes.NEWS);
  }
}
