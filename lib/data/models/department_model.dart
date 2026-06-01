class DepartmentModel {
  final int internalDepartmentId;
  final int companyId;
  final String auditDepartmentName;
  final String internalDepartmentName;

  DepartmentModel({
    required this.internalDepartmentId,
    required this.companyId,
    required this.auditDepartmentName,
    required this.internalDepartmentName,
  });

  Map<String, dynamic> toJson() {
    return {
      "company_id": companyId,
      "audit_department_name": auditDepartmentName,
      "internal_department_name": internalDepartmentName,
    };
  }
}