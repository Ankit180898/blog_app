import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class BlogField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const BlogField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: null,
        alignLabelWithHint: true,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8.0,
          ),
          borderSide: BorderSide(
            color: AppPalette.error,
            width: 2,
          ),
        ),
      ),
      maxLines: null,
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
    );
  }
}
