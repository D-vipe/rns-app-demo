class TaskCommentDTO {
  final int id;
  final String title;
  final int number;
  final int? numberContragent;
  final String author;
  final String dateCreate;

  const TaskCommentDTO({
    required this.id,
    required this.title,
    required this.number,
    required this.numberContragent,
    required this.author,
    required this.dateCreate,
  });

  factory TaskCommentDTO.fromJson(Map<String, dynamic> json) => TaskCommentDTO(
        id:json['id'],
        title:json['title'],
        number:json['number'],
        numberContragent:json['numberContragent'],
        author:json['author'],
        dateCreate:json['dateCreate'],
      );
}
