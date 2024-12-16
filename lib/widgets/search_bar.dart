import 'package:flutter/material.dart';
import 'package:news_app/utils/app_colors.dart';

class NewsSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const NewsSearchBar({super.key, required this.onSearch});

  @override
  _NewsSearchBarState createState() => _NewsSearchBarState();
}

class _NewsSearchBarState extends State<NewsSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for news...',
          prefixIcon: const Icon(Icons.search, color: AppColors.greyColor),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: AppColors.greyColor),
            onPressed: () {
              _searchController.clear();
              widget.onSearch('');
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: AppColors.greyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
        ),
        onSubmitted: (value) {
          widget.onSearch(value);
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
