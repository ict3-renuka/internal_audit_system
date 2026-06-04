import 'dart:convert';

import 'package:project_one/data/models/center_model.dart';

import '../../../core/constant/api_constant.dart';
import 'package:http/http.dart' as http;

class CenterApi {

  Future<void> addCenter(CenterModel center) async {
    try {
      final url = Uri.parse("${ApiConstant.baseUrl}/Center");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(center.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception("API Failed");
      }

    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<List<CenterModel>> getCenterList() async {
    try{
      final url = Uri.parse("${ApiConstant.baseUrl}/Center");
      final response = await http.get(url);

      if(response.statusCode == 200){
        List data = jsonDecode(response.body);
        return data.map((json) => CenterModel.fromJson(json)).toList();
      }else{
        throw Exception("Failed to load centers.");
      }
    }catch (e){
      print("Error: $e");
      rethrow;
    }
  }
}