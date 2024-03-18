import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_logic_controller.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
    this.drawer,
    this.sliverAppBar,
    this.navigationBar,
    this.floatingActionButton,
  });

  final Widget child;
  final Widget? sliverAppBar;
  final Widget? drawer;
  final Widget? navigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    Get.put(HomeLogicController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBody: false,
        resizeToAvoidBottomInset: true,
        drawer: drawer,
        body: SafeArea(
          top: false,
          child: Obx(
            () => CustomScrollView(
              controller: HomeController.to.scrollController,
              physics: HomeController.to.disableScroll.value
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              slivers: [
                if (sliverAppBar != null) sliverAppBar!,
                SliverFillRemaining(
                  hasScrollBody: HomeController.to.enableScrollBody.value,
                  child: child,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: navigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
