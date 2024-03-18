import 'package:flutter/material.dart';
import 'package:rns_app/app/features/home/presentation/views/components/bottom_navigation/bottom_nav_item.dart';
import 'package:rns_app/app/features/home/utils/navigation_lists.dart';

class DefaultBottomNav extends StatelessWidget {
  const DefaultBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...AppNavigationList.bottomList.map(
            (item) => BottomItem(item: item),
          )
        ]);
  }
}
