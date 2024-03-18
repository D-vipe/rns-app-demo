import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/bindings/email_create_bindings.dart';
import 'package:rns_app/app/features/email/presentation/bindings/email_detail_bindings.dart';
import 'package:rns_app/app/features/email/presentation/bindings/email_filter_bindings.dart';
import 'package:rns_app/app/features/email/presentation/bindings/email_list_bindings.dart';
import 'package:rns_app/app/features/email/presentation/bindings/email_core_bindings.dart';
import 'package:rns_app/app/features/email/presentation/views/create/email_create_view.dart';
import 'package:rns_app/app/features/email/presentation/views/detail/email_detail_view.dart';
import 'package:rns_app/app/features/email/presentation/views/filter/email_filter_view.dart';
import 'package:rns_app/app/features/email/presentation/views/list/email_list_view.dart';
import 'package:rns_app/app/features/email/presentation/views/mail_routing_page.dart';
import 'package:rns_app/app/features/employee/presentation/bindings/employee_bindings.dart';
import 'package:rns_app/app/features/employee/presentation/bindings/employee_filter_bindings.dart';
import 'package:rns_app/app/features/employee/presentation/bindings/employee_list_bindings.dart';
import 'package:rns_app/app/features/employee/presentation/views/detail/employee_detail_view.dart';
import 'package:rns_app/app/features/employee/presentation/views/employee_routing_page.dart';
import 'package:rns_app/app/features/employee/presentation/views/filter/employee_filter_view.dart';
import 'package:rns_app/app/features/employee/presentation/views/list/employee_list_view.dart';
import 'package:rns_app/app/features/home/presentation/bindings/home_logic_binding.dart';
import 'package:rns_app/app/features/home/presentation/bindings/root_binding.dart';
import 'package:rns_app/app/features/home/presentation/views/root_view.dart';
import 'package:rns_app/app/features/authentication/presentation/bindings/auth_binding.dart';
import 'package:rns_app/app/features/authentication/presentation/views/auth_view.dart';
import 'package:rns_app/app/features/home/presentation/bindings/home_binding.dart';
import 'package:rns_app/app/features/home/presentation/views/home_routing_page.dart';
import 'package:rns_app/app/features/home/presentation/views/home_view.dart';
import 'package:rns_app/app/features/news/presentation/bindings/news_binding.dart';
import 'package:rns_app/app/features/news/presentation/views/news_detailed_view.dart';
import 'package:rns_app/app/features/news/presentation/views/news_list_view.dart';
import 'package:rns_app/app/features/tasks/presentation/bindings/create_task_bindings.dart';
import 'package:rns_app/app/features/tasks/presentation/bindings/tasks_children_bindings.dart';
import 'package:rns_app/app/features/tasks/presentation/bindings/tasks_core_bindings.dart';
import 'package:rns_app/app/features/tasks/presentation/views/create/tasks_create_view.dart';
import 'package:rns_app/app/features/tasks/presentation/views/detail/tasks_detail_view.dart';
import 'package:rns_app/app/features/tasks/presentation/views/filter/tasks_filter_view.dart';
import 'package:rns_app/app/features/tasks/presentation/views/list/tasks_list_view.dart';
import 'package:rns_app/app/features/tasks/presentation/views/tasks_routing_page.dart';
import 'package:rns_app/app/features/timesheets/presentation/bindings/timesheets_bindings.dart';
import 'package:rns_app/app/features/timesheets/presentation/bindings/ts_children_bindings.dart';
import 'package:rns_app/app/features/timesheets/presentation/bindings/ts_filter_binding.dart';
import 'package:rns_app/app/features/timesheets/presentation/views/filter/timesheets_filter_view.dart';
import 'package:rns_app/app/features/timesheets/presentation/views/list/timesheets_list_view.dart';
import 'package:rns_app/app/features/timesheets/presentation/views/new/timesheets_create_view.dart';
import 'package:rns_app/app/features/timesheets/presentation/views/timesheets_routing_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ROOT;

  static final routes = [
    GetPage(
      name: _Paths.ROOT,
      page: () => const RootView(),
      preventDuplicates: true,
      binding: RootBinding(),
      children: [
        GetPage(
          name: _Paths.AUTH,
          binding: AuthBinding(),
          transition: Transition.fadeIn,
          page: () => const AuthView(),
        ),
        GetPage(
          name: _Paths.DASHBOARD,
          binding: HomeBinding(),
          transition: Transition.fadeIn,
          page: () => const HomeRoutingPage(),
          children: [
            GetPage(
              binding: HomeLogicBinding(),
              name: _Paths.HOME,
              transition: Transition.fadeIn,
              page: () => const HomeView(),
            ),
            GetPage(
              name: _Paths.TIMESHEETS,
              binding: TimeSheetsBinding(),
              page: () => const TimesheetsRoutingPage(),
              transition: Transition.fadeIn,
              children: [
                GetPage(
                  name: _Paths.LIST,
                  binding: TsChildrenBinding(),
                  page: () => const TimesheetsListView(),
                  transition: Transition.fadeIn,
                ),
                GetPage(
                  name: _Paths.CREATE,
                  page: () => const TimesheetsCreateView(),
                  transition: Transition.fadeIn,
                ),
                GetPage(
                  name: _Paths.FILTERS,
                  binding: TSFilterBinding(),
                  page: () => const TimesheetsFilterView(),
                  transition: Transition.fadeIn,
                ),
              ],
            ),
            GetPage(
              name: _Paths.NEWS,
              binding: NewsBinding(),
              page: () => const NewsListView(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: _Paths.NEWS_DETAILED,
              binding: NewsBinding(),
              page: () => const NewsDetailedView(),
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: _Paths.TASKS,
              binding: TasksCoreBinding(),
              page: () => const TasksRoutingPage(),
              transition: Transition.fadeIn,
              children: [
                GetPage(
                  name: _Paths.LIST,
                  binding: TasksChildrenBinding(),
                  page: () => const TasksListView(),
                  transition: Transition.fadeIn,
                ),
                GetPage(
                  name: _Paths.CREATE,
                  page: () => const TasksCreateView(),
                  binding: TaskFormTabBinding(),
                  transition: Transition.fadeIn,
                ),
                GetPage(
                  name: _Paths.FILTERS,
                  page: () => const TasksFilterView(),
                  transition: Transition.native,
                ),
                GetPage(
                  name: _Paths.DETAIL,
                  page: () => const TasksDetailView(),
                  transition: Transition.native,
                ),
              ],
            ),
            GetPage(
              name: _Paths.EMAIL,
              binding: EmailCoreBinding(),
              page: () => const EmailRoutingPage(),
              transition: Transition.fadeIn,
              children: [
                GetPage(
                  name: _Paths.LIST,
                  binding: EmailListBinding(),
                  page: () => const EmailListView(),
                  transition: Transition.fadeIn,
                ),
                GetPage(
                  name: _Paths.CREATE,
                  binding: EmailCreateBinding(),
                  page: () => const EmailCreateView(),
                  transition: Transition.fadeIn,
                ),
                GetPage(
                  name: _Paths.FILTERS,
                  binding: EmailFilterBinding(),
                  page: () => const EmailFilterView(),
                  transition: Transition.native,
                ),
                GetPage(
                  name: _Paths.DETAIL,
                  binding: EmailDetailBinding(),
                  page: () => const EmailDetailView(),
                  transition: Transition.native,
                ),
              ],
            ),
            GetPage(
              name: _Paths.EMPLOYEE,
              binding: EmployeesBinding(),
              page: () => const EmployeeRoutingPage(),
              transition: Transition.fadeIn,
              children: [
                GetPage(
                  name: _Paths.LIST,
                  binding: EmployeeListBinding(),
                  page: () => const EmployeeListView(),
                  transition: Transition.fadeIn,
                ),
                GetPage(
                  name: _Paths.DETAIL,
                  page: () => const EmployeeDetailView(),
                  transition: Transition.fadeIn,
                ),
                GetPage(
                  name: _Paths.FILTERS,
                  binding: EmployeeFilterBinding(),
                  page: () => const EmployeeFilterView(),
                  transition: Transition.fadeIn,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];
}
