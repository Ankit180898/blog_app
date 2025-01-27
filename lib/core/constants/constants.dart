import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constants {
  static const List<String> topics = [
    'All',
    'Technology',
    'Business',
    'Programming',
    'Entertainment',
    'Design'
  ];


  static const noConnectionErrorMessage = 'Not connected to a network!';
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  static List<TextSpan> formatBlogContent(String content, BuildContext context) {
  final List<TextSpan> spans = [];
  final List<String> lines = content.split('\n'); // Split by new lines

  for (String line in lines) {
    if (line.startsWith('# ')) {
      // Heading 1
      spans.add(
        TextSpan(
          text: '${line.substring(2).trim()}\n',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppPalette.focusedColor,
              ),
        ),
      );
    } else if (line.startsWith('## ')) {
      // Heading 2
      spans.add(
        TextSpan(
          text: '${line.substring(3).trim()}\n',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppPalette.focusedColor,
              ),
        ),
      );
    } else if (line.startsWith('### ')) {
      // Heading 3
      spans.add(
        TextSpan(
          text: '${line.substring(4).trim()}\n',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppPalette.focusedColor,
              ),
        ),
      );
    } else if (line.startsWith('> ')) {
      // Blockquote
      spans.add(
        TextSpan(
          text: '${line.substring(2).trim()}\n',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppPalette.textGrey,
              ),
        ),
      );
    } else if (line.startsWith('- ')) {
      // Unordered list item
      spans.add(
        TextSpan(
          text: '• ${line.substring(2).trim()}\n',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    } else if (line.startsWith(RegExp(r'\d+\. '))) {
      // Ordered list item
      spans.add(
        TextSpan(
          text: '$line\n',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    } else if (line.contains('**')) {
      // Bold text
      final parts = line.split('**');
      for (int i = 0; i < parts.length; i++) {
        if (i % 2 == 1) {
          spans.add(
            TextSpan(
              text: parts[i],
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: parts[i],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
      }
      spans.add(const TextSpan(text: '\n'));
    } else if (line.contains('*')) {
      // Italic text
      final parts = line.split('*');
      for (int i = 0; i < parts.length; i++) {
        if (i % 2 == 1) {
          spans.add(
            TextSpan(
              text: parts[i],
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: parts[i],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
      }
      spans.add(const TextSpan(text: '\n'));
    } else if (line.contains('`')) {
      // Inline code
      final parts = line.split('`');
      for (int i = 0; i < parts.length; i++) {
        if (i % 2 == 1) {
          spans.add(
            TextSpan(
              text: parts[i],
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    backgroundColor: AppPalette.containerColor,
                    fontFamily: 'monospace',
                  ),
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: parts[i],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
      }
      spans.add(const TextSpan(text: '\n'));
    } else if (line.contains('[') && line.contains('](')) {
      // Hyperlink
      final regex = RegExp(r'\[(.*?)\]\((.*?)\)');
      final match = regex.firstMatch(line);
      if (match != null) {
        final text = match.group(1);
        final url = match.group(2);
        spans.add(
          TextSpan(
            text: '$text\n',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Open the URL
                // launchUrl(Uri.parse(url!));
              },
          ),
        );
      }
    } else {
      // Regular text
      spans.add(
        TextSpan(
          text: '$line\n',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
  }

  return spans;
}

}