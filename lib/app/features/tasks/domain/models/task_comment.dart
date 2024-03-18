class TaskComment {
  final int id;
  final String title;
  final int number;
  final int numberContragent;
  final String author;
  final String dateCreate;

  const TaskComment({
    required this.id,
    required this.title,
    required this.number,
    required this.numberContragent,
    required this.author,
    required this.dateCreate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskComment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          number == other.number &&
          numberContragent == other.numberContragent &&
          author == other.author &&
          dateCreate == other.dateCreate;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      number.hashCode ^
      numberContragent.hashCode ^
      author.hashCode ^
      dateCreate.hashCode;
}
