import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/splash/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For dotenv
import 'package:supabase_flutter/supabase_flutter.dart'; // For Supabase

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures Flutter is properly initialized

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Get environment variables
  final supaUri = dotenv.env['SUPABASE_URL'];
  final supaAnon = dotenv.env['SUPABASE_ANONKEY'];

  // Check if environment variables are properly loaded
  if (supaUri == null || supaAnon == null) {
    throw Exception('Missing Supabase credentials in the .env file');
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: supaUri,
    anonKey: supaAnon,
  );

  runApp(const MyApp());
}

// Supabase client instance
final supabaseC = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlogD',
      theme: AppTheme.lightThemeMode,
      home: SplashPage(),
    );
  }
}
