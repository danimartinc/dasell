import 'package:DaSell/commons.dart';

/// representa un nodo de chat entre 2 personas.
/// podria ir en el mismo archivo que `ChatRoomItem`.
class ChatViewItemVo {
  final String? imageUrl;
  final DateTime? time;
  final String title, subtitle;

  /// usado para el ValueKey y mandar a la otra pantalla.
  final UserVo receiver;

  String get widgetId {
    return receiver.uid;
  }

  ChatViewItemVo({
    required this.receiver,
    required this.title,
    required this.subtitle,
    required this.time,
    this.imageUrl,
  });

  String get textTime {
    if (time == null) {
      return "";
    }
    return AppUtils.getTimeAgoText(time!);
  }
}
