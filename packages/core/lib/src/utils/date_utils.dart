import 'package:intl/intl.dart';

abstract final class AppDateUtils {
  static String format(DateTime date, {String pattern = 'dd MMM yyyy'}) =>
      DateFormat(pattern).format(date);

  static String formatTime(DateTime date, {String pattern = 'HH:mm'}) =>
      DateFormat(pattern).format(date);

  static String formatDateTime(DateTime date) =>
      DateFormat('dd MMM yyyy, HH:mm').format(date);

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return format(date);
  }
}
