import '../utils/date_formatter.dart';

extension DateTimeExtensions on DateTime {
  String get toFormattedDate => DateFormatter.formatFullDate(this);
  String get toFormattedDateTime => DateFormatter.formatDateTime(this);
  String get toFormattedMonthYear => DateFormatter.formatMonthYear(this);
  String get toRelativeDate => DateFormatter.formatRelative(this);

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  int get daysInMonth => DateTime(year, month + 1, 0).day;
}
