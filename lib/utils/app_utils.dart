import 'package:timeago/timeago.dart' as timeago;

/// Usa clase global para poner helpers aca.
abstract class AppUtils {
  static String getTimeAgoText(DateTime date) {
    // return '3 minutes ago';
    return timeago.format(date, locale: 'es');
  }
}
