import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constant/api_constant.dart';
import '../../models/observation_details_model.dart';

class ObservationDetailsApi {

  Future<int> addObservationDetails(ObservationDetailsModel model) async {
    try {
      final url = Uri.parse("${ApiConstant.baseUrl}/ObservationDetails");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(model.toAddJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["observation_details_id"];
      } else {
        throw Exception("Failed to add observation details: ${response.body}");
      }
    } catch (e){
      print(e);
      rethrow;
    }
  }

  Future<void> updateObservationDetails(int id, Map<String, dynamic> fields) async {
    try {
      final url = Uri.parse("${ApiConstant.baseUrl}/ObservationDetails/$id");

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(fields),
      );

      if (response.statusCode != 200) {
        throw Exception(
            "Failed to update observation details: ${response.body}");
      }
    } catch (e){
      print(e);
      rethrow;
    }
  }

  Future<List<int>> getSavedInternalDepartmentIds(int observationId) async {
    try {
      final url = Uri.parse("${ApiConstant
          .baseUrl}/ObservationDetails/byObservation/$observationId");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map<int>((e) => e as int).toList();
      } else {
        throw Exception("API Failed");
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}