import 'dart:convert';

import 'package:http/http.dart';
import 'package:todo_firbase_test/models/news_model.dart';

class ApiService {
  final all_news_url =
      "https://newsapi.org/v2/everything?q=bitcoin&apiKey=b73e702f8b864f2d9f89d6ca61b44a04";

  final breaking_news_url =
      "https://newsapi.org/v2/top-headlines?country=us&apiKey=b73e702f8b864f2d9f89d6ca61b44a04";

  Future<List<NewsModel>> getAllNews
  () async {
    try {
      Response response = await get(Uri.parse(all_news_url));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json["articles"];
        List<NewsModel> articles =
            body.map((item) => NewsModel.fromJson(item)).toList();
        return articles;
      } else {
        throw ('Nothing Found');
      }
    } catch (e) { 
      rethrow;
    }
  }



  Future<List<NewsModel>> getBreakingNews
  () async {
    try {
      Response response = await get(Uri.parse(all_news_url));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json["articles"];
        List<NewsModel> articles =
            body.map((item) => NewsModel.fromJson(item)).toList();
        return articles;
      } else {
        throw ('Nothing Found');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }



}
