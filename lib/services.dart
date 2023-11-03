import 'package:dio/dio.dart';

abstract class Services {
  final Dio _dio = Dio()
    ..options.baseUrl = 'https://jsonplaceholder.typicode.com';
  getData({String? pageNumber}) async {
    await _dio.get('/posts?_page=$pageNumber');
  }
}
