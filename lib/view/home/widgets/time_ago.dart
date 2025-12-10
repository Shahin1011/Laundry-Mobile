import 'package:intl/intl.dart';

String formatNotificationTime(String? dateString) {
  if (dateString == null || dateString.isEmpty) return "";

  DateTime dateTime = DateTime.parse(dateString).toLocal();
  DateTime now = DateTime.now();

  Duration diff = now.difference(dateTime);

  // 🔹 Today
  if (diff.inDays == 0) {
    if (diff.inHours > 0) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago";
    } else {
      return "Just now";
    }
  }

  // 🔹 Yesterday
  if (diff.inDays == 1) {
    String time = DateFormat("h:mm a").format(dateTime);
    return "Yesterday at $time";
  }

  // 🔹 Within past 7 days → weekday + time
  if (diff.inDays < 7) {
    return DateFormat("EEEE, h:mm a").format(dateTime); // Example: Monday, 5:30 PM
  }

  // 🔹 Older → show full date
  return DateFormat("MMMM d, yyyy").format(dateTime); // Example: December 9, 2025
}
