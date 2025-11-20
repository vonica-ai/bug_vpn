import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_v2ray_client/url/url.dart';

import '../../data/models/config_model.dart';
import '../../data/repository/configs_repository.dart';
import '../../data/source/remote/remote_data_source.dart';

final configsProvider = FutureProvider<Iterable<V2RayURL>>((ref) async {
  return ConfigsRepository(RemoteDataSource()).getConfigs();
});

final selectedConfigProvider = NotifierProvider<SelectedConfigNotifier, ConfigModel?>(
  SelectedConfigNotifier.new,
);

class SelectedConfigNotifier extends Notifier<ConfigModel?> {
  @override
  ConfigModel? build() => null;

  update(ConfigModel? config) {
    state = config;
  }
}
