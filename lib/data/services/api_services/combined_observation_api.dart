import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constant/api_constant.dart';
import '../../models/combined_observation_model.dart';

class CombinedObservationApi {
  Future<PaginatedResult<CombinedObservationModel>> getCombined({int page = 1, int pageSize = 10,}) async {
   try {
     final url = Uri.parse(
       "${ApiConstant
           .baseUrl}/ObservationDetails/combined?page=$page&pageSize=$pageSize",
     );

     final response = await http.get(url);

     if (response.statusCode == 200) {
       final json = jsonDecode(response.body);
       return PaginatedResult(
         totalCount: json['total_count'],
         page: json['page'],
         pageSize: json['page_size'],
         totalPages: json['total_pages'],
         items: (json['items'] as List)
             .map((e) => CombinedObservationModel.fromJson(e))
             .toList(),
       );
     } else {
       throw Exception("Failed to load observations");
     }
   } catch(e) {
     print(e);
     rethrow;
   }
  }
}