import 'package:rns_app/app/dependency/api_module.dart';
import 'package:rns_app/app/features/employee/data/converters/employee_list_item_converter.dart';
import 'package:rns_app/app/features/employee/domain/model/employee_list_filter.dart';
import 'package:rns_app/app/features/employee/domain/model/employee_list_item.dart';

class EmployeeRepository {
  final _service = ApiModule.employeeService();

  Future<List<EmployeeListItem>> getEmployees({int page = 1, int limit = 25, required String? fio}) async {
    List<EmployeeListItem> result = [];
    try {
      final EmployeeListFilter query = EmployeeListFilter(numPage: page, pageSize: limit, fio: fio);
      final dtoData = await _service.getEmployees(query: query.toJson());

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => EmployeeListItemConverter.mapDTO(data)).toList().cast<EmployeeListItem>();
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }
}
