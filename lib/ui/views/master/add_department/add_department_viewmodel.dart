import 'package:flutter/material.dart';
import 'package:project_one/data/models/center_model.dart';
import 'package:project_one/data/models/department_model.dart';
import 'package:project_one/data/services/api_services/center_api.dart';
import 'package:project_one/data/services/api_services/company_api.dart';
import 'package:project_one/data/services/api_services/department_api.dart';

import '../../../../data/models/company_model.dart';

class AddDepartmentViewmodel extends ChangeNotifier {

  final CompanyApi companyApi;
  final DepartmentApi departmentApi;

  AddDepartmentViewmodel(this.companyApi, this.departmentApi);

  final TextEditingController auditDepartmentController = TextEditingController();
  final TextEditingController internalDepartmentController = TextEditingController();

  String? selectedCompany;

  bool isLoading = false;

  List<CompanyModel> companyList = [];
  List<DepartmentModel> departmentList = [];

  void setCompany(String? value) {
    selectedCompany = value;
    notifyListeners();
  }

  Future<void> loadData() async {

    isLoading = true;
    notifyListeners();

    companyList = await companyApi.getCompanyList();
    departmentList = await departmentApi.getDepartment();

    isLoading = false;
    notifyListeners();
  }

  String getCompanyName(int id) {
    return companyList
        .firstWhere(
          (e) => e.companyId == id,
      orElse: () => CompanyModel(
          companyId: 0,
          sectorId: 1,
          sectorName: "",
          companyName: ""
      ),
    )
        .companyName;
  }

  Future<void> addDepartment() async {

    if (selectedCompany == null ||
        auditDepartmentController.text.trim().isEmpty ||
        internalDepartmentController.text.trim().isEmpty) {
      return;
    }

    isLoading = true;
    notifyListeners();

    int companyId = selectedCompany == "RDL" ? 1 : 2;

    DepartmentModel department = DepartmentModel(
      companyId: companyId,
      auditDepartmentName: auditDepartmentController.text,
      internalDepartmentName: internalDepartmentController.text,
    );

    await departmentApi.addDepartment(department);
    departmentList = await departmentApi.getDepartment();

    auditDepartmentController.clear();
    internalDepartmentController.clear();
    selectedCompany = null;

    isLoading = false;
    notifyListeners();
  }
}