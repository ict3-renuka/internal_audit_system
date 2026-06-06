import 'package:flutter/material.dart';
import 'package:project_one/data/models/department_model.dart';
import 'package:project_one/data/models/internal_department_model.dart';
import 'package:project_one/data/services/api_services/department_api.dart';
import 'package:project_one/data/services/api_services/internal_department_api.dart';

class AddInternalDepartmentViewmodel extends ChangeNotifier {

  final DepartmentApi departmentApi;
  final InternalDepartmentApi internalDepartmentApi;

  AddInternalDepartmentViewmodel(this.departmentApi, this.internalDepartmentApi);

  final TextEditingController internalDepartmentController = TextEditingController();

  String? selectedDepartment;

  bool isLoading = false;

  List<DepartmentModel> departmentList = [];
  List<InternalDepartmentModel> internalDepartmentList = [];

  void setDepartment(String? value) {
    selectedDepartment = value;
    notifyListeners();
  }

  Future<void> loadData() async {

    isLoading = true;
    notifyListeners();

    departmentList = await departmentApi.getDepartment();
    internalDepartmentList = await internalDepartmentApi.getInternalDepartment();

    isLoading = false;
    notifyListeners();
  }

  String getCompanyName(int id) {
    return departmentList
        .firstWhere(
          (e) => e.departmentId == id,
      orElse: () => DepartmentModel(
          companyId: 0,
          departmentId: 1,
          departmentName: ""
      ),
    )
        .departmentName;
  }

  Future<void> addInternalDepartment() async {

    if (selectedDepartment == null ||
        internalDepartmentController.text.trim().isEmpty) {
      return;
    }

    isLoading = true;
    notifyListeners();

    int departmentId = selectedDepartment == "Production" ? 1 : 2;

    InternalDepartmentModel internalDepartmentModel = InternalDepartmentModel(
      departmentId: departmentId,
      internalDepartmentName: internalDepartmentController.text,
    );

    await internalDepartmentApi.addInternalDepartment(internalDepartmentModel);
    internalDepartmentList = await internalDepartmentApi.getInternalDepartment();

    internalDepartmentController.clear();
    selectedDepartment = null;

    isLoading = false;
    notifyListeners();
  }
}