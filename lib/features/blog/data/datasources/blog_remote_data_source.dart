import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required BlogModel blog,
    required File image,
  });
  Future<List<BlogModel>> getAllBlogs(
      {int page = 1, int limit = 10}); // Add pagination parameters
  Future<List<BlogModel>> searchBlogPosts(String query);
  Future<List<BlogModel>> filterBlogPostsByCategory(String category);
  Future<List<BlogModel>> getBlogsByUser(String userId);
  Future<void> deleteBlog(String blogId);
  Future<void> editBlog({
    required BlogModel blog,
    File? image,
  });
  Future<BlogModel> getBlogById(String id);
  // New methods for likes
  Future<void> likeBlog(String blogId, String userId);
  Future<void> unlikeBlog(String blogId, String userId);
  Future<bool> isLikedByUser(String blogId, String userId);
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
  Future<void> likeBlog(String blogId, String userId) async {
    try {
      // Insert a new like record
      await supabaseClient.from('blog_likes').upsert({
        'blog_id': blogId,
        'user_id': userId,
      });

      // Optionally, create a notification for the blog author
      final blog = await supabaseClient
          .from('blogs')
          .select('poster_id')
          .eq('id', blogId)
          .single();

      await supabaseClient.from('notifications').insert({
        'user_id': blog['poster_id'],
        'blog_id': blogId,
        'type': 'like',
        'message': 'Someone liked your post!',
      });
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions('Failed to like blog: $e');
    }
  }

  @override
  Future<void> unlikeBlog(String blogId, String userId) async {
    try {
      // Delete the like record
      await supabaseClient
          .from('blog_likes')
          .delete()
          .match({'blog_id': blogId, 'user_id': userId});
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions('Failed to unlike blog: $e');
    }
  }

  @override
  Future<bool> isLikedByUser(String blogId, String userId) async {
    try {
      // Check if the user has liked the blog
      final response = await supabaseClient
          .from('blog_likes')
          .select()
          .match({'blog_id': blogId, 'user_id': userId}).maybeSingle();

      return response != null; // Returns true if the entry exists
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions('Failed to check if blog is liked: $e');
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs({int page = 1, int limit = 10}) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;

      final blogs = await supabaseClient.from('blogs').select('''
    *,
    profiles (name),
    blog_likes (
      blog_id
    ) 
  ''').order('updated_at', ascending: false);

      return blogs.map<BlogModel>((blog) {
        final likes = blog['blog_likes'] as List;
        final likesCount = likes.length;
        final isLiked = likes.any((like) => like['user_id'] == userId);

        return BlogModel.fromMap(blog).copyWith(
          posterName: blog['profiles']['name'],
          likesCount: likesCount,
          isLiked: isLiked,
        );
      }).toList();
    } on PostgrestException catch (e) {
      print("Error fetching blogs: ${e.message}");
      throw ServerExceptions(e.message);
    } catch (e) {
      print("Unexpected error: $e");
      throw ServerExceptions(e.toString());
    }
  }

  // Modify getBlogById to include likes information
  @override
  Future<BlogModel> getBlogById(String id) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .select('*, profiles (name), likes_count')
          .eq('id', id)
          .single();

      return BlogModel.fromMap(blogData).copyWith(
        posterName: blogData['profiles']['name'],
        likesCount: blogData['likes_count'] ?? 0,
      );
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
    return response
        .map((blog) => BlogModel.fromMap(blog).copyWith(
              posterId: blog['profiles']['poster_id'],
              posterName: blog['profiles']['name'],
            ))
        .toList();
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    await supabaseClient
        .from('blogs')
        .delete()
        .eq('id', blogId); // Delete blog by ID
    await supabaseClient.storage.from('blog_images').remove([blogId]);
  }

  @override
  Future<void> editBlog({
    required BlogModel blog,
    File? image, // Optional new image
  }) async {
    try {
      String? imageUrl;

      if (image != null) {
        // Step 1: Delete the old image (if it exists)
        try {
          await supabaseClient.storage.from('blog_images').remove([blog.id]);
        } on StorageException catch (e) {
          // Ignore if the old image doesn't exist
          if (!e.message.contains('not found')) {
            throw ServerExceptions(e.message);
          }
        }

        // Step 2: Upload the new image with a unique name
        final uniqueFileName =
            '${blog.id}_${DateTime.now().millisecondsSinceEpoch}';
        await supabaseClient.storage
            .from('blog_images')
            .upload(uniqueFileName, image);

        // Step 3: Get the new image's public URL
        imageUrl = supabaseClient.storage
            .from('blog_images')
            .getPublicUrl(uniqueFileName);
      }

      // Step 4: Update blog content and image URL in the database
      final updateData = {
        'title': blog.title,
        'content': blog.content,
        'topics': blog.topics,
        'updated_at': blog.updatedAt.toIso8601String(),
      };

      if (imageUrl != null) {
        updateData['image_url'] =
            imageUrl; // Only update if a new image was uploaded
      }

      await supabaseClient.from('blogs').update(updateData).eq('id', blog.id);
    } on StorageException catch (e) {
      throw ServerExceptions(e.message);
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
