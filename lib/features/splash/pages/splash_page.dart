import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => SplashPage());
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BLOGD",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 50,
                        ),
                  ),
                  Text(
                    "Personal Blogging Partner",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              Center(child: Image.asset("assets/images/background_gif.png")),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Tell your ",
                      style: Theme.of(context).textTheme.displayMedium,
                      children: [
                        TextSpan(
                            text: 'Story ',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    color: AppPalette.secondaryColor,
                                    fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'with us',
                            style: Theme.of(context).textTheme.displayMedium)
                      ]),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, LoginPage.route());
                },
                child: Image.asset(
                  "assets/images/arrow_right.gif",
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.15,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
