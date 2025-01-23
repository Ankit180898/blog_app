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
