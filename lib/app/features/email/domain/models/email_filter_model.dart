import 'package:flutter/foundation.dart';
import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';

class EmailFilterModel {
  final String searchTitle;
  final SelectObject? recepient;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final List<Importance> importance;
  final bool? onlyUnread;

  const EmailFilterModel({
    required this.searchTitle,
    required this.recepient,
    required this.dateFrom,
    required this.dateTo,
    required this.importance,
    required this.onlyUnread,
  });

  factory EmailFilterModel.initial() => const EmailFilterModel(
        searchTitle: '',
        recepient: null,
        dateFrom: null,
        dateTo: null,
        importance: [],
        onlyUnread: false,
      );

  EmailFilterModel copyWith({
    String? searchTitle,
    SelectObject? recepient,
    DateTime? dateFrom,
    DateTime? dateTo,
    List<Importance>? importance,
    bool? onlyUnread,
  }) =>
      EmailFilterModel(
          searchTitle: searchTitle ?? this.searchTitle,
          recepient: recepient,
          dateFrom: dateFrom,
          dateTo: dateTo,
          importance: importance ?? this.importance,
          onlyUnread: onlyUnread);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailFilterModel &&
          runtimeType == other.runtimeType &&
          searchTitle == other.searchTitle &&
          recepient == other.recepient &&
          dateFrom == other.dateFrom &&
          dateTo == other.dateTo &&
          listEquals(importance, other.importance) &&
          onlyUnread == other.onlyUnread;

  @override
  int get hashCode =>
      searchTitle.hashCode ^
      recepient.hashCode ^
      dateFrom.hashCode ^
      dateTo.hashCode ^
      importance.hashCode ^
      onlyUnread.hashCode;
}
