import 'package:rns_app/app/features/employee/data/dto/employee_list_item_dto.dart';
import 'package:rns_app/app/features/employee/domain/model/employee_list_item.dart';

class EmployeeListItemConverter {
  static EmployeeListItem mapDTO(EmployeeListItemDTO data) => EmployeeListItem(
        id: data.id,
        title: data.title,
        isAllowWriteMessage: data.isAllowWriteMessage ?? false,
        isAllowWriteEmail: data.isAllowWriteEmail ?? false,
        userId: data.userId,
        email: data.email,
        phones: data.phones,
        timeWith: _getPostionOrTimeWith(data.subTitle),
        position: _getPostionOrTimeWith(data.subTitle, position: true),
        urlLeftIcon: data.urlLeftIcon,
        isVisibleLeftIcon: data.isVisibleLeftIcon ?? false,
        urlRightIcon: data.urlRightIcon,
        isVisibleRightIcon: data.isVisibleRightIcon ?? false,
      );
}

String? _getPostionOrTimeWith(String? subTitle, {bool? position = false}) {
  if (subTitle != null) {
    final List<String> stringArr = subTitle.split('\r\n');
    if (stringArr.length > 1) {
      return position == true ? stringArr[1] : stringArr[0];
    } else {
      if (stringArr.isNotEmpty) {
        return position == true ? null : stringArr[0];
      } else {
        return null;
      }
    }
  } else {
    return null;
  }
}
