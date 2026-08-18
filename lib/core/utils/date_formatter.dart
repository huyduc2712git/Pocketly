class DateFormatter {
  DateFormatter._();

  static String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  static String formatFullDate(DateTime date) {
    return formatDate(date);
  }

  static String formatDateTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute - ${formatDate(date)}';
  }

  static String formatMonthYear(DateTime date) {
    return 'Tháng ${date.month}/${date.year}';
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
