part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const ROOT = _Paths.ROOT;
  static const AUTH = _Paths.AUTH;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const HOME = _Paths.DASHBOARD + _Paths.HOME;
  static const TASKS = _Paths.DASHBOARD + _Paths.TASKS;
  static const TASKSLIST = _Paths.DASHBOARD + _Paths.TASKS + _Paths.LIST;
  static const TASKSCREATE = _Paths.DASHBOARD + _Paths.TASKS + _Paths.CREATE;
  static const TASKSFILTER = _Paths.DASHBOARD + _Paths.TASKS + _Paths.FILTERS;
  static const TASKSDETAIL = _Paths.DASHBOARD + _Paths.TASKS + _Paths.DETAIL;
  static const TS = _Paths.DASHBOARD + _Paths.TIMESHEETS;
  static const TSLIST = _Paths.DASHBOARD + _Paths.TIMESHEETS + _Paths.LIST;
  static const TSCREATE = _Paths.DASHBOARD + _Paths.TIMESHEETS + _Paths.CREATE;
  static const TSFILTER = _Paths.DASHBOARD + _Paths.TIMESHEETS + _Paths.FILTERS;
  static const EMAIL = _Paths.DASHBOARD + _Paths.EMAIL;
  static const NEWS = _Paths.DASHBOARD + _Paths.NEWS;
  static const NEWS_DETAILED = _Paths.DASHBOARD + _Paths.NEWS_DETAILED;
  static const EMAILIST = _Paths.DASHBOARD + _Paths.EMAIL + _Paths.LIST;
  static const EMAILCREATE = _Paths.DASHBOARD + _Paths.EMAIL + _Paths.CREATE;
  static const EMAILDETAIL = _Paths.DASHBOARD + _Paths.EMAIL + _Paths.DETAIL;
  static const EMAILFILTER = _Paths.DASHBOARD + _Paths.EMAIL + _Paths.FILTERS;
  static const EMPLOYEE = _Paths.DASHBOARD + _Paths.EMPLOYEE;
  static const EMPLOYEELIST = _Paths.DASHBOARD + _Paths.EMPLOYEE + _Paths.LIST;
  static const EMPLOYEEFILTER = _Paths.DASHBOARD + _Paths.EMPLOYEE + _Paths.FILTERS;
  static const EMPLOYEEDETAIL = _Paths.DASHBOARD + _Paths.EMPLOYEE + _Paths.DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const ROOT = '/';
  static const AUTH = '/auth';
  static const DASHBOARD = '/dashboard';
  static const HOME = '/home';
  static const TASKS = '/tasks';
  static const TIMESHEETS = '/timesheets';
  static const LIST = '/list';
  static const FILTERS = '/filters';
  static const CREATE = '/create';
  static const EMAIL = '/email';
  static const NEWS = '/news';
  static const NEWS_DETAILED = '/news_detailed';
  static const DETAIL = '/detail';
  static const EMPLOYEE = '/employee';
}
