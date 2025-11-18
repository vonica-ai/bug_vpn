import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';

final v2RayStatusProvider = StateProvider<V2RayStatus>((ref) {
  return V2RayStatus();
});

final v2rayProvider = Provider<V2ray>((ref) {
  final v2ray = V2ray(
    onStatusChanged: (status) {
      print(status.state);
      ref.read(v2RayStatusProvider.notifier).update(
            (state) => V2RayStatus(
              download: status.download,
              downloadSpeed: status.downloadSpeed,
              duration: status.duration,
              state: status.state,
              upload: status.upload,
              uploadSpeed: status.uploadSpeed,
            ),
          );
    },
  );

  return v2ray..initialize();
});

final configsPingProvider = StateProvider<Map<String, int>>((ref) {
  return {};
});

final selectedConfigPingProvider = StateProvider<int?>((ref) {
  return null;
});
