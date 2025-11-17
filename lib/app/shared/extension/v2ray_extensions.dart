import 'package:flutter_v2ray_client/flutter_v2ray.dart';

extension V2RayStatusExtension on V2RayStatus {
  bool get isConnected => state == 'CONNECTED';
}

extension FlutterV2rayExtension on V2ray {
  Future<int> getDelayWithTimeout(String config, {int seconds = 5}) =>
      getServerDelay(config: config).timeout(
        const Duration(seconds: 5),
        onTimeout: () => -1,
      );
}
