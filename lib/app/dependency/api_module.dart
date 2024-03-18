import 'package:dio/dio.dart';
import 'package:rns_app/app/features/authentication/data/services/auth_service.dart';
import 'package:rns_app/app/features/email/data/email_service.dart';
import 'package:rns_app/app/features/employee/data/employee_service.dart';
import 'package:rns_app/app/features/general/data/files_service.dart';
import 'package:rns_app/app/features/home/data/services/home_service.dart';
import 'package:rns_app/app/features/news/data/services/news_service.dart';
import 'package:rns_app/app/features/tasks/data/tasks_service.dart';
import 'package:rns_app/app/features/timesheets/data/timesheet_service.dart';
import 'package:rns_app/configs/data/dio_settings.dart';

class ApiModule {
  static Dio? dio;

  static AuthService authService() {
    dio ??= DioSettings.createDio();
    return AuthService(dio!);
  }

  static HomeService homeService() {
    dio ??= DioSettings.createDio();
    return HomeService(dio!);
  }

  static NewsService newsService() {
    dio ??= DioSettings.createDio();
    return NewsService(dio!);
  }

  static TimesheetsService timesheetService() {
    dio ??= DioSettings.createDio();
    return TimesheetsService(dio!);
  }

  static TasksService tasksService() {
    dio ??= DioSettings.createDio();
    return TasksService(dio!);
  }

  static EmailService emailService() {
    dio ??= DioSettings.createDio();
    return EmailService(dio!);
  }

  static FilesService filesService() {
    dio ??= DioSettings.createDio();
    return FilesService(dio!);
  }

  static EmployeeService employeeService() {
    dio ??= DioSettings.createDio();
    return EmployeeService(dio!);
  }
}
