import 'package:dio/dio.dart';
import 'package:rns_app/app/features/home/data/dto/news_item_dto.dart';
import 'package:rns_app/configs/data/dio_handler.dart';
import 'package:rns_app/configs/data/endpoints/api_endpoints.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class NewsService {
  final Dio _dio;

  NewsService(this._dio);

  Future<List<NewsItemDTO>> getAllNews(int page, int pageSize) async {
    List<NewsItemDTO> result = [];
    try {
      Response response = await _dio.get(
        NewsEndpoints.list,
        queryParameters: {
          'filter.pageSize' : pageSize,
          'filter.numPage' : page,
        }
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data != null && response.data['data'] != null) {
          try {
            List data = response.data['data'];
            result = data.map((e) => NewsItemDTO.fromJson(e)).toList();
          } catch (_) {
            print(_);
            throw ParseException();
          }
        }
      }
    } catch (e) {
      print(e);
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }
    return result;
  }
}
