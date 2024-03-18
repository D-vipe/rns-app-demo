import 'package:intl/intl.dart';

class TimesheetFilters {
  final DateTime date;
  final int limit;
  final int page;
  final String executorId;

  TimesheetFilters({
    required this.date,
    required this.limit,
    required this.page,
    required this.executorId,
  });

  Map<String, dynamic> toJson() => {
        'filter.date': DateFormat('y-MM-dd', 'ru').format(date),
        'filter.pageSize': limit,
        'filter.numPage': page,
        'filter.executorId': executorId,
      };
}
