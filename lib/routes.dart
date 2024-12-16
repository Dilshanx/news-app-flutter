import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/screens/article_detail_screen.dart';
import 'package:news_app/screens/favorites_screen.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/screens/search_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/article-detail':
        if (args is Article) {
          return MaterialPageRoute(
            builder: (_) => const ArticleDetailScreen(),
            settings: settings,
          );
        }
        return _errorRoute();
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case '/favorites':
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
