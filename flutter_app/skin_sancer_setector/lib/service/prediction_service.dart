import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../model/prediction_response.dart';


class PredictionService {
  Future<PredictionResponse> predictImage(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(AppConfig.predictEndpoint),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode == 200) {
      final jsonMap = jsonDecode(responseBody);
      return PredictionResponse.fromJson(jsonMap);
    } else {
      throw Exception(
        'Prediction failed: ${streamedResponse.statusCode}\n$responseBody',
      );
    }
  }
}