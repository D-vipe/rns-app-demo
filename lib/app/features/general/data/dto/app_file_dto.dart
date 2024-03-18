class AppFileDTO {
  final int id;
  final String title;
  final String size;
  final String url;
  final String? description;
  final String? author;
  final String fileType;
  final String? dateCreate;

  const AppFileDTO({
    required this.id,
    required this.title,
    required this.size,
    required this.url,
    required this.description,
    required this.author,
    required this.fileType,
    required this.dateCreate,
  });

  factory AppFileDTO.fromJson(Map<String, dynamic> json) => AppFileDTO(
        id:json['id'],
        title:json['title'],
        size:json['size'],
        url:json['url'],
        description:json['description'],
        author:json['author'],
        fileType:json['fileType'] ?? '',
        dateCreate:json['dateCreate'],
      );
}
