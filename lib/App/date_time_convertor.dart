import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatTime(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.Hm().format(dateTime);
  }
}
