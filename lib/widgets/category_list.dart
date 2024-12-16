import 'package:flutter/material.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_styles.dart';

class CategoryList extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategoryList({super.key, required this.onCategorySelected});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  // List of categories to display
  final List<String> categories = [
    'general',
    'technology',
    'business',
    'entertainment',
    'health',
    'science',
    'sports'
  ];
  String selectedCategory = 'general'; // Default selected category

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0, // Height of the category list
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scrolling
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(
                category.toUpperCase(),
                style: selectedCategory == category
                    ? AppStyles.buttonText // Style for selected category
                    : AppStyles.bodyText2, // Style for unselected category
              ),
              selected: selectedCategory == category,
              selectedColor: AppColors.primaryColor, // Highlight selected chip
              onSelected: (bool selected) {
                setState(() {
                  selectedCategory = category; // Update selected category
                  widget.onCategorySelected(category); // Notify parent widget
                });
              },
            ),
          );
        },
      ),
    );
  }
}
