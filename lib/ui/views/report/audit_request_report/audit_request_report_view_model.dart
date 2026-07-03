import 'package:flutter/cupertino.dart';

import '../../../../data/models/company_model.dart';
import '../../../../data/models/department_model.dart';
import '../../../../data/services/api_services/audit_request_report_api.dart';
import '../../../../data/services/api_services/company_api.dart';
import '../../../../data/services/api_services/department_api.dart';

class AuditRequestReportViewModel extends ChangeNotifier {

  final AuditRequestReportApi reportApi = AuditRequestReportApi();

  List<DepartmentModel> departments = [];
  List<CompanyModel> companies = [];

  DepartmentModel? selectedDepartment;
  CompanyModel? selectedCompany;

  String? selectedSector;
  String? selectedStatus;

  DateTime? fromDate;
  DateTime? toDate;

  bool isLoading=false;

  final sectorList = [
    "Agri",
    "FMCG",
  ];

  final statusList = [
    "Open",
    "Close",
  ];

  Future<void> init() async{

    departments =
    await DepartmentApi().getDepartment();

    companies =
    await CompanyApi().getCompanyList();

    notifyListeners();

  }

  void setSector(String? value){
    selectedSector=value;
    notifyListeners();
  }

  void setStatus(String? value){
    selectedStatus=value;
    notifyListeners();
  }

  void setDepartment(DepartmentModel value){
    selectedDepartment=value;
    notifyListeners();
  }

  void setCompany(CompanyModel value){
    selectedCompany=value;
    notifyListeners();
  }

  void setFromDate(DateTime value){
    fromDate=value;
    notifyListeners();
  }

  void setToDate(DateTime value){
    toDate=value;
    notifyListeners();
  }

  Future<void> generateReport() async{

    isLoading=true;
    notifyListeners();

    reportApi.openReportInBrowser(

      sector:selectedSector,
      companyId:selectedCompany?.companyId,
      departmentId:selectedDepartment?.departmentId,
      status:selectedStatus,
      fromDate:fromDate,
      toDate:toDate,

    );

    isLoading=false;
    notifyListeners();

  }

  void clearFilters(){

    selectedSector=null;
    selectedCompany=null;
    selectedDepartment=null;
    selectedStatus=null;
    fromDate=null;
    toDate=null;

    notifyListeners();

  }

}