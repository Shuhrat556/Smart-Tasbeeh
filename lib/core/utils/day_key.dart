class DayKey {
  const DayKey._();

  static String fromDate(DateTime date) {
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static int sumLastDays(
    Map<String, int> dailyHistory,
    int days, {
    DateTime? from,
  }) {
    int total = 0;
    final DateTime now = from ?? DateTime.now();
    for (int i = 0; i < days; i++) {
      final String key = fromDate(now.subtract(Duration(days: i)));
      total += dailyHistory[key] ?? 0;
    }
    return total;
  }
}
