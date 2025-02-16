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

// Modified to include pagination info
final class BlogsDisplaySuccess extends BlogState {
  final List<Blog> blogs;
  final bool hasReachedEnd;
  final int currentPage;

  BlogsDisplaySuccess({
    required this.blogs,
    this.hasReachedEnd = false,
    this.currentPage = 1,
  });

  BlogsDisplaySuccess copyWith({
    List<Blog>? blogs,
    bool? hasReachedEnd,
    int? currentPage,
  }) {
    return BlogsDisplaySuccess(
      blogs: blogs ?? this.blogs,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}


// States
class BlogDeleteSuccess extends BlogState {}

class BlogEditSuccess extends BlogState {}

// New States
final class BlogLikedState extends BlogState {
  final String blogId;
  BlogLikedState({required this.blogId});
}

final class BlogUnlikeState extends BlogState {
  final String blogId;
  BlogUnlikeState({required this.blogId});
}

final class BlogIsLikedState extends BlogState {
  final String blogId;
  final bool isLiked;
  BlogIsLikedState({required this.blogId, required this.isLiked});
}
