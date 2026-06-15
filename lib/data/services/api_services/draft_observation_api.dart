import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_one/data/models/draft_observation_model.dart';

import '../../../core/constant/api_constant.dart';

class DraftObservationApi {

  Future<int> addDraftObservation(DraftObservationModel draftObservation) async {
    try {
      final url = Uri.parse("${ApiConstant.baseUrl}/DraftObservation");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(draftObservation.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["observation_id"];
      } else {
        throw Exception("API Failed");
      }

    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<void> updateDraftObservation(int id, DraftObservationModel observation) async {
    try {
      final url = Uri.parse("${ApiConstant.baseUrl}/DraftObservation/$id");
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(observation.toJson()),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception("Update failed: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
