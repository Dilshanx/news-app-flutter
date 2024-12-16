/// Represents a news article.
class Article {
  final String title;
  final String? description;
  final String? urlToImage;
  final String url;
  final String? author;
  final String? publishedAt;
  final String? content;

  /// Creates an Article instance.
  Article({
    required this.title,
    this.description,
    this.urlToImage,
    required this.url,
    this.author,
    this.publishedAt,
    this.content,
  });

  /// Creates an Article from a JSON map for NewsAPI data.
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'],
      urlToImage: json['urlToImage'],
      url: json['url'] ?? '#',
      author: json['author'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }

  /// Converts the Article to a map (for local storage).
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'url': url,
      'author': author,
      'publishedAt': publishedAt,
      'content': content,
    };
  }

  /// Creates an Article from a map (for local storage).
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      title: map['title'],
      description: map['description'],
      urlToImage: map['urlToImage'],
      url: map['url'],
      author: map['author'],
      publishedAt: map['publishedAt'],
      content: map['content'],
    );
  }
}
