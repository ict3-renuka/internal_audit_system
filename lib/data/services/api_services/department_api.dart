import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_one/data/models/department_model.dart';

import '../../../core/constant/api_constant.dart';

class DepartmentApi {

  Future<void> addDepartment(DepartmentModel department) async {

    try {
      final url = Uri.parse("${ApiConstant.baseUrl}/Department");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(department.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception("API Failed");
      }

    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<List<DepartmentModel>> getDepartment() async {

    try{
      final url = Uri.parse("${ApiConstant.baseUrl}/Department");
      final response = await http.get(url);

      if(response.statusCode == 200){
        List data = jsonDecode(response.body);
        return data.map((json) => DepartmentModel.fromJson(json)).toList();
      }else{
        throw Exception("Failed to load departments.");
      }
    }catch (e){
      print("Error: $e");
      rethrow;
    }
  }
}