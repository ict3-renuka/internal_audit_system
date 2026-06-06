import 'package:project_one/data/models/internal_department_model.dart';

class InternalDepartmentApi {

  Future<void> addInternalDepartment(InternalDepartmentModel internalDepartment) async {

    print(internalDepartment.toJson());

    await Future.delayed(
      const Duration(seconds: 1),
    );
  }

  Future<List<InternalDepartmentModel>> getInternalDepartment() async {

    await Future.delayed(const Duration(seconds: 1));

    return [
      InternalDepartmentModel(internalDepartmentId: 1,departmentId: 1, internalDepartmentName: "Production Department One"),
      InternalDepartmentModel(internalDepartmentId: 2,departmentId: 1, internalDepartmentName: "Production Department Two"),
    ];
  }
}