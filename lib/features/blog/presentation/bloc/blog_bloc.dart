import 'dart:io';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_user_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/edit_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/filter_blogs_by_category.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/get_user_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/is_blog_liked_usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/like_blog_usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/search_blog_post.dart';
import 'package:blog_app/features/blog/domain/usecases/unlike_blog_usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final SearchBlogPosts _searchBlogPosts;
  final FilterBlogPostsByCategory _filterBlogPostsByCategory;
  final EditBlog _editBlog;
  final DeleteUserBlog _deleteBlog; // Add this
  final GetUserBlogs _getUserBlogs;
  final LikeBlog _likeBlog;
  final UnlikeBlog _unlikeBlog;
  final IsBlogLikedByUser _isBlogLikedByUser;
  static const int _pageLimit = 10;
  List<Blog> _allBlogs = [];
  bool _hasReachedEnd = false;
  int _currentPage = 1;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required SearchBlogPosts searchBlogPosts,
    required FilterBlogPostsByCategory filterBlogPostsByCategory,
    required EditBlog editBlog,
    required DeleteUserBlog deleteBlog,
    required GetUserBlogs getUserBlogs,
    required LikeBlog likeBlog,
    required UnlikeBlog unlikeBlog,
    required IsBlogLikedByUser isBlogLikedByUser,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _searchBlogPosts = searchBlogPosts,
        _filterBlogPostsByCategory = filterBlogPostsByCategory,
        _editBlog = editBlog,
        _deleteBlog = deleteBlog,
        _getUserBlogs = getUserBlogs,
        _likeBlog = likeBlog,
        _unlikeBlog = unlikeBlog,
        _isBlogLikedByUser = isBlogLikedByUser,
        super(BlogInitial()) {
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onGetAllBlogs);
    on<SearchBlogPostsEvent>(_onSearchBlogPosts);
    on<FilterBlogPostsByCategoryEvent>(_onFilterBlogPostsByCategory);
    on<EditBlogEvent>(_onEditBlog);
    on<DeleteBlogEvent>(_onDeleteBlog);
    on<FetchUserBlogsEvent>(_onFetchUserBlogs);
    on<LikeBlogEvent>(_onLikeBlog);
    on<UnlikeBlogEvent>(_onUnlikeBlog);
    on<CheckIfBlogIsLikedEvent>(_onCheckIfBlogIsLiked);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    emit(BlogLoading()); // Add loading state here

    final res = await _uploadBlog(UploadBlogParams(
      posterId: event.posterId,
      title: event.title,
      image: event.image,
      content: event.content,
      topics: event.topics,
    ));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onGetAllBlogs(BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    _currentPage = 1;
    _hasReachedEnd = false;

    final res =
        await _getAllBlogs(PageParams(page: _currentPage, limit: _pageLimit));

    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blogs) {
        _allBlogs = blogs;
        _hasReachedEnd = blogs.length < _pageLimit;
        emit(BlogsDisplaySuccess(
          blogs: _allBlogs,
          hasReachedEnd: _hasReachedEnd,
          currentPage: _currentPage,
        ));
      },
    );
  }

  void _onSearchBlogPosts(
      SearchBlogPostsEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading()); // Add loading state here

    final res = await _searchBlogPosts(event.query);
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(
        blogs: r, // Pass the fetched blogs
        hasReachedEnd: false, // Reset pagination state
        currentPage: 1, // Reset pagination state
      )),
    );
  }

  void _onFilterBlogPostsByCategory(
      FilterBlogPostsByCategoryEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading()); // Add loading state here

    final res = await _filterBlogPostsByCategory(event.category);
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(
        blogs: r, // Pass the fetched blogs
        hasReachedEnd: false, // Reset pagination state
        currentPage: 1, // Reset pagination state
      )),
    );
  }

  void _onEditBlog(EditBlogEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _editBlog(EditBlogParams(
      id: event.id,
      title: event.title,
      image: event.image, // Pass the optional image
      content: event.content,
      topics: event.topics,
    ));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogEditSuccess()),
    );
  }

  void _onDeleteBlog(DeleteBlogEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _deleteBlog(event.blogId);
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogDeleteSuccess()),
    );
  }

  void _onFetchUserBlogs(
      FetchUserBlogsEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _getUserBlogs(event.userId);
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(
        blogs: r, // Pass the fetched blogs
        hasReachedEnd: false, // Reset pagination state
        currentPage: 1, // Reset pagination state
      )),
    );
  }

  void _onLikeBlog(LikeBlogEvent event, Emitter<BlogState> emit) async {
    final currentState = state;

    if (currentState is BlogsDisplaySuccess) {
      // Update the blog's like count and isLiked status
      final updatedBlogs = currentState.blogs.map((blog) {
        if (blog.id == event.blogId) {
          return (blog as BlogModel).copyWith(
            isLiked: true,
            likesCount: blog.likesCount + 1,
          );
        }
        return blog;
      }).toList();

      emit(currentState.copyWith(blogs: updatedBlogs));

      // Call the likeBlog use case
      final result = await _likeBlog(LikeBlogParams(
        blogId: event.blogId,
        userId: event.userId,
      ));

      result.fold(
        (failure) {
          // Revert the state if the like action fails
          emit(currentState.copyWith(blogs: currentState.blogs));
          emit(BlogFailure(failure.message));
        },
        (_) => null, // No need to emit a new state here
      );
    }
  }

  void _onUnlikeBlog(UnlikeBlogEvent event, Emitter<BlogState> emit) async {
    final currentState = state;

    if (currentState is BlogsDisplaySuccess) {
      // Update the blog's like count and isLiked status
      final updatedBlogs = currentState.blogs.map((blog) {
        if (blog.id == event.blogId) {
          return (blog as BlogModel).copyWith(
            isLiked: false,
            likesCount: blog.likesCount - 1,
          );
        }
        return blog;
      }).toList();

      emit(currentState.copyWith(blogs: updatedBlogs));

      // Call the unlikeBlog use case
      final result = await _unlikeBlog(UnlikeBlogParams(
        blogId: event.blogId,
        userId: event.userId,
      ));

      result.fold(
        (failure) {
          // Revert the state if the unlike action fails
          emit(currentState.copyWith(blogs: currentState.blogs));
          emit(BlogFailure(failure.message));
        },
        (_) => null, // No need to emit a new state here
      );
    }
  }

  void _onCheckIfBlogIsLiked(
      CheckIfBlogIsLikedEvent event, Emitter<BlogState> emit) async {
    final result = await _isBlogLikedByUser(LikeBlogParams(
      blogId: event.blogId,
      userId: event.userId,
    ));

    result.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (isLiked) =>
          emit(BlogIsLikedState(blogId: event.blogId, isLiked: isLiked)),
    );
  }
}
