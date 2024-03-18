class EmailItemDTO {
  final int id;
  final String title;
  final String subTitle;
  final int importance;
  // Флаг, по которому определяем есть ли вложение
  final bool isVisibleRightIcon;
  final String created;
  final bool isBoldTitle;

  const EmailItemDTO({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.importance,
    required this.isVisibleRightIcon,
    required this.created,
    required this.isBoldTitle,
  });

  factory EmailItemDTO.fromJson(Map<String, dynamic> json) => EmailItemDTO(
        id: json['id'],
        title: json['title'],
        subTitle: json['subTitle'],
        importance: json['importance'],
        isVisibleRightIcon: json['isVisibleRightIcon'],
        isBoldTitle: json['isBoldTitle'],
        created: json['dateCreate'],
      );
}
