class UserSettingsDTO {
  final bool taskSortonAddOrder;
  final bool taskNewSortOnAddInSystem;
  final bool taskReestrPaging;
  final bool timesheetPaging;
  final bool timesheetExecutorNotSelected;
  final bool autoSortTimesheet;
  final bool viewAllProjects;
  final String countDaysDefaultInMessageFilter;
  final String countDaysDefaultInEmailFilter;
  final String taskNotifyOverdraftHours;
  final String candidateDefaultSorting;
  final bool taskNotifyOverdraftDistinctByEmployee;
  final bool taskStatusChangeOnTimerStart;
  final bool taskFilterDefaultWithoutExecutor;

  UserSettingsDTO({
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

  factory UserSettingsDTO.fromJson(Map<String, dynamic> json) => UserSettingsDTO(
        taskSortonAddOrder: json['taskSortOnAddOrder'] ?? false,
        taskNewSortOnAddInSystem: json['taskNewSortOnAddInSystem'] ?? false,
        taskReestrPaging: json['taskReestrPaging'] ?? true,
        timesheetPaging: json['timesheetPaging'] ?? true,
        timesheetExecutorNotSelected: json['timesheetExecutorNotSelect'] ?? false,
        autoSortTimesheet: json['autoSortTimesheet'] ?? false,
        viewAllProjects: json['viewAllProjects'] ?? false,
        countDaysDefaultInMessageFilter: json['countDaysDefaultInMessageFilter'] ?? '',
        countDaysDefaultInEmailFilter: json['countDaysDefaultInEmailFilter'] ?? '',
        taskNotifyOverdraftHours: json['taskNotifyOverdraftHours'] ?? '',
        candidateDefaultSorting: json['candidateDefaultSorting'] ?? 'FIO ASC',
        taskNotifyOverdraftDistinctByEmployee: json['taskNotifyOverdraftDistinctByEmployee'] ?? false,
        taskStatusChangeOnTimerStart: json['taskStatusChangeOnTimerStart'] ?? false,
        taskFilterDefaultWithoutExecutor: json['taskFilterDefaultWithoutExecutor'] ?? false,
      );
}
