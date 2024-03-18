import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/views/components/bottom_navigation/default_botom_nav.dart';

class BottomNavController extends GetxController {
  static BottomNavController get to => Get.find();

  Rx<Widget> navItemsList =
      const DefaultBottomNav().obs;


  void reset() {
    navItemsList.value = const DefaultBottomNav();
  }
}
