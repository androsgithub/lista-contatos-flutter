import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ContatosDio {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: "https://parseapi.back4app.com/", headers: {
    'X-Parse-Application-Id': dotenv.get("PARSE_APLICATION_ID"),
    'X-Parse-REST-API-Key': dotenv.get("REST_API_KEY"),
    'Content-Type': 'application/json',
  }));

  Dio get dio => _dio;
}
