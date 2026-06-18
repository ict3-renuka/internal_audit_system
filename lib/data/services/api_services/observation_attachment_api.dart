import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:typed_data';

import '../../../core/constant/api_constant.dart';
import 'package:web/web.dart' as html;

class ObservationAttachmentApi {

  Future<int> uploadPdf({
    required int observationId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    final uri = Uri.parse("${ApiConstant.baseUrl}/ObservationAttachment/upload");

    final request = http.MultipartRequest("POST", uri);

    request.fields["observationId"] = observationId.toString();

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        bytes,
        filename: fileName,
      ),
    );

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception("Upload failed");
    }

    final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
    return decoded["attachment_id"] as int;
  }

  void openPdfInBrowser(int id) {
    final url =
        "${ApiConstant.baseUrl}/ObservationAttachment/download/by-observation/$id";

    html.window.open(url, "_blank");
  }

  Future<void> delete(int attachmentId) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/ObservationAttachment/$attachmentId",
    );

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to delete attachment");
    }
  }
}