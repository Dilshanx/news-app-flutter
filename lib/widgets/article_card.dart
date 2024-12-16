import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // Format date
    String formattedDate = article.publishedAt != null
        ? DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(article.publishedAt!).toLocal())
        : 'Date not available';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/article-detail', arguments: article);
      },
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display image or placeholder
            article.urlToImage != null
                ? CachedNetworkImage(
                    imageUrl: article.urlToImage!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    height: 200.0,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200.0,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50.0),
                  ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: AppStyles.headline2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  // Description
                  Text(
                    article.description ?? '',
                    style: AppStyles.bodyText1,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      // Author and Date
                      Expanded(
                        child: Text(
                          article.author ?? 'Unknown Author',
                          style: AppStyles.bodyText2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: AppStyles.bodyText2,
                      ),
                    ],
                  ),
                  // Favorite and Share buttons
                  Consumer<NewsProvider>(builder: (context, newsProvider, _) {
                    final isFavorited = newsProvider.isFavorite(article);

                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            newsProvider.toggleFavorite(article);
                          },
                          icon: Icon(
                            isFavorited
                                ? Icons.bookmark
                                : Icons.bookmark_border_outlined,
                            color: AppColors.accentColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await Share.share(
                                '${article.title}\n${article.url}');
                          },
                          icon: const Icon(
                            Icons.share,
                            color: AppColors.accentColor,
                          ),
                        )
                      ],
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
