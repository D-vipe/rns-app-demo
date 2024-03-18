import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';

class EmailListItem {
  final int id;
  final String title;
  final String subTitle;
  final Importance importance;
  final bool hasAttachment;
  final DateTime created;
  final bool unread;

  const EmailListItem({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.importance,
    required this.hasAttachment,
    required this.created,
    required this.unread,
  });

  EmailListItem copyWith({
    bool? unread,
    Importance? importance,
  }) =>
      EmailListItem(
        id: id,
        title: title,
        subTitle: subTitle,
        importance: importance ?? this.importance,
        hasAttachment: hasAttachment,
        created: created,
        unread: unread ?? this.unread,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailListItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          subTitle == other.subTitle &&
          importance == other.importance &&
          hasAttachment == other.hasAttachment &&
          created == other.created &&
          unread == other.unread;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      subTitle.hashCode ^
      importance.hashCode ^
      hasAttachment.hashCode ^
      unread.hashCode ^
      created.hashCode;
}
