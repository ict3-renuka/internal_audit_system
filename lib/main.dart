import 'package:flutter/material.dart';
import 'package:project_one/data/services/api_services/audit_request_api.dart';
import 'package:project_one/data/services/api_services/center_api.dart';
import 'package:project_one/data/services/api_services/department_api.dart';
import 'package:project_one/data/services/api_services/draft_observation_api.dart';
import 'package:project_one/data/services/api_services/internal_department_api.dart';
import 'package:project_one/ui/views/audit_request/audit_request_view.dart';
import 'package:project_one/ui/views/audit_request/audit_request_view_model.dart';
import 'package:project_one/ui/views/audit_request/edit_audit_request_view.dart';
import 'package:project_one/ui/views/draft_observation/draft_observation_view.dart';
import 'package:project_one/ui/views/draft_observation/draft_observation_view_model.dart';
import 'package:project_one/ui/views/draft_observation/edit_draft_observation_view.dart';
import 'package:project_one/ui/views/master/add_center/add_center_view.dart';
import 'package:project_one/ui/views/master/add_center/add_center_viewmodel.dart';
import 'package:project_one/ui/views/master/add_department/add_department_view.dart';
import 'package:project_one/ui/views/master/add_department/add_department_viewmodel.dart';
import 'package:project_one/ui/views/master/add_internal_department/add_internal_department_view.dart';
import 'package:project_one/ui/views/master/add_internal_department/add_internal_department_viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:project_one/data/services/api_services/login_api.dart';
import 'package:project_one/data/services/api_services/company_api.dart';

import 'package:project_one/ui/views/login/login_view.dart';
import 'package:project_one/ui/views/login/login_viewmodel.dart';

import 'package:project_one/ui/views/home_page/home_page_view.dart';

import 'package:project_one/ui/views/master/add_company/add_company_view.dart';
import 'package:project_one/ui/views/master/add_company/add_company_viewmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final LoginApi loginApi = LoginApi();
  final CompanyApi companyApi = CompanyApi();
  final CenterApi centerApi = CenterApi();
  final AuditRequestApi auditRequestApi = AuditRequestApi();
  final DraftObservationApi draftObservationApi = DraftObservationApi();
  final DepartmentApi departmentApi = DepartmentApi();
  final InternalDepartmentApi internalDepartmentApi = InternalDepartmentApi();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewmodel(loginApi)),
        ChangeNotifierProvider(create: (_) => AddCompanyViewmodel(companyApi)),
        ChangeNotifierProvider(create: (_) => AddCenterViewmodel(centerApi,companyApi)),
        ChangeNotifierProvider(create: (_) => AddDepartmentViewmodel(companyApi,departmentApi)),
        ChangeNotifierProvider(create: (_) => AddInternalDepartmentViewmodel(departmentApi,internalDepartmentApi)),
        ChangeNotifierProvider(create: (_) => AuditRequestViewmodel(auditRequestApi)),
        ChangeNotifierProvider(create: (_) => DraftObservationViewmodel(draftObservationApi)),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/login",
        routes: {
          "/login": (_) => LoginView(),
          "/home": (_) => const HomeView(),
          "/add-company": (_) => const AddCompanyView(),
          "/add-center": (_) => const AddCenterView(),
          "/add-department": (_) => const AddDepartmentView(),
          "/add-internal-department": (_) => const AddInternalDepartmentView(),
          "/new-audit-request": (_) => const AuditRequestView(),
          "/edit-audit-request": (_) => const EditAuditRequestView(),
          "/new-draft-observation": (_) => const DraftObservationView(),
          "/edit-draft-observation": (_) => const EditDraftObservationView(),
        },
      ),
    );
  }
}
