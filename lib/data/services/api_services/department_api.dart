import 'package:project_one/data/models/department_model.dart';

class DepartmentApi {

  Future<void> addDepartment(DepartmentModel department) async {

    print(department.toJson());

    await Future.delayed(
      const Duration(seconds: 1),
    );
  }

  Future<List<DepartmentModel>> getDepartment() async {

    await Future.delayed(const Duration(seconds: 1));

    return [
      DepartmentModel(departmentId: 1,companyId: 1, departmentName: "Production"),
      DepartmentModel(departmentId: 2, companyId: 1, departmentName: "Production"),
    ];
  }
}