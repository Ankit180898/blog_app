import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_detail_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            BlogDetailPage.route(blog: blog),
          ),
          child: Card(
            elevation: 0,
            color: AppPalette.secondaryColor.withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    blog.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black), // Default style
                          children: [
                            TextSpan(
                              text: 'By: ',
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold), // Bold for "By:"
                            ),
                            TextSpan(
                              text: blog.posterName!, // Author's name
                              style: TextStyle(
                                decoration: TextDecoration
                                    .underline, // Underline the author's name
                              ), // Style for the author's name
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(
                        Constants.formatDate(blog.updatedAt),
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: AppPalette.textGrey,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 0.5,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            blog.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Wrap(
                            children: blog.topics
                                .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: Chip(
                                          label: Text(
                                            e,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          color: WidgetStatePropertyAll(
                                              AppPalette.transparent)),
                                    ))
                                .toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    blog.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppPalette.focusedColor,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            right: 0,
            top: 8,
            child: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)))
      ],
    );
  }
}
