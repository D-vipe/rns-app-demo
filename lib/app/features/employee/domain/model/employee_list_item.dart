class EmployeeListItem {
  final int id;
  final String title;
  final bool isAllowWriteMessage;
  final bool isAllowWriteEmail;
  final String? userId;
  final String? email;
  final String? phones;
  final String? timeWith;
  final String? position;
  final String? urlLeftIcon;
  final bool isVisibleLeftIcon;
  final String? urlRightIcon;
  final bool isVisibleRightIcon;

  const EmployeeListItem({
    required this.id,
    required this.title,
    required this.isAllowWriteMessage,
    required this.isAllowWriteEmail,
    required this.userId,
    required this.email,
    required this.phones,
    required this.timeWith,
    required this.position,
    required this.urlLeftIcon,
    required this.isVisibleLeftIcon,
    required this.urlRightIcon,
    required this.isVisibleRightIcon,
  });
}
