class ResponsibleUserModel {
  final int? userId;
  final int internalDepartmentId;
  final String userName;

  ResponsibleUserModel({
    this.userId,
    required this.internalDepartmentId,
    required this.userName,
  });

  factory ResponsibleUserModel.fromJson(Map<String, dynamic> json) {
    return ResponsibleUserModel(
      userId: json["user_id"],
      internalDepartmentId: json["internal_department_id"],
      userName: json["name"],
    );
  }
}