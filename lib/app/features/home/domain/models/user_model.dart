import 'package:hive/hive.dart';
import 'package:rns_app/app/features/home/domain/models/user_settings_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String fio;
  @HiveField(2)
  final String? avatarUrl;
  @HiveField(3)
  final UserPortalSettings settings;
  @HiveField(4)
  final String? position;

  User({
    required this.id,
    required this.fio,
    required this.avatarUrl,
    required this.settings,
    required this.position,
  });
}
