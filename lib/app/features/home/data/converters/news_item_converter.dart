import 'package:rns_app/app/features/home/data/dto/news_item_dto.dart';
import 'package:rns_app/app/features/home/domain/models/news_item.dart';

class NewsItemConverter {
  static NewsItem mapDTO(NewsItemDTO data) => NewsItem(
        title: data.title,
        imagePath: data.imageUrl,
        header: '',
        bodyText: data.subTitle,
        creationDate: DateTime.parse(data.dateCreate),
      );
}
