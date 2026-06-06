class DepartmentModel {
  final int? departmentId;
  final int companyId;
  final String departmentName;

  DepartmentModel({
    this.departmentId,
    required this.companyId,
    required this.departmentName,
  });

  Map<String, dynamic> toJson() {
    return {
      "company_id": companyId,
      "department_name": departmentName,
    };
  }
}