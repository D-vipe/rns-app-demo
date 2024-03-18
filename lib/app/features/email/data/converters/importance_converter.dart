import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';

class ImportanceConverter {
  static Importance convert(int importance) {
    switch (importance) {
      case 0:
        return Importance.no;
      case 1:
        return Importance.low;
      case 2:
        return Importance.normal;
      case 3:
        return Importance.high;
      default:
        return Importance.no;
    }
  }
}
