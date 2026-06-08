class InternalDepartmentModel {
  final int? internalDepartmentId;
  final int departmentId;
  final String internalDepartmentName;

  InternalDepartmentModel({
    this.internalDepartmentId,
    required this.departmentId,
    required this.internalDepartmentName,
  });

  factory InternalDepartmentModel.fromJson(Map<String, dynamic> json) {
    return InternalDepartmentModel(
      internalDepartmentId: json["internal_department_id"],
      departmentId: json["department_id"],
      internalDepartmentName: json["internal_department_name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "department_id": departmentId,
      "internal_department_name": internalDepartmentName,
    };
  }
}