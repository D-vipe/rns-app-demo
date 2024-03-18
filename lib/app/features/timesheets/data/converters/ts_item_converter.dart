import 'package:rns_app/app/features/timesheets/data/dto/ts_item_dto.dart';
import 'package:rns_app/app/features/timesheets/domain/models/ts_item_model.dart';

class TsItemConverter {
  static TsItem mapDTO(TsItemDTO data) => TsItem(
        id: data.id,
        timeDuration: data.timeDuration ?? 0,
        taskName: data.taskName ?? ' - ',
        projectTitle: data.projectTitle ?? ' - ',
        description: data.description ?? ' - ',
        workTypeName: data.workTypeName ?? ' - ',
        timeGap: data.timeGap ?? ' - ',
        dateCreate: data.dateCreate != null ? DateTime.parse(data.dateCreate!) : DateTime.now(),
        overlapping: false,
      );
}
