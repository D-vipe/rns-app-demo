class EmployeeListItemDTO {
  final int id;
  final String title;
  final bool? isAllowWriteMessage;
  final bool? isAllowWriteEmail;
  final String? userId;
  final String? email;
  final String? phones;
  final String? subTitle;
  final String? urlLeftIcon;
  final bool? isVisibleLeftIcon;
  final String? urlRightIcon;
  final bool? isVisibleRightIcon;
  final bool? isVisibleImportance;
  final int? importance;

  const EmployeeListItemDTO({
    required this.id,
    required this.title,
    required this.isAllowWriteMessage,
    required this.isAllowWriteEmail,
    required this.userId,
    required this.email,
    required this.phones,
    required this.subTitle,
    required this.urlLeftIcon,
    required this.isVisibleLeftIcon,
    required this.urlRightIcon,
    required this.isVisibleRightIcon,
    required this.isVisibleImportance,
    required this.importance,
  });

  factory EmployeeListItemDTO.fromJson(Map<String, dynamic> json) => EmployeeListItemDTO(
        id: json['id'],
        title: json['title'],
        isAllowWriteMessage: json['isAllowWriteMessage'],
        isAllowWriteEmail: json['isAllowWriteEmail'],
        userId: json['userId'],
        email: json['email'],
        phones: json['phones'],
        subTitle: json['subTitle'],
        urlLeftIcon: json['urlLeftIcon'],
        isVisibleLeftIcon: json['isVisibleLeftIcon'],
        urlRightIcon: json['urlRightIcon'],
        isVisibleRightIcon: json['isVisibleRightIcon'],
        isVisibleImportance: json['isVisibleImportance'],
        importance: json['importance'],
      );
}
