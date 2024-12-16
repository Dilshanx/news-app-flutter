import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Defines sorting options for news articles display
enum SortCriteria {
  relevancy,
  popularity,
  date,
}

class NewsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Article> _articles = [];
  List<Article> get articles => _articles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SortCriteria _sortCriteria = SortCriteria.date;
  SortCriteria get sortCriteria => _sortCriteria;

  List<Article> _favoriteArticles = [];
  List<Article> get favoriteArticles => _favoriteArticles;

  // Initialize provider and load saved favorites from local storage
  NewsProvider() {
    loadFavorites();
  }

  void setSortCriteria(SortCriteria criteria) {
    _sortCriteria = criteria;
    notifyListeners();
  }

  // Sort articles by date (API handles relevancy and popularity sorting)
  void _sortArticles() {
    switch (_sortCriteria) {
      case SortCriteria.date:
        _articles.sort((a, b) {
          if (a.publishedAt == null && b.publishedAt == null) return 0;
          if (a.publishedAt == null) return 1;
          if (b.publishedAt == null) return -1;
          return DateTime.parse(b.publishedAt!)
              .compareTo(DateTime.parse(a.publishedAt!));
        });
        break;
      case SortCriteria.relevancy:
        // For search results, sorting by relevancy will be handled by the API
        break;
      case SortCriteria.popularity:
        // For top headlines, sorting by popularity will be handled by the API
        break;
    }
  }

  // Fetch top headlines with optional category filter and refresh flag
  Future<void> getTopHeadlines(
      {String category = 'general', bool refresh = false}) async {
    _isLoading = true;
    if (!refresh) notifyListeners();

    _articles = await _apiService.getTopHeadlines(
      category: category,
      sortCriteria: _sortCriteria,
    );

    _sortArticles();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchNews(String query, {bool refresh = false}) async {
    _isLoading = true;
    if (!refresh) notifyListeners();

    _articles =
        await _apiService.searchNews(query, sortCriteria: _sortCriteria);

    _sortArticles();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteArticlesList = prefs.getStringList('favorites') ?? [];

    _favoriteArticles = favoriteArticlesList
        .map((articleJson) => Article.fromMap(jsonDecode(articleJson)))
        .toList();

    notifyListeners();
  }

  Future<void> toggleFavorite(Article article) async {
    final index = _favoriteArticles
        .indexWhere((element) => element.title == article.title);

    if (index >= 0) {
      _favoriteArticles.removeAt(index);
    } else {
      _favoriteArticles.add(article);
    }

    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(Article article) {
    return _favoriteArticles.any((element) => element.title == article.title);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteArticlesList = _favoriteArticles
        .map((article) => jsonEncode(article.toMap()))
        .toList();

    await prefs.setStringList('favorites', favoriteArticlesList);
  }
}
