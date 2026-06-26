import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vpn_node.dart';

enum VpnState { disconnected, connecting, connected }

final vpnStateProvider = StateProvider<VpnState>((ref) => VpnState.disconnected);

final serversProvider = StateProvider<List<VpnNode>>((ref) => [
  VpnNode(name: 'Singapore Premium', config: 'vless://...'),
  VpnNode(name: 'Japan Standard', config: 'vless://...'),
  VpnNode(name: 'US West', config: 'vless://...'),
  VpnNode(name: 'Germany Free', config: 'vless://...'),
]);

final selectedServerIndexProvider = StateProvider<int>((ref) => 0);

final durationProvider = StateProvider<int>((ref) => 0);

final dlSpeedProvider = StateProvider<String>((ref) => '0.0 MB/s');

final ulSpeedProvider = StateProvider<String>((ref) => '0.0 MB/s');

final logsProvider = StateProvider<List<String>>((ref) => []);

final languageProvider = StateProvider<String>((ref) => 'en');

final textSizeProvider = StateProvider<String>((ref) => 'medium');
