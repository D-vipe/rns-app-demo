import 'package:hive/hive.dart';

part 'user_settings_model.g.dart';

@HiveType(typeId: 2)
class UserPortalSettings extends HiveObject {
  @HiveField(0)
  final bool taskSortonAddOrder;
  @HiveField(1)
  final bool taskNewSortOnAddInSystem;
  @HiveField(2)
  final bool taskReestrPaging;
  @HiveField(3)
  final bool timesheetPaging;
  // final bool defaultCardViewForTasks;
  @HiveField(4)
  final bool timesheetExecutorNotSelected;
  @HiveField(5)
  final bool autoSortTimesheet;
  @HiveField(6)
  final bool viewAllProjects;
  @HiveField(7)
  final String countDaysDefaultInMessageFilter;
  @HiveField(8)
  final String countDaysDefaultInEmailFilter;
  @HiveField(9)
  final String taskNotifyOverdraftHours;
  @HiveField(10)
  final String candidateDefaultSorting;
  @HiveField(11)
  final bool taskNotifyOverdraftDistinctByEmployee;
  @HiveField(12)
  final bool taskStatusChangeOnTimerStart;
  @HiveField(13)
  final bool taskFilterDefaultWithoutExecutor;

  UserPortalSettings({
    required this.taskSortonAddOrder,
    required this.taskNewSortOnAddInSystem,
    required this.taskReestrPaging,
    required this.timesheetPaging,
    required this.timesheetExecutorNotSelected,
    required this.autoSortTimesheet,
    required this.viewAllProjects,
    required this.countDaysDefaultInMessageFilter,
    required this.countDaysDefaultInEmailFilter,
    required this.taskNotifyOverdraftHours,
    required this.candidateDefaultSorting,
    required this.taskNotifyOverdraftDistinctByEmployee,
    required this.taskStatusChangeOnTimerStart,
    required this.taskFilterDefaultWithoutExecutor,
  });

}
