import 'dart:convert';

import '../../../core/constant/api_constant.dart';
import '../../models/company_model.dart';
import 'package:http/http.dart' as http;

class CompanyApi {

  Future<void> addCompany(CompanyModel company) async {
    try {
      final url = Uri.parse("${ApiConstant.baseUrl}/Company");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(company.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception("API Failed");
      }

    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<List<CompanyModel>> getCompanyList() async {
    try{
      final url = Uri.parse("${ApiConstant.baseUrl}/Company");
      final response = await http.get(url);

      if(response.statusCode == 200){
        List data = jsonDecode(response.body);
        return data.map((json) => CompanyModel.fromJson(json)).toList();
      }else{
        throw Exception("Failed to load companies.");
      }
    }catch (e){
      print("Error: $e");
      rethrow;
    }
  }
}