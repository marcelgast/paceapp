import 'package:intl/intl.dart';

String formatMoneyCents(int cents, {String currencyCode = 'EUR'}) {
  final symbol = switch (currencyCode) {
    'EUR' => '€',
    'USD' => '\$',
    'GBP' => '£',
    _ => currencyCode,
  };
  final fmt = NumberFormat.currency(
    locale: 'de_DE',
    symbol: symbol,
    decimalDigits: 2,
  );
  return fmt.format(cents / 100);
}

/// Big dashboard clock — H:MM:SS, dropping the hour when zero.
String formatStintDuration(Duration d) {
  final neg = d.isNegative;
  final abs = d.abs();
  final h = abs.inHours;
  final m = abs.inMinutes.remainder(60);
  final s = abs.inSeconds.remainder(60);
  String two(int n) => n.toString().padLeft(2, '0');
  final body = h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  return neg ? '-$body' : body;
}

String formatClock(DateTime t) {
  final h = t.hour.toString().padLeft(2, '0');
  final m = t.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

/// "Heute", "Gestern" or "Mo, 02.06." for a day grouping header.
String formatDayHeader(DateTime day, DateTime now) {
  final d = DateTime(day.year, day.month, day.day);
  final today = DateTime(now.year, now.month, now.day);
  final diff = today.difference(d).inDays;
  if (diff == 0) return 'Heute';
  if (diff == 1) return 'Gestern';
  const weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
  final wd = weekdays[d.weekday - 1];
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  return '$wd, $dd.$mm.';
}

/// Locale-neutral numeric date — "07.02.2026".
String formatDate(DateTime d) => DateFormat('dd.MM.yyyy').format(d);

/// Human, compact — "2 h 14 min", "8 min", "während des Onboardings".
String formatHumanDuration(Duration d) {
  if (d.inMinutes < 1) return '${d.inSeconds} s';
  if (d.inHours < 1) return '${d.inMinutes} min';
  if (d.inDays < 1) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return m == 0 ? '$h h' : '$h h $m min';
  }
  final days = d.inDays;
  final h = d.inHours.remainder(24);
  return h == 0 ? '$days d' : '$days d $h h';
}
