import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/appbar_controller.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/features/home/presentation/views/components/appbar/user_title.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';
import 'package:rns_app/resources/resources.dart';

class AppSliverAppBar extends GetView<AppBarController> {
  const AppSliverAppBar({
    super.key,
    this.topPinnedWidget,
  });

  final Widget? topPinnedWidget;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SliverAppBar(
        backgroundColor: context.colors.backgroundPrimary,
        surfaceTintColor: context.colors.backgroundPrimary,
        automaticallyImplyLeading: false,
        expandedHeight: controller.showFlexibleSpace.value == true ? 145.0 : 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: _PinnedAppBar(
            controller: controller,
            topPinnedWidget: topPinnedWidget,
          ),
        ),
        pinned: true,
        flexibleSpace: controller.showFlexibleSpace.value == true
            ? FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.fromLTRB(21.0, 12.0, 26.0, 15.0),
                  margin: const EdgeInsets.only(bottom: 45.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.appbarLogo),
                      const SizedBox(
                        width: 15.6,
                      ),
                      const AppBarExpansionTitle(),
                    ],
                  ),
                ),
                expandedTitleScale: 1.0,
              )
            : null,
      ),
    );
  }
}

class _PinnedAppBar extends StatelessWidget {
  const _PinnedAppBar({
    required this.controller,
    this.topPinnedWidget,
  });

  final AppBarController controller;
  final Widget? topPinnedWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      color: context.colors.inputBackground,
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding, vertical: AppConstraints.screenPadding),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.loose,
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Builder(builder: (context) {
              return GestureDetector(
                onTap: () =>
                    controller.leadingFun != null ? controller.leadingFun!() : Scaffold.of(context).openDrawer(),
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: SvgPicture.asset(
                      key: ValueKey<String>(controller.leadingAsset.value),
                      controller.leadingAsset.value,
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                ),
              );
            }),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
            child: Center(
              child: Obx(
                () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      key: ValueKey<String>(controller.title.value),
                      controller.title.value,
                      style: context.textStyles.header1,
                      overflow: TextOverflow.ellipsis,
                    )),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Obx(
              () => controller.actionAsset.value != null
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: controller.actionFun,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: SvgPicture.asset(
                              key: ValueKey<String>(controller.actionAsset.value!),
                              controller.actionAsset.value!,
                              width: 24.0,
                              height: 24.0,
                              colorFilter: controller.actionActive.value
                                  ? ColorFilter.mode(
                                      context.colors.success,
                                      BlendMode.srcIn,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        if (controller.actionAsset2.value != null)
                          const SizedBox(
                            width: 10.0,
                          ),
                        if (controller.actionAsset2.value != null)
                          GestureDetector(
                            onTap: controller.actionFun2,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: SvgPicture.asset(
                                key: ValueKey<String>(controller.actionAsset2.value!),
                                controller.actionAsset2.value!,
                                width: 24.0,
                                height: 24.0,
                                colorFilter: controller.actionActive2.value
                                    ? ColorFilter.mode(
                                        context.colors.success,
                                        BlendMode.srcIn,
                                      )
                                    : null,
                              ),
                            ),
                          )
                      ],
                    )
                  : controller.actionName.value != null
                      ? Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: controller.actionFun,
                            child: Text(
                              controller.actionName.value!,
                              style: context.textStyles.body.copyWith(
                                color: context.colors.buttonActive,
                                decoration: TextDecoration.underline,
                                decorationColor: context.colors.buttonActive,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
          ),
          if (topPinnedWidget != null)
            Positioned(
              bottom: HomeController.to.widgetBottom,
              left: HomeController.to.widgetLeft,
              right: HomeController.to.widgetRight,
              top: HomeController.to.widgetTop,
              child: GestureDetector(onTap: () => print('oaisoiaosiaoijsoi'), child: topPinnedWidget!),
            )
        ],
      ),
    );
  }
}
