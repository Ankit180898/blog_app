import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required BlogModel blog,
    required File image,
  });
  Future<List<BlogModel>> getAllBlogs();
  Future<List<BlogModel>> searchBlogPosts(String query);
  Future<List<BlogModel>> filterBlogPostsByCategory(String category);
  Future<List<BlogModel>> getBlogsByUser(String userId);
  Future<void> deleteBlog(String blogId);
  Future<void> editBlog({
    required BlogModel blog,
    File? image,
  });
}

class BlogRemoteDataSourceImpl extends BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toMap()).select();
      return BlogModel.fromMap(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required BlogModel blog,
    required File image,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles (name)');

      return blogs
          .map(
            (blog) => BlogModel.fromMap(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> filterBlogPostsByCategory(String category) async {
    try {
      // Fetch blog posts filtered by category, including profiles
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)') // Include profiles to get posterName
          .contains('topics', [category]); // Use the array containment operator

      // Map the result to BlogModel
      return blogs
          .map((blog) => BlogModel.fromMap(blog).copyWith(
                topics: List<String>.from(blog['topics']),
                posterName: blog['profiles']
                    ['name'], // Fetch posterName correctly
              ))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> searchBlogPosts(String query) async {
    try {
      // Fetch blog posts filtered by search query
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)')
          .ilike('title', '%$query%');

      // Map the result to BlogModel
      return blogs
          .map(
            (blog) => BlogModel.fromMap(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getBlogsByUser(String userId) async {
    final response = await supabaseClient
        .from('blogs')
        .select('*, profiles (name)') // Include profiles to get posterName
        .eq('poster_id', userId); // Fetch blogs by user ID
    return response.map((blog) => BlogModel.fromMap(blog).copyWith(
      posterId: blog['profiles']['poster_id'],
      posterName: blog['profiles']['name'],
    )).toList();
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    await supabaseClient
        .from('blogs')
        .delete()
        .eq('id', blogId); // Delete blog by ID
  }

  @override
  Future<void> editBlog({
    required BlogModel blog,
    File? image, // Make the image parameter optional
  }) async {
    try {
      // If a new image is provided, upload it and update the blog's image URL
      if (image != null) {
        // Upload the new image to Supabase Storage
        await supabaseClient.storage.from('blog_images').upload(blog.id, image);

        // Get the public URL of the uploaded image
        final imageUrl =
            supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);

        // Update the blog's image URL in the database
        await supabaseClient
            .from('blogs')
            .update({'imageUrl': imageUrl}).eq('id', blog.id);
      }

      // Update the blog content in the database
      await supabaseClient.from('blogs').update(blog.toMap()).eq('id', blog.id);
    } on StorageException catch (e) {
      throw ServerExceptions(e.message);
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
