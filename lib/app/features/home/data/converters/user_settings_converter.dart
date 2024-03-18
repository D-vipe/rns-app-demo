import 'package:rns_app/app/features/home/data/dto/user_settings_dto.dart';
import 'package:rns_app/app/features/home/domain/models/user_settings_model.dart';

class UserSettingsConverter {
  static UserPortalSettings mapDTO(UserSettingsDTO data) => UserPortalSettings(
        taskSortonAddOrder: data.taskSortonAddOrder,
        taskNewSortOnAddInSystem: data.taskNewSortOnAddInSystem,
        taskReestrPaging: data.taskReestrPaging,
        timesheetPaging: data.timesheetPaging,
        timesheetExecutorNotSelected: data.timesheetExecutorNotSelected,
        autoSortTimesheet: data.autoSortTimesheet,
        viewAllProjects: data.viewAllProjects,
        countDaysDefaultInMessageFilter: data.countDaysDefaultInMessageFilter,
        countDaysDefaultInEmailFilter: data.countDaysDefaultInEmailFilter,
        taskNotifyOverdraftHours: data.taskNotifyOverdraftHours,
        candidateDefaultSorting: data.candidateDefaultSorting,
        taskNotifyOverdraftDistinctByEmployee: data.taskNotifyOverdraftDistinctByEmployee,
        taskStatusChangeOnTimerStart: data.taskStatusChangeOnTimerStart,
        taskFilterDefaultWithoutExecutor: data.taskFilterDefaultWithoutExecutor,
      );
}
