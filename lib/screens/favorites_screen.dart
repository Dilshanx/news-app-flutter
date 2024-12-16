import 'package:flutter/material.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/widgets/article_card.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Articles'), // Title of the screen
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          // Check if there are no favorite articles
          if (newsProvider.favoriteArticles.isEmpty) {
            return const Center(
              child: Text(
                  'You have no favorite articles yet.'), // Message when no favorites
            );
          } else {
            // Display a list of favorite articles
            return ListView.builder(
              itemCount: newsProvider
                  .favoriteArticles.length, // Total number of favorite articles
              itemBuilder: (context, index) {
                // Display each article using the ArticleCard widget
                return ArticleCard(
                    article: newsProvider.favoriteArticles[index]);
              },
            );
          }
        },
      ),
    );
  }
}
