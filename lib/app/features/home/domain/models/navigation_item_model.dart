// Универсальная модель. Используется в BottomNavBar и Drawer
class NavItem {
  final String path;
  final String? title;
  final String asset;
  final String altAsset;

  NavItem({
    required this.path,
    this.title,
    required this.asset,
    required this.altAsset,
  });
}
