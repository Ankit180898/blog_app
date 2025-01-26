part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final String posterId;
  final String title;
  final File image;
  final String content;
  final List<String> topics;
  BlogUpload({
    required this.posterId,
    required this.title,
    required this.image,
    required this.content,
    required this.topics,
  });
}

final class BlogFetchAllBlogs extends BlogEvent {}

class SearchBlogPostsEvent extends BlogEvent {
  final String query;
  SearchBlogPostsEvent(this.query);
}

class FilterBlogPostsByCategoryEvent extends BlogEvent {
  final String category;
  FilterBlogPostsByCategoryEvent(this.category);
}

// Events
class FetchUserBlogsEvent extends BlogEvent {
  final String userId;
  FetchUserBlogsEvent(this.userId);
}

class DeleteBlogEvent extends BlogEvent {
  final String blogId;
  DeleteBlogEvent(this.blogId);
}

class EditBlogEvent extends BlogEvent {
  final String id;
  final String title;
  final File? image;
  final String posterId;
  final String content;
  final List<String> topics;
  EditBlogEvent( {
    required this.id,
    required this.title,
    required this.image,
    required this.content,
    required this.topics,
    required this.posterId,
  });
}

