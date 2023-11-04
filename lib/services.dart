import 'package:dio/dio.dart';
import 'package:pagenation_example/post_model.dart';

abstract class Services {
  static final Dio _dio = Dio()
    ..options.baseUrl = 'https://jsonplaceholder.typicode.com';
  static Future<List<PostModel>> getData({String? pageNumber}) async {
    var postsJson = await _dio.get('/posts?_page=$pageNumber');
    List<dynamic> postsList = postsJson.data;
    List<PostModel> posts = [];
    for (var post in postsList) {
      posts.add(PostModel.fromJson(post));
    }
    return posts;
  }
}
