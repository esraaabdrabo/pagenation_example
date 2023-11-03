import 'package:dio/dio.dart';
import 'package:pagenation_example/post_model.dart';

abstract class Services {
  final Dio _dio = Dio()
    ..options.baseUrl = 'https://jsonplaceholder.typicode.com';
  Future<List<PostModel>> getData({String? pageNumber}) async {
    var postsJson = await _dio.get('/posts?_page=$pageNumber');
    List<Map<String, dynamic>> postsList = postsJson.data;
    List<PostModel> posts = [];
    for (var post in postsList) {
      PostModel.fromJson(post);
    }
    return posts;
  }
}
