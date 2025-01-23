import 'package:intl/intl.dart';

class Constants {
  static const List<String> topics = [
    'Technology',
    'Business',
    'Programming',
    'Entertainment',
  ];

  static const noConnectionErrorMessage = 'Not connected to a network!';
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}