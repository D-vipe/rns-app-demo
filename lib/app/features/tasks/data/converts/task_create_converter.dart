import 'package:rns_app/app/features/tasks/data/dto/task_create_dto.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_create.dart';

class TaskCreateConverter {
  static TaskCreate mapDTO(TaskCreateDTO data) => TaskCreate(
        id: data.id,
        projectId: data.projectId,
        taskTypeId: data.taskTypeId,
        urgencyId: data.urgencyId,
        taskLifecycleId: data.taskLifecycleId,
        isError: data.isError,
        isPriopritet: data.isPriopritet,
        initTypeId: data.initTypeId,
        curatorId: data.curatorId,
        initiatorId: data.initiatorId,
        executorId: data.executorId,
        moduleId: data.moduleId,
        taskSPId: data.taskSPId,
        projectStageId: data.projectStageId,
        versionId: data.versionId,
        plannedDate: data.plannedDate,
        planTime: data.planTime,
        plannedTimeDevelop: data.plannedTimeDevelop,
        plannedTimeTest: data.plannedTimeTest,
        dopExecutors: data.dopExecutors,
        dopFields: data.dopFields,
      );
}
