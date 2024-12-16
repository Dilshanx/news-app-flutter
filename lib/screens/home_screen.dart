import 'package:flutter/material.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/widgets/article_card.dart';
import 'package:news_app/widgets/category_list.dart';
import 'package:news_app/widgets/error_message.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch top headlines when the screen initializes
    Provider.of<NewsProvider>(context, listen: false).getTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'), // AppBar with title
        actions: [
          // Search button to navigate to the search screen
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              icon: const Icon(Icons.search)),
          // Bookmark button to navigate to the favorites screen
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
              icon: const Icon(Icons.bookmark))
        ],
      ),
      body: Column(
        children: [
          // Category list to filter news by category
          CategoryList(
            onCategorySelected: (category) {
              // Fetch top headlines based on selected category
              Provider.of<NewsProvider>(context, listen: false)
                  .getTopHeadlines(category: category);
            },
          ),
          // Sort criteria selection (Date, Relevancy, Popularity)
          Consumer<NewsProvider>(
            builder: (context, newsProvider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Sort by',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Dropdown to select the sorting criteria
                  DropdownButton<SortCriteria>(
                    value: newsProvider.sortCriteria,
                    onChanged: (SortCriteria? newValue) {
                      if (newValue != null) {
                        // Update sort criteria and refresh headlines
                        newsProvider.setSortCriteria(newValue);
                        newsProvider.getTopHeadlines(
                            refresh: true); // Refresh with new sorting criteria
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: SortCriteria.date,
                        child: Text('Date'),
                      ),
                      DropdownMenuItem(
                        value: SortCriteria.relevancy,
                        child: Text('Relevancy'),
                      ),
                      DropdownMenuItem(
                        value: SortCriteria.popularity,
                        child: Text('Popularity'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, newsProvider, child) {
                return RefreshIndicator(
                  // Handle pull-to-refresh gesture
                  onRefresh: () async {
                    // Trigger the refresh and wait for it to complete
                    await Provider.of<NewsProvider>(context, listen: false)
                        .getTopHeadlines(refresh: true);
                  },
                  child: newsProvider.isLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Show loading indicator while fetching data
                      : newsProvider.articles.isNotEmpty
                          ? ListView.builder(
                              itemCount: newsProvider.articles.length,
                              itemBuilder: (context, index) {
                                // Display each article using the ArticleCard widget
                                return ArticleCard(
                                    article: newsProvider.articles[index]);
                              },
                            )
                          : const ErrorMessage(
                              message:
                                  'Failed to load news'), // Show error message if no articles found
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
