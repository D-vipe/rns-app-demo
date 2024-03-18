// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:unique_identifier/unique_identifier.dart';

// class FCMUtil {
//   static late final FirebaseMessaging messaging;
//   static late final NotificationSettings settings;

//   static Future<void> init() async {
//     await Firebase.initializeApp();
//     messaging = FirebaseMessaging.instance;

//     settings = await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );
//   }

//   static Future<String?> getFCMToken() async {
//     final String? fcmToken = await messaging.getToken();
//     print('FCM TOKEN: $fcmToken');
//     return fcmToken;
//   }

//   static Future<String?> getDeviceId() async {
//     String? deviceId;
//     try {
//       deviceId = await UniqueIdentifier.serial;
//       print('FCM DEVICE ID: $deviceId');
//     } catch (e) {
//       print('GET DEVICE ID ERROR $e');
//     }

//     return deviceId;
//   }
// }
