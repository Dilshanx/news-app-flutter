import 'package:flutter/material.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/widgets/article_card.dart';
import 'package:news_app/widgets/error_message.dart';
import 'package:news_app/widgets/search_bar.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Search News'), // App bar with the title 'Search News'
      ),
      body: Column(
        children: [
          // Search bar where users can input a search query
          NewsSearchBar(
            onSearch: (query) {
              // If the search query is not empty, perform a search
              if (query.isNotEmpty) {
                Provider.of<NewsProvider>(context, listen: false)
                    .searchNews(query);
              }
            },
          ),

          // Sorting options dropdown
          Consumer<NewsProvider>(
            builder: (context, newsProvider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Sort by', // Title for the sorting section
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Dropdown for sorting the articles
                  DropdownButton<SortCriteria>(
                    value:
                        newsProvider.sortCriteria, // Current sorting criteria
                    onChanged: (SortCriteria? newValue) {
                      if (newValue != null) {
                        newsProvider.setSortCriteria(
                            newValue); // Update sorting criteria
                        newsProvider.searchNews(newsProvider.articles[0].title,
                            refresh: true); // Refresh search results
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: SortCriteria.date,
                        child: Text('Date'), // Sort by date
                      ),
                      DropdownMenuItem(
                        value: SortCriteria.relevancy,
                        child: Text('Relevancy'), // Sort by relevancy
                      ),
                      DropdownMenuItem(
                        value: SortCriteria.popularity,
                        child: Text('Popularity'), // Sort by popularity
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          // Display the list of articles
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, newsProvider, child) {
                if (newsProvider.articles.isEmpty) {
                  // Show message if no articles are found
                  return const Center(child: Text('Search for news articles'));
                } else if (newsProvider.articles.isNotEmpty) {
                  // Display the list of articles if there are any
                  return ListView.builder(
                    itemCount: newsProvider
                        .articles.length, // Number of articles to display
                    itemBuilder: (context, index) {
                      return ArticleCard(
                          article: newsProvider.articles[
                              index]); // Display each article in a card
                    },
                  );
                } else {
                  // Show an error message if articles couldn't be loaded
                  return const ErrorMessage(message: 'Failed to load news');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
