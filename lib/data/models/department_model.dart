class DepartmentModel {
  final int? departmentId;
  final int companyId;
  final String departmentName;

  DepartmentModel({
    this.departmentId,
    required this.companyId,
    required this.departmentName,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentId: json["department_id"],
      companyId: json["company_id"],
      departmentName: json["department_name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "company_id": companyId,
      "department_name": departmentName,
    };
  }
}