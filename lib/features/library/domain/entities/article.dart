class Article {
  final String id;
  final String title;
  final String content;
  final String category;
  final int orderInCategory;

  const Article({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.orderInCategory,
  });
}

class ArticleCategory {
  final String name;
  final List<Article> articles;

  const ArticleCategory({
    required this.name,
    required this.articles,
  });
}
