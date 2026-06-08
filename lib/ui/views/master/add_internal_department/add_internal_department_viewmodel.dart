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

  DepartmentModel? selectedDepartment;

  bool isLoading = false;
  bool isSaving = false;

  List<DepartmentModel> departmentList = [];
  List<InternalDepartmentModel> internalDepartmentList = [];

  void setDepartment(DepartmentModel? value) {
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

  String getDepartmentName(int id) {
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

  Future<bool> addInternalDepartment() async {

    if (selectedDepartment == null ||
        internalDepartmentController.text.trim().isEmpty) {
      return false;
    }

    try{
      isSaving = true;
      notifyListeners();

      InternalDepartmentModel internalDepartmentModel = InternalDepartmentModel(
        departmentId: selectedDepartment!.departmentId!,
        internalDepartmentName: internalDepartmentController.text,
      );

      await internalDepartmentApi.addInternalDepartment(internalDepartmentModel);

      internalDepartmentController.clear();
      selectedDepartment = null;

      await loadData();

      return true;
    }catch (e) {
      print("ViewModel Error: $e");
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }

  }
}