import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatFullDate(DateTime date, {String locale = 'vi_VN'}) {
    return DateFormat('dd/MM/yyyy', locale).format(date);
  }

  static String formatDateTime(DateTime date, {String locale = 'vi_VN'}) {
    return DateFormat('HH:mm - dd/MM/yyyy', locale).format(date);
  }

  static String formatMonthYear(DateTime date, {String locale = 'vi_VN'}) {
    return DateFormat('MMMM yyyy', locale).format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final difference = today.difference(targetDate).inDays;

    if (difference == 0) {
      return 'Hôm nay';
    } else if (difference == 1) {
      return 'Hôm qua';
    } else if (difference == -1) {
      return 'Ngày mai';
    } else if (difference > 1 && difference < 7) {
      return '$difference ngày trước';
    } else {
      return formatFullDate(date);
    }
  }
}
