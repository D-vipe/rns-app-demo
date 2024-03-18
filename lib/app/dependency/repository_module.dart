import 'package:rns_app/app/features/authentication/domain/auth_repository.dart';
import 'package:rns_app/app/features/email/domain/email_repository.dart';
import 'package:rns_app/app/features/employee/domain/employee_repository.dart';
import 'package:rns_app/app/features/general/domain/files_repository.dart';
import 'package:rns_app/app/features/home/domain/home_repository.dart';
import 'package:rns_app/app/features/tasks/domain/tasks_repository.dart';
import 'package:rns_app/app/features/timesheets/domain/ts_repository.dart';

class RepositoryModule {
  static AuthRepository? _authRepository;
  static HomeRepository? _homeRepository;
  static TimesheetsRepository? _tsRepository;
  static TasksRepository? _tasksRepository;
  static EmailRepository? _emailRepository;
  static FilesRepository? _filesRepository;
  static EmployeeRepository? _employeeRepository;

  static AuthRepository authRepository() {
    _authRepository ??= AuthRepository();
    return _authRepository!;
  }

  static HomeRepository homeRepository() {
    _homeRepository ??= HomeRepository();
    return _homeRepository!;
  }

  static TimesheetsRepository tsRepository() {
    _tsRepository ??= TimesheetsRepository();
    return _tsRepository!;
  }

  static TasksRepository tasksRepository() {
    _tasksRepository ??= TasksRepository();
    return _tasksRepository!;
  }

  static EmailRepository emailRepository() {
    _emailRepository ??= EmailRepository();
    return _emailRepository!;
  }

  static FilesRepository filesRepository() {
    _filesRepository ??= FilesRepository();
    return _filesRepository!;
  }

  static EmployeeRepository employeeRepository() {
    _employeeRepository ??= EmployeeRepository();
    return _employeeRepository!;
  }
}
