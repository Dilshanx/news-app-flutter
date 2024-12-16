import 'package:flutter/material.dart';
import 'package:news_app/utils/app_styles.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        children: [
          const Icon(
            Icons.error_outline,
            size: 50.0, // Icon size
            color: Colors.red, // Icon color
          ),
          const SizedBox(height: 16.0), // Space between icon and text
          Text(
            message, // Display error message
            style: AppStyles.errorText, // Apply error text style
            textAlign: TextAlign.center, // Center-align text
          ),
        ],
      ),
    );
  }
}
