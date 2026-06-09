import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_one/data/models/user_model.dart';

import '../../../core/constant/api_constant.dart';

class LoginApi {
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
}