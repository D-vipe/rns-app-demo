import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_logic_controller.dart';
import 'package:rns_app/app/features/home/presentation/views/widgets/current_plan_table.dart';
import 'package:rns_app/app/features/home/presentation/views/widgets/news_widget.dart';
import 'package:rns_app/app/features/home/presentation/views/widgets/plan_header_widget.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/links_constants.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';
import 'package:rns_app/resources/resources.dart';

class HomeView extends GetView<HomeLogicController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.loadingData.value
          ? const Loader()
          : Container(
              // без этого цвета page transition выглядит немного коряво
              color: context.colors.backgroundPrimary,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstraints.screenPadding,
                      ),
                      child: PlanHeaderWidget(),
                    ),
                    if (controller.plan.value != null) const SizedBox(height: 16),
                    if (controller.plan.value != null) const CurrentPlanTable(),
                    const SizedBox(height: 18),
                    Obx(() {
                      if (controller.news.value != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstraints.screenPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'home_news'.tr,
                                style: context.textStyles.header1,
                              ),
                              const SizedBox(height: 32),
                              NewsWidget(
                                news: controller.news.value!,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 36.0,
                                child: AppButton(
                                  label: 'home_allNews'.tr,
                                  onTap: controller.openNews,
                                  processing: false,
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstraints.screenPadding,
                      ),
                      child: Text(
                        'home_contactsAndScheme'.tr,
                        style: context.textStyles.header1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      AppImages.map,
                    ),
                    const SizedBox(height: 19),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstraints.screenPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(
                            controller.directions.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                controller.directions[index].text,
                                style: controller.directions[index].isHeader
                                    ? context.textStyles.header2
                                    : context.textStyles.subtitle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Obx(
                            () => Row(
                              children: [
                                IgnorePointer(
                                  ignoring: controller.launchingUrl.value,
                                  child: GestureDetector(
                                    onTap: () => controller.openUrl(LinkConstants.vk),
                                    child: SvgPicture.asset(
                                      AppIcons.vk,
                                      colorFilter: ColorFilter.mode(
                                        context.colors.main,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                IgnorePointer(
                                  ignoring: controller.launchingUrl.value,
                                  child: GestureDetector(
                                    onTap: () => controller.openUrl(LinkConstants.tg),
                                    child: SvgPicture.asset(
                                      AppIcons.telegram,
                                      colorFilter: ColorFilter.mode(
                                        context.colors.main,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
