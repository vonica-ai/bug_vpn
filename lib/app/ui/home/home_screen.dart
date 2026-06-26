import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/colors.dart';
import '../../shared/providers/vpn_provider.dart';
import '../../shared/utils/utils.dart';
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

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [Center(child: Column(children: [GalaxyTunnelBrandText(fontSize: 24, isDark: isDark), Text('Secure VPN Connection', style: TextStyle(fontSize: 12, color: textSecondary))])), const SizedBox(height: 20), Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: borderColor)), child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [Text('ENGINE CONTROL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: textSecondary, letterSpacing: 1.5)), ConnectionToggle(onToggle: () {
            final currentState = ref.read(vpnStateProvider);
            if (currentState == VpnState.disconnected) {
              ref.read(vpnStateProvider.notifier).state = VpnState.connecting;
              Future.delayed(const Duration(seconds: 2), () {
                ref.read(vpnStateProvider.notifier).state = VpnState.connected;
              });
            } else {
              ref.read(vpnStateProvider.notifier).state = VpnState.disconnected;
            }
          }), Text(servers.isNotEmpty ? servers[selectedIndex].name : 'No Node Selected', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textPrimary), if (isConnected) Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Text('DURATION: ${AppUtils.formatDuration(duration)}', style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: textPrimary)), Text('DL: ${dlSpeed}', style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: textPrimary)), Text('UL: ${ulSpeed}', style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: textPrimary))])]))), _buildServerList(context, ref, isDark, cardColor, borderColor, textPrimary, textSecondary)])),
    );
  }
  Widget _buildServerList(BuildContext context, WidgetRef ref, bool isDark, Color cardColor, Color borderColor, Color textPrimary, Color textSecondary) {
    final servers = ref.watch(serversProvider);
    final selectedIndex = ref.watch(selectedServerIndexProvider);
    return Column(children: [Row(children: [Expanded(child: Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor)), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(children: [Icon(Icons.expand_more, size: 20, color: textPrimary), Text('Server List (${servers.length})', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary))])))), Container(width: 46, height: 46, decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor), child: IconButton(onPressed: () {}, icon: Icon(Icons.add_link, size: 20, color: textPrimary)))}, const SizedBox(height: 8),...servers.asMap().entries.map((e) {
        final idx = e.key;
        final isActive = idx == selectedIndex;
        return Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: isActive ? textPrimary.withOpacity(0.4) : borderColor)), margin: const EdgeInsets.only(bottom: 4), child: InkWell(onTap: () => ref.read(selectedServerIndexProvider.notifier).state = idx, borderRadius: BorderRadius.circular(10), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? textPrimary : Colors.transparent, border: Border.all(color: isActive ? textPrimary : textSecondary, width: 1.2))), Text(e.value.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary))]))));
      }))]);
  }
}