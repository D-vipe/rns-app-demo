class NewsItemDTO {
  final int id;
  final String title;
  final String subTitle;
  final String imageUrl;
  final int importance;
  final String dateCreate;

  const NewsItemDTO({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.imageUrl,
    required this.importance,
    required this.dateCreate,
  });

  factory NewsItemDTO.fromJson(Map<String, dynamic> json) => NewsItemDTO(
        id: json['id'],
        title: json['title'],
        subTitle: json['subTitle'],
        imageUrl: json['urlLeftIcon'],
        importance: json['importance'],
        dateCreate: json['dateCreate'],
      );
}
