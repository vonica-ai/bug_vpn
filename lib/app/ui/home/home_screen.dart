import '../../shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/colors.dart';
import '../../shared/providers/vpn_provider.dart';
import '../widgets/brand_text.dart';
import '../widgets/connection_toggle.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final t1 = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final t2 = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final vpn = ref.watch(vpnStateProvider);
    final servers = ref.watch(serversProvider);
    final idx = ref.watch(selectedServerIndexProvider);
    final dur = ref.watch(durationProvider);
    final dl = ref.watch(dlSpeedProvider);
    final ul = ref.watch(ulSpeedProvider);
    final connected = vpn == VpnState.connected;
    final active = servers.isNotEmpty ? servers[idx] : null;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                GalaxyTunnelBrandText(fontSize: 24, isDark: isDark),
                const SizedBox(height: 4),
                Text('Secure VPN Connection', style: TextStyle(fontSize: 12, color: t2)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Engine Card
          Card(
            color: card,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: border)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('ENGINE CONTROL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: t2, letterSpacing: 1.5)),
                  const SizedBox(height: 20),
                  ConnectionToggle(onToggle: () {
                    final cur = ref.read(vpnStateProvider);
                    if (cur == VpnState.disconnected) {
                      ref.read(vpnStateProvider.notifier).state = VpnState.connecting;
                      Future.delayed(const Duration(seconds: 2), () => ref.read(vpnStateProvider.notifier).state = VpnState.connected);
                    } else {
                      ref.read(vpnStateProvider.notifier).state = VpnState.disconnected;
                    }
                  }),
                  const SizedBox(height: 20),
                  Text('SELECTED SERVER', style: TextStyle(fontSize: 9, color: t2, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 2),
                  Text(active?.name ?? 'No Node Selected', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: t1)),
                  if (connected) ...[
                    const SizedBox(height: 16),
                    Divider(color: border),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatCol('DURATION', AppUtils.formatDuration(dur), t2, t1),
                        _StatCol('DL', dl, AppColors.greenOnline, t1, icon: Icons.arrow_downward, iconColor: AppColors.greenOnline),
                        _StatCol('UL', ul, AppColors.blueUpload, t1, icon: Icons.arrow_upward, iconColor: AppColors.blueUpload),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Server Header
          Row(
            children: [
              Expanded(
                child: Card(
                  color: card,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: border)),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.expand_more, size: 20, color: t1),
                        const SizedBox(width: 6),
                        Text('Server List', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: t1)),
                        const Spacer(),
                        Text('(${servers.length})', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: t2)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
                child: IconButton(onPressed: () {}, icon: Icon(Icons.add_link, size: 20, color: t1), padding: EdgeInsets.zero),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Server Items
          for (var entry in servers.asMap().entries)
            Card(
              color: card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: entry.key == idx ? t1.withOpacity(0.4) : border),
              ),
              margin: const EdgeInsets.only(bottom: 4),
              elevation: 0,
              child: InkWell(
                onTap: () => ref.read(selectedServerIndexProvider.notifier).state = entry.key,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: entry.key == idx ? t1 : Colors.transparent,
                          border: Border.all(color: entry.key == idx ? t1 : t2, width: 1.2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.value.name,
                          style: TextStyle(fontSize: 13, fontWeight: entry.key == idx ? FontWeight.w900 : FontWeight.bold, color: t1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildPingBadge(entry.value, border, t2),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPingBadge(VpnNode node, Color borderColor, Color textSecondary) {
    final statusColor = node.isOffline ? AppColors.redOffline : AppColors.greenOnline;
    final bgColor = node.isOffline ? Colors.transparent : AppColors.greenOnline.withOpacity(0.13);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: node.isChecking ? Colors.transparent : bgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: node.isChecking ? borderColor : statusColor),
      ),
      child: node.isChecking
          ? Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 1.5, color: textSecondary)),
              const SizedBox(width: 4),
              Text('CHECKING', style: TextStyle(fontSize: 9, color: textSecondary, fontWeight: FontWeight.bold)),
            ])
          : Text(node.isOffline ? 'OFFLINE' : '${node.latencyMs ?? 0} ms',
              style: TextStyle(fontSize: 9, color: statusColor, fontWeight: FontWeight.bold)),
    );
  }
}

class _StatCol extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final IconData? icon;
  final Color? iconColor;
  const _StatCol(this.label, this.value, this.labelColor, this.valueColor, {this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null)
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 10, color: iconColor ?? labelColor),
            const SizedBox(width: 3),
            Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: labelColor)),
          ])
        else
          Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: labelColor)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }
}