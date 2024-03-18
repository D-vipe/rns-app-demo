import 'package:hive_flutter/hive_flutter.dart';
import 'package:rns_app/app/features/home/domain/models/user_model.dart';
import 'package:rns_app/app/features/home/domain/models/user_settings_model.dart';

class HiveService {
  static late Box user;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserPortalSettingsAdapter());
    Hive.registerAdapter(UserAdapter());

    user = await Hive.openBox<User>('users');
  }

  static User? getUser() {
    User? userData;
    final List<User> values = user.values.toList().cast<User>();
    if (values.isNotEmpty) {
      userData = user.values.first;
    }
    return userData;
  }

  static String? getUserId() {
    User? userData = getUser();
    String? userId;

    if (userData != null) {
      userId = userData.id;
    }

    return userId;
  }

  static Future<void> addUser({required User data}) async {
    // clear box first
    await user.clear();
    await user.put(data.id, data);
  }

  static Future<void> clearUser() async {
    await user.clear();
  }
}
