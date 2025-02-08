import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_detail_page.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              BlogDetailPage.route(blog: blog),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                fontSize: 12,
                                color: AppPalette.focusedColor.withAlpha(100),
                              ),
                          children: [
                            const TextSpan(text: "In "), // Regular text
                            TextSpan(
                              text: blog.topics.isNotEmpty
                                  ? blog.topics.first
                                  : 'Blog', // Highlighted topic
                              style: TextStyle(
                                color: AppPalette
                                    .focusedColor, // Different color for emphasis
                              ),
                            ),
                            const TextSpan(text: " by "), // Regular text
                            TextSpan(
                              text: blog.posterName ??
                                  "Unknown", // Highlighted author name
                              style: TextStyle(
                                color: AppPalette
                                    .focusedColor, // Different color for emphasis
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        blog.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppPalette.focusedColor),
                      ),
                      // const SizedBox(height: 4),
                      Text(
                        blog.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppPalette.focusedColor.withAlpha(150),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            Constants.formatDate(blog.updatedAt),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppPalette.focusedColor.withAlpha(120),
                                ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "${calculateReadingTime(blog.content)} min read",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppPalette.focusedColor.withAlpha(120),
                                ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(CupertinoIcons.hand_thumbsup, size: 14),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            blog.likesCount.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppPalette.focusedColor.withAlpha(120),
                                ),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(CupertinoIcons.ellipsis_vertical))
                        ],
                      ),
                    ],
                  ),
                ),
                if (blog.imageUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 40.0),
                    child: Hero(
                      tag: 'blog-image-${blog.id}',
                      child: CachedNetworkImage(
                        imageUrl: blog.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: const Loader()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
