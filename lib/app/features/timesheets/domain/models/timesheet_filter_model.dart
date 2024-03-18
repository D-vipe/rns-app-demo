import 'package:rns_app/app/uikit/general_models/select_object_model.dart';

class TimeSheetFilterModel {
  final DateTime date;
  // скорее-всего будет user или другая модель
  final SelectObject? executor;

  const TimeSheetFilterModel({required this.date, this.executor});

  TimeSheetFilterModel copyWith({DateTime? date, SelectObject? executor}) => TimeSheetFilterModel(
        date: date ?? this.date,
        executor: executor ?? this.executor,
      );
}
