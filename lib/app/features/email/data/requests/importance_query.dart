import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';


class ImportanceQuery {
  final Importance importance;

  const ImportanceQuery({required this.importance});

  Map<String, dynamic> toJson() => {
    'importance': importance == Importance.no ? 'high' : ''
  };
}
