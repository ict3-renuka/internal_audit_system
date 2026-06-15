class UserModel {
  final int userId;
  final String name;
  final String userName;
  final String designation;
  final String email;
  final int internalDepartmentId;
  final bool isActive;

  UserModel({
    required this.userId,
    required this.name,
    required this.userName,
    required this.designation,
    required this.email,
    required this.internalDepartmentId,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["user_id"],
      name: json["name"],
      userName: json["user_name"],
      designation: json["designation"],
      email: json["email"],
      internalDepartmentId: json["internal_department_id"],
      isActive: json["isActive"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "name": name,
      "user_name": userName,
      "designation": designation,
      "email": email,
      "internal_department_id": internalDepartmentId,
      "isActive": isActive,
    };
  }
}