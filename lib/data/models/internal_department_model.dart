class InternalDepartmentModel {
  final int? internalDepartmentId;
  final int departmentId;
  final String internalDepartmentName;

  InternalDepartmentModel({
    this.internalDepartmentId,
    required this.departmentId,
    required this.internalDepartmentName,
  });

  Map<String, dynamic> toJson() {
    return {
      "department_id": departmentId,
      "internal_department_name": internalDepartmentName,
    };
  }
}