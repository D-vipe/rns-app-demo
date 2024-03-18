import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/views/widgets/news_widget.dart';
import 'package:rns_app/app/features/news/presentation/controllers/news_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class NewsDetailedView extends GetView<NewsController> {
  const NewsDetailedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundPrimary,
      child: Padding(
        padding: const EdgeInsets.all(AppConstraints.screenPadding),
        child: Obx(
          () => NewsWidget(
            news: controller.chosenItem.value!,
          ),
        ),
      ),
    );
  }
}
