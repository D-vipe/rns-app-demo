import 'package:rns_app/app/features/general/data/dto/select_object_dto.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';

class SelectObjectConverter {
  static SelectObject mapDTO(SelectObjectDTO data) =>
      SelectObject(id: data.id, title: data.title, isChecked: data.isChecked);
}
