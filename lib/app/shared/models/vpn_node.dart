class VpnNode {
  final String name;
  final String config;
  int? latencyMs;
  bool isChecking;
  bool isOffline;

  VpnNode({
    required this.name,
    required this.config,
    this.latencyMs,
    this.isChecking = false,
    this.isOffline = false,
  });
}
