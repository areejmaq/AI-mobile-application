import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:doctro/model/cancer_detection_model/cancer_model.dart';

final class CancerServiceRepo {
  final String baseUrl = "https://cancer-model-service.onrender.com";
  final Dio dio = Dio();

  Future<CancerModel> processImageFromUrl(String imageUrl) async {
    try {
      final imageResponse = await dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (imageResponse.statusCode != 200 || imageResponse.data == null) {
        throw "Failed to download image from URL.";
      }

      final Uint8List imageBytes = Uint8List.fromList(imageResponse.data!);
      final uri = Uri.parse(imageUrl);
      final fileName = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : "uploaded_image.jpg";

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          imageBytes,
          filename: fileName,
        ),
      });

      final response = await dio.post(
        '$baseUrl/predict',
        data: formData,
      );
      print(response.data);
      if (response.statusCode == 200) {
        return CancerModel.fromMap(response.data);
      } else {
        throw response.statusMessage ??
            "Sorry Doctor, AI could not help you at this time.";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

void main(List<String> args) async {
  final repo = CancerServiceRepo();
  print(await repo.processImageFromUrl(
      "https://dermsmartweb.misancompany.com/images/upload/defaultUser.png"));
}
