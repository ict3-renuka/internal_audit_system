import 'package:flutter/material.dart';
import 'package:project_one/data/models/department_model.dart';
import 'package:project_one/data/services/api_services/company_api.dart';
import 'package:project_one/data/services/api_services/department_api.dart';

import '../../../../data/models/company_model.dart';

class AddDepartmentViewmodel extends ChangeNotifier {

  final CompanyApi companyApi;
  final DepartmentApi departmentApi;

  AddDepartmentViewmodel(this.companyApi, this.departmentApi);

  final TextEditingController departmentController = TextEditingController();

  CompanyModel? selectedCompany;

  bool isLoading = false;
  bool isSaving = false;
  bool isDuplicate = false;

  List<CompanyModel> companyList = [];
  List<DepartmentModel> departmentList = [];

  void setCompany(CompanyModel? value) {
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

  Future<bool> addDepartment() async {

    if (selectedCompany == null ||
        departmentController.text.trim().isEmpty) {
      return false;
    }

    try{
      isSaving = true;
      notifyListeners();

      final newDepartmentName = departmentController.text.trim().toLowerCase();

      isDuplicate = departmentList.any((c) =>
      c.departmentName.trim().toLowerCase() == newDepartmentName &&
          c.companyId == selectedCompany!.companyId!);

      if (isDuplicate) {
        return false;
      }

      DepartmentModel department = DepartmentModel(
        companyId: selectedCompany!.companyId!,
        departmentName: departmentController.text,
      );

      await departmentApi.addDepartment(department);

      departmentController.clear();
      selectedCompany = null;

      await loadData();

      return true;
    }catch (e){
      print("ViewModel Error: $e");
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}