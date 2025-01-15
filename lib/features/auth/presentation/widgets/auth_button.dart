import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String btnText;
  const AuthButton({super.key, required this.btnText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: AppPalette.textGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppPalette.focusedColor,
        fixedSize: Size(395, 55),
      ),
      child: Text(
        btnText,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppPalette.whiteColor),
      ),
    );
  }
}
