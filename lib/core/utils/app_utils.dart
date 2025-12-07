import 'dart:io';

class AppUtils {

  static bool isiOS26OrAbove() {
    if (!Platform.isIOS) return false;

    final osString = Platform.operatingSystemVersion;

    // Extract the first number (major iOS version) using regex
    final match = RegExp(r'(\d+)(?:\.\d+)?').firstMatch(osString);
    print("reg ex ios version: ${match.toString()}");
    if (match == null) return false;

    final majorVersion = double.tryParse(match.group(1) ?? '0') ?? 0;

    return majorVersion >= 26;
  }

  static DateTime currentDate() {
    return DateTime.now();
  }

  static List<DateTime> upcomingMonths({int count = 3}) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return List.generate(count, (i) {
      final m = start.month + i;
      final y = start.year + ((m - 1) ~/ 12);
      final realM = ((m - 1) % 12) + 1;
      return DateTime(y, realM, 1);
    });
  }

  static List<DateTime> first30DaysOfMonth(DateTime month) {
    final nextMonthStart = DateTime(
      month.month == 12 ? month.year + 1 : month.year,
      month.month == 12 ? 1 : month.month + 1,
      1,
    );
    final lastDay = nextMonthStart.subtract(const Duration(days: 1)).day;
    final count = lastDay >= 30 ? 30 : lastDay;
    return List.generate(count, (i) => DateTime(month.year, month.month, i + 1));
  }

  static String monthYearLabel(DateTime month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${names[month.month - 1]} ${month.year}';
  }

  static String shortWeekday(DateTime date) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[date.weekday - 1];
  }
}
