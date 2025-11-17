import 'package:flutter_v2ray_client/flutter_v2ray.dart';

import '../source/remote/remote_data_source.dart';

class ConfigsRepository {
  final RemoteDataSource source;

  ConfigsRepository(this.source);

  Future<Iterable<V2RayURL>> getConfigs() async {
    try {
      final data = await source.getConfigs();
      return data.where(
        (url) {
          try {
            V2ray.parseFromURL(url);
            return true;
          } catch (e) {
            return false;
          }
        },
      ).map(V2ray.parseFromURL);
    } catch (e) {
      rethrow;
    }
  }
}
