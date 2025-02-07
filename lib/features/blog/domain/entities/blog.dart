class Blog {
  final String id;
  final String? posterName;
  final String posterId;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;
  final DateTime updatedAt;
  final int likesCount;    // Add this field
  final bool isLiked;      // Add this field

  Blog({
    required this.id,
    this.posterName,
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
    this.likesCount = 0,    // Add with default value
    this.isLiked = false,   // Add with default value
  });
}