import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/general/domain/entities/push_notification.dart';
import 'package:rns_app/app/features/general/domain/utils/fcm_util.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';

class FCMController extends GetxController {
  static FCMController get to => Get.find();
  final FirebaseMessaging messaging = FCMUtil.messaging;
  final NotificationSettings settings = FCMUtil.settings;

  PushNotification? notification;
  RxBool messageClosed = false.obs;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  Future<void> _init() async {
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final message = await messaging.getInitialMessage();

      if (message != null) {
        Get.log('MESSAGE RECEIVED VIA GETINITIALMESSAGE');
      }

      _onForegroundMessage();
      _onBackgroundMessage();
      _onMessageOpened();
    } else {
      Get.log('Пользователь не предоставил доступ для получения уведомлений');
    }
  }

  @override
  void onReady() {
    ever(messageClosed, (callback) => notification = null);
    super.onReady();
  }

  void _onForegroundMessage() {
    messaging;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Parse the message received
      notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      if (notification?.title != null) {
        SnackbarService.info(
          notification!.title!,
          snackDebounce: messageClosed,
        );
      }
    });
  }

  void _onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print('RECEIVED REMOTE MESSAGE: ${message.toString()}');
    });
  }

  void _onMessageOpened() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event.data['type'] == 'message') {
        if (int.tryParse(event.data['subscriberId']) != null) {
          /*RootController.to.goToMessages(
              subscriberId: int.tryParse(event.data['subscriberId'])!,
              subscriberName: event.data['subscriberName']);*/
        }
      }

      if (event.data['type'] == 'notification') {
        //RootController.to.navigateTo(index: 3);
      }

      if (notification?.title != null) {
        SnackbarService.info(
          notification!.title!,
          snackDebounce: messageClosed,
        );
      }
    });
  }
}
