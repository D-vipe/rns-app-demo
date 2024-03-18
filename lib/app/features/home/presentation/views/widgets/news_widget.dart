import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rns_app/app/features/home/domain/models/news_item.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/utils/extensions.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({
    super.key,
    required this.news,
  });

  final NewsItem news;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateFormat.format(news.creationDate),
          style: context.textStyles.subtitleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CachedNetworkImage(
              width: 20.0,
              height: 20.0,
              // fit: BoxFit.contain,
              imageUrl: news.imagePath,
              placeholder: (_, __) => Loader(
                btn: true,
                size: 15.0,
                color: context.colors.inputBackground,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error_outline),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Text(
                news.title,
                style: context.textStyles.header1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 75,
            child: CachedNetworkImage(
              // fit: BoxFit.contain,
              imageUrl: news.imagePath,
              placeholder: (_, __) => Loader(
                btn: true,
                size: 15.0,
                color: context.colors.inputBackground,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error_outline),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          news.header,
          style: context.textStyles.header3,
        ),
        const SizedBox(height: 16),
        Text(
          news.bodyText,
          style: context.textStyles.body,
        ),
      ],
    );
  }
}
