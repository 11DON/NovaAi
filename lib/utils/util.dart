// TODO Implement this library.
import 'package:intl/intl.dart';

String formatTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final now = DateTime.now();

  // If the date is today, show only the time
  if (date.day == now.day && date.month == now.month && date.year == now.year) {
    return DateFormat('hh:mm a').format(date); // e.g., 03:45 PM
  }

  // Otherwise, show short date
  return DateFormat('MMM d').format(date); // e.g., Jul 11
}
