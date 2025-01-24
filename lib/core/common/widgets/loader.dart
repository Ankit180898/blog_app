import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        backgroundColor: AppPalette.secondaryColor.withAlpha(20),
      ),
    );
  }
}
