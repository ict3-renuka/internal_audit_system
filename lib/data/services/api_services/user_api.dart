import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_one/data/models/user_model.dart';

import '../../../core/constant/api_constant.dart';
import '../../models/responsible_user_model.dart';

class UserApi {
  Future<UserModel> login(String username, String password) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/User/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_name": username,
        "password": password
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UserModel.fromJson(data);
    } else {
      throw Exception(data["message"]);
    }
  }

  Future<List<ResponsibleUserModel>> getUsersByInternalDepartment(int internalDepartmentId) async {
    try {
      final url = Uri.parse("${ApiConstant.baseUrl}/User/by-internal-department/$internalDepartmentId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((json) => ResponsibleUserModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load users.");
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}