import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/utils/app_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the article passed as an argument
    final Article article =
        ModalRoute.of(context)!.settings.arguments as Article;

    // Format the published date
    String formattedDate = article.publishedAt != null
        ? DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(article.publishedAt!).toLocal())
        : 'Date not available';

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Article image or placeholder
            article.urlToImage != null
                ? CachedNetworkImage(
                    imageUrl: article.urlToImage!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    height: 250.0,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 250.0,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50.0),
                  ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article title
                  Text(
                    article.title,
                    style: AppStyles.headline1,
                  ),
                  const SizedBox(height: 16.0),

                  // Author and date
                  Text(
                    article.author ?? 'Unknown Author',
                    style: AppStyles.bodyText2,
                  ),
                  Text(
                    formattedDate,
                    style: AppStyles.bodyText2,
                  ),
                  const SizedBox(height: 16.0),

                  // Description and content
                  Text(
                    article.description ?? '',
                    style: AppStyles.bodyText1,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    article.content ?? '',
                    style: AppStyles.bodyText1,
                  ),
                  const SizedBox(height: 16.0),

                  // Open article URL
                  ElevatedButton(
                    onPressed: () async {
                      if (!await launchUrl(Uri.parse(article.url))) {
                        throw Exception('Could not launch ${article.url}');
                      }
                    },
                    child: const Text('Read Full Article'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
