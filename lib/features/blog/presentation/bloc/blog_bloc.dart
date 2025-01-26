import 'dart:io';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_user_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/edit_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/filter_blogs_by_category.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/get_user_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/search_blog_post.dart';
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
  final GetUserBlogs _getUserBlogs; //

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required SearchBlogPosts searchBlogPosts,
    required FilterBlogPostsByCategory filterBlogPostsByCategory,
    required EditBlog editBlog,
    required DeleteUserBlog deleteBlog,
    required GetUserBlogs getUserBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _searchBlogPosts = searchBlogPosts,
        _filterBlogPostsByCategory = filterBlogPostsByCategory,
        _editBlog = editBlog,
        _deleteBlog = deleteBlog,
        _getUserBlogs = getUserBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onGetAllBlogs);
    on<SearchBlogPostsEvent>(_onSearchBlogPosts);
    on<FilterBlogPostsByCategoryEvent>(_onFilterBlogPostsByCategory);
    on<EditBlogEvent>(_onEditBlog);
    on<DeleteBlogEvent>(_onDeleteBlog); // Add this
    on<FetchUserBlogsEvent>(_onFetchUserBlogs); // Add this
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
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
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(r)),
    );
  }

  void _onSearchBlogPosts(
      SearchBlogPostsEvent event, Emitter<BlogState> emit) async {
    final res = await _searchBlogPosts(event.query);
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(r)),
    );
  }

  void _onFilterBlogPostsByCategory(
      FilterBlogPostsByCategoryEvent event, Emitter<BlogState> emit) async {
    final res = await _filterBlogPostsByCategory(event.category);
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(r)),
    );
  }

  void _onEditBlog(EditBlogEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _editBlog(EditBlogParams(
      id: event.id,
      title: event.title,
      image: event.image!,
      content: event.content,
      topics: event.topics,
    ));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
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

  void _onFetchUserBlogs(FetchUserBlogsEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _getUserBlogs(event.userId);
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(r)),
    );
  }
}
