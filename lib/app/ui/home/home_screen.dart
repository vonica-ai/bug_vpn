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
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final vpnState = ref.watch(vpnStateProvider);
    final servers = ref.watch(serversProvider);
    final selectedIndex = ref.watch(selectedServerIndexProvider);
    final duration = ref.watch(durationProvider);
    final dlSpeed = ref.watch(dlSpeedProvider);
    final ulSpeed = ref.watch(ulSpeedProvider);
    final isConnected = vpnState == VpnState.connected;
    final activeNode = servers.isNotEmpty ? servers[selectedIndex] : null;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(child: Column(children: [
            GalaxyTunnelBrandText(fontSize: 24, isDark: isDark),
            const SizedBox(height: 4),
            Text('Secure VPN Connection', style: TextStyle(fontSize: 12, color: textSecondary)),
          ])),
          const SizedBox(height: 20),

          // Engine Control Card
          Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: borderColor)), elevation: 0, child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
            Text('ENGINE CONTROL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: textSecondary, letterSpacing: 1.5)),
            const SizedBox(height: 20),
            ConnectionToggle(onToggle: () {
              final current = ref.read(vpnStateProvider);
              if (current == VpnState.disconnected) {
                ref.read(vpnStateProvider.notifier).state = VpnState.connecting;
                Future.delayed(const Duration(seconds: 2), () => ref.read(vpnStateProvider.notifier).state = VpnState.connected);
              } else {
                ref.read(vpnStateProvider.notifier).state = VpnState.disconnected;
              }
            }),
            const SizedBox(height: 20),
            Text('SELECTED SERVER', style: TextStyle(fontSize: 9, color: textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 2),
            Text(activeNode?.name ?? 'No Node Selected', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textPrimary)),
            if (isConnected) ...[
              const SizedBox(height: 16),
              Divider(color: borderColor),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _StatColumn('DURATION', AppUtils.formatDuration(duration), textSecondary, textPrimary),
                _StatColumn('DL', dlSpeed, AppColors.greenOnline, textPrimary, icon: Icons.arrow_downward, iconColor: AppColors.greenOnline),
                _StatColumn('UL', ulSpeed, AppColors.blueUpload, textPrimary, icon: Icons.arrow_upward, iconColor: AppColors.blueUpload),
              ]),
            ],
          ]))),
          const SizedBox(height: 16),

          // Server List Header
          Row(children: [
            Expanded(child: Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor)), elevation: 0, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(children: [
              Icon(Icons.expand_more, size: 20, color: textPrimary), const SizedBox(width: 6),
              Text('Server List', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary)),
              const Spacer(),
              Text('(${servers.length})', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textSecondary)),
            ])))),
            const SizedBox(width: 8),
            Container(width: 46, height: 46, decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)), child: IconButton(onPressed: (){}, icon: Icon(Icons.add_link, size: 20, color: textPrimary), padding: EdgeInsets.zero)),
          ]),
          const SizedBox(height: 8),

          // Server Items
          ...servers.asMap().entries.map((e) {
            final idx = e.key;
            final node = e.value;
            final isActive = idx == selectedIndex;
            final cardBorderColor = isActive ? textPrimary.withOpacity(0.4) : borderColor;
            return Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: cardBorderColor)), margin: const EdgeInsets.only(bottom: 4), elevation: 0, child: InkWell(onTap: () => ref.read(selectedServerIndexProvider.notifier).state = idx, borderRadius: BorderRadius.circular(10), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? textPrimary : Colors.transparent, border: Border.all(color: isActive ? textPrimary : textSecondary, width: 1.2))),
              const SizedBox(width: 10),
              Expanded(child: Text(node.name, style: TextStyle(fontSize: 13, fontWeight: isActive ? FontWeight.w900 : FontWeight.bold, color: textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis)),
              _PingStatus(node: node, borderColor: borderColor, textSecondary: textSecondary),
            ]))));
          }),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final IconData? icon;
  final Color? iconColor;
  const _StatColumn(this.label, this.value, this.labelColor, this.valueColor, {this.icon, this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (icon != null) Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 10, color: iconColor ?? labelColor), const SizedBox(width: 3), Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: labelColor))])
      else Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: labelColor)),
      const SizedBox(height: 2),
      Text(value, style: TextStyle(fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: valueColor)),
    ]);
  }
}

class _PingStatus extends StatelessWidget {
  final VpnNode node;
  final Color borderColor;
  final Color textSecondary;
  const _PingStatus({required this.node, required this.borderColor, required this.textSecondary});
  @override
  Widget build(BuildContext context) {
    final Color statusColor = node.isOffline ? AppColors.redOffline : AppColors.greenOnline;
    final Color bgColor = node.isOffline ? Colors.transparent : AppColors.greenOnline.withOpacity(0.13);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: node.isChecking ? Colors.transparent : bgColor, borderRadius: BorderRadius.circular(4), border: Border.all(color: node.isChecking ? borderColor : statusColor)),
      child: node.isChecking
          ? Row(mainAxisSize: MainAxisSize.min, children: [SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 1.5, color: textSecondary)), const SizedBox(width: 4), Text('CHECKING', style: TextStyle(fontSize: 9, color: textSecondary, fontWeight: FontWeight.bold))])
          : Text(node.isOffline ? 'OFFLINE' : '${node.latencyMs ?? 0} ms', style: TextStyle(fontSize: 9, color: statusColor, fontWeight: FontWeight.bold)),
    );
  }
}
