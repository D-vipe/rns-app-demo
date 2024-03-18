import 'package:get/get_utils/get_utils.dart';
import 'package:rns_app/app/dependency/api_module.dart';
import 'package:rns_app/app/features/home/data/converters/directions_converter.dart';
import 'package:rns_app/app/features/home/data/converters/news_item_converter.dart';
import 'package:rns_app/app/features/home/data/converters/plan_info_converter.dart';
import 'package:rns_app/app/features/home/data/converters/user_converter.dart';
import 'package:rns_app/app/features/home/data/dto/user_dto.dart';
import 'package:rns_app/app/features/home/domain/models/directions_model.dart';
import 'package:rns_app/app/features/home/domain/models/news_item.dart';
import 'package:rns_app/app/features/home/domain/models/plan_info.dart';
import 'package:rns_app/app/features/home/domain/models/user_model.dart';
import 'package:rns_app/app/utils/hive_service.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class HomeRepository {
  final _service = ApiModule.homeService();

  Future<User?> getPersonalInfo({bool refresh = false}) async {
    User? result;
    UserDTO? userDTO;
    try {
      // Сначала проверяем локальное хранилище
      if (refresh == false) {
        result = HiveService.getUser();
      }

      if (result == null) {
        userDTO = await _service.getUserData();

        if (userDTO != null) {
          result = UserConverter.mapDTO(userDTO);
          // Запишем данные о пользователе в Hive.
          HiveService.addUser(data: result);
        }
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<(NewsItem?, PlanInfo?, List<Direction>)> getMainScreen() async {
    NewsItem? news;
    PlanInfo? plan;
    List<Direction> directions = [];
    List<String> errors = [];
    try {
      final resultDTO = await _service.getMainScreen();
      try {
        if (resultDTO.$1 != null) {
          news = NewsItemConverter.mapDTO(resultDTO.$1!);
        }
      } catch (_) {
        errors.add('home_error_parseNews'.tr);
      }

      try {
        if (resultDTO.$2 != null) {
          plan = PlanInfoConverter.mapDTO(resultDTO.$2!);
        }
      } catch (_) {
        errors.add('home_error_parsePlan'.tr);
      }

      try {
        if (resultDTO.$3.isNotEmpty) {
          directions = resultDTO.$3.map((json) => DirectionsConverter.mapDTO(json)).toList().cast<Direction>();
        }
      } catch (_) {
        errors.add('home_error_parseDirections'.tr);
      }
    } catch (_) {
      rethrow;
    }

    if (errors.isNotEmpty) {
      final combinedError = errors.join('\n');
      throw ParseException(combinedError);
    }

    return (news, plan, directions);
  }
}
