import 'package:rns_app/app/dependency/api_module.dart';
import 'package:rns_app/app/features/home/data/converters/news_item_converter.dart';
import 'package:rns_app/app/features/home/data/dto/news_item_dto.dart';
import 'package:rns_app/app/features/home/domain/models/news_item.dart';

class NewsRepository {
  final _service = ApiModule.newsService();

  Future<List<NewsItem>> getAllNews(int page, {int pageSize = 20}) async {
    List<NewsItemDTO> newsDto = await _service.getAllNews(page, pageSize);
    final result = newsDto.map((e) => NewsItemConverter.mapDTO(e)).toList();
    return result;
  }
}