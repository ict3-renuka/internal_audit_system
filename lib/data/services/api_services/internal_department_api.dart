import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_one/data/models/internal_department_model.dart';

import '../../../core/constant/api_constant.dart';

class InternalDepartmentApi {

  Future<void> addInternalDepartment(InternalDepartmentModel internalDepartment) async {
    try {
      final url = Uri.parse("${ApiConstant.baseUrl}/InternalDepartment");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(internalDepartment.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception("API Failed");
      }

    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<List<InternalDepartmentModel>> getInternalDepartment() async {
    try{
      final url = Uri.parse("${ApiConstant.baseUrl}/InternalDepartment");
      final response = await http.get(url);

      if(response.statusCode == 200){
        List data = jsonDecode(response.body);
        return data.map((json) => InternalDepartmentModel.fromJson(json)).toList();
      }else{
        throw Exception("Failed to load internal departments.");
      }
    }catch (e){
      print("Error: $e");
      rethrow;
    }
  }
}