import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogDetailPage extends StatelessWidget {
  static Route route({required Blog blog}) {
    return MaterialPageRoute(builder: (_) => BlogDetailPage(blog: blog));
  }

  final Blog blog;

  const BlogDetailPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                height: MediaQuery.of(context).size.height * 0.30,
                blog.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  children: blog.topics
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Chip(
                                label: Text(e),
                                color: WidgetStatePropertyAll(
                                    AppPalette.secondaryColor.withAlpha(20))),
                          ))
                      .toList(),
                ),
                Text(
                  Constants.formatDate(blog.updatedAt),
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppPalette.textGrey,
                  ),
                ),
              ],
            ),
            Text(
              blog.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 10, color: Colors.black), // Default style
                    children: [
                      TextSpan(
                        text: 'By: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold), // Bold for "By:"
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
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      size: 18,
                      Icons.share_rounded,
                      color: AppPalette.textGrey,
                    ))
              ],
            ),
            const Divider(
              color: AppPalette.textGrey,
            ),
            const SizedBox(height: 12),
            // Using Text.rich for formatted content
            Text.rich(
              TextSpan(
                children: _formatBlogContent(blog.content),
              ),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ));
  }

  List<TextSpan> _formatBlogContent(String content) {
    // Split the content into parts based on your formatting rules
    // For example, you can split by new lines or specific markers
    List<TextSpan> spans = [];
    List<String> lines = content.split('\n'); // Split by new lines

    for (String line in lines) {
      spans.add(
          TextSpan(text: '${line.trim()}\n')); // Add each line as a TextSpan
    }

    return spans;
  }
}
