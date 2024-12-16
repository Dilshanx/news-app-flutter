import 'dart:convert'; // For JSON encoding and decoding

import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:news_app/models/article.dart'; // Importing the Article model
import 'package:news_app/providers/news_provider.dart'; // Importing the SortCriteria enum

class ApiService {
  final String _baseUrl = 'https://newsapi.org/v2';
  final String _apiKey = 'dda8fc7c7ba84dd8962b49a64ceb0fc2';

  // Fetches top headlines based on category and sorting criteria
  Future<List<Article>> getTopHeadlines(
      {String category = 'general', required SortCriteria sortCriteria}) async {
    String sortByQuery = '';

    if (sortCriteria == SortCriteria.popularity) {
      sortByQuery = '&sortBy=popularity';
    }

    final response = await http.get(Uri.parse(
        '$_baseUrl/top-headlines?country=us&category=$category$sortByQuery&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];
      return body.map((dynamic item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  // Searches news articles based on the query and sorting criteria
  Future<List<Article>> searchNews(String query,
      {required SortCriteria sortCriteria}) async {
    String sortByQuery = '';

    if (sortCriteria == SortCriteria.relevancy) {
      sortByQuery = '&sortBy=relevancy';
    } else if (sortCriteria == SortCriteria.popularity) {
      sortByQuery = '&sortBy=popularity';
    }

    final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$query$sortByQuery&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];
      return body.map((dynamic item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
