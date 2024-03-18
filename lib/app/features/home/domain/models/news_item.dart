import 'package:intl/intl.dart';

class NewsItem {
  final String title;
  final String imagePath;
  //тут по логике либо url c бэка, либо в маппинге из DTO
  //смотреть в зависимости от типа обьявления и давать нужный ассет
  //С тайтлом то же самое
  final String header;
  final String bodyText;
  final DateTime creationDate;

  NewsItem({
    required this.title,
    required this.imagePath,
    required this.header,
    required this.bodyText,
    required this.creationDate,
  });

  String getDateString() {
    final format = DateFormat('dd.MM.yyyy');
    return format.format(creationDate);
  }
}
