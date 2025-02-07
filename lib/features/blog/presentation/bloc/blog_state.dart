part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogFailure extends BlogState {
  final String error;
  BlogFailure(this.error);
}

final class BlogUploadSuccess extends BlogState {}

final class BlogsDisplaySuccess extends BlogState {
  final List<Blog> blogs;
  BlogsDisplaySuccess(this.blogs);

}
// States
class BlogDeleteSuccess extends BlogState {}

class BlogEditSuccess extends BlogState {}

// New States
final class BlogLikedState extends BlogState {
  final String blogId;
  BlogLikedState({required this.blogId});
}

final class BlogUnlikedState extends BlogState {
  final String blogId;
  BlogUnlikedState({required this.blogId});
}

final class BlogIsLikedState extends BlogState {
  final String blogId;
  final bool isLiked;
  BlogIsLikedState({required this.blogId, required this.isLiked});
} 