import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';

import '../../../../shared/mixins/notifier_mixin.dart';

final v2rayProvider = Provider<V2ray>((ref) {
  final v2ray = V2ray(
    onStatusChanged: (status) {
      ref
          .read(v2RayStatusProvider.notifier)
          .update(
            (_) => V2RayStatus(
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

  // ref.read(ccProvider.notifier).update(cb)

  return v2ray..initialize();
});

final v2RayStatusProvider = NotifierProvider<V2RayStatusNotifier, V2RayStatus>(
  V2RayStatusNotifier.new,
);

class V2RayStatusNotifier extends Notifier<V2RayStatus> with NotifierMixin {
  @override
  V2RayStatus build() => V2RayStatus();
}

final configsPingProvider = NotifierProvider<ConfigsPingNotifier, Map<String, int>>(
  ConfigsPingNotifier.new,
);

class ConfigsPingNotifier extends Notifier<Map<String, int>> with NotifierMixin {
  @override
  Map<String, int> build() => {};
}

final selectedConfigPingProvider = NotifierProvider<SelectedConfigPingNotifier, int?>(
  SelectedConfigPingNotifier.new,
);

class SelectedConfigPingNotifier extends Notifier<int?> with NotifierMixin {
  @override
  int? build() => null;
}
