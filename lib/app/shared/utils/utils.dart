class AppUtils {
  AppUtils._();

  static const String appLabel = 'Galaxy Tunnel';
  static const String appVersion = '1.0.0';

  static String formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static bool isDarkColor(Color color) {
    return (color.red * 0.299 + color.green * 0.587 + color.blue * 0.114) < 128;
  }
}
