import 'package:rns_app/app/features/home/data/converters/user_settings_converter.dart';
import 'package:rns_app/app/features/home/data/dto/user_dto.dart';
import 'package:rns_app/app/features/home/domain/models/user_model.dart';

class UserConverter {
  static User mapDTO(UserDTO data) => User(
        id: data.id,
        fio: data.fio,
        avatarUrl: data.avatarUrl != null ? (data.avatarUrl!.isNotEmpty ? data.avatarUrl : null) : null,
        settings: UserSettingsConverter.mapDTO(data.settings),
        position: data.position,
      );
}
