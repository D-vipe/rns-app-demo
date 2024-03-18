import 'package:rns_app/app/features/home/data/dto/user_settings_dto.dart';

class UserDTO {
  final String id;
  final String fio;
  final String? avatarUrl;
  final UserSettingsDTO settings;
  final String? position;

  UserDTO({
    required this.id,
    required this.fio,
    required this.avatarUrl,
    required this.settings,
    required this.position,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
        id: json['userId'],
        fio: json['fio'],
        avatarUrl: json['avatarUrl'],
        settings: UserSettingsDTO.fromJson(json['additionalSettings']),
        position: json['position'],
      );
}
