import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/domain/models/news_item.dart';
import 'package:rns_app/app/features/news/presentation/controllers/news_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';

class NewsListView extends GetView<NewsController> {
  const NewsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final news = controller.news;
    return Container(
      // без этого цвета page transition выглядит немного коряво
      color: context.colors.backgroundPrimary,
      child: Obx(() => SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  children: List.generate(
                    news.length,
                    (index) => InkWell(
                      onTap: () {
                        controller.chooseItem(news[index]);
                      },
                      child: NewsListItem(
                        item: news[index],
                      ),
                    ),
                  ),
                ),
              )
          // ListView(
          //   padding: EdgeInsets.zero,
          //   controller: controller.scrollController,
          //   children: List.generate(
          //     news.length,
          //     (index) => InkWell(
          //       onTap: () {
          //         controller.chooseItem(news[index]);
          //       },
          //       child: NewsListItem(
          //         item: news[index],
          //       ),
          //     ),
          //   ),
          // ),
          ),
    );
  }
}

class NewsListItem extends StatelessWidget {
  const NewsListItem({
    super.key,
    required this.item,
  });

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Image.network(
              item.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: context.textStyles.header3,
                ),
                const SizedBox(height: 4.0),
                Text(
                  item.header,
                  style: context.textStyles.subtitle.copyWith(
                    color: context.colors.text.main,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Text(
            item.getDateString(),
            style: context.textStyles.subtitle,
          ),
        ],
      ),
    );
  }
}
