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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(children: [
                GalaxyTunnelBrandText(fontSize: 24, isDark: isDark),
                const SizedBox(height: 4),
                Text('Secure VPN Connection', style: TextStyle(fontSize: 12, color: textSecondary)),
              ]),
            ),
            const SizedBox(height: 20),
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: borderColor)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('ENGINE CONTROL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: textSecondary, letterSpacing: 1.5)),
                    const SizedBox(height: 20),
                    ConnectionToggle(
                      onToggle: () {
                        final currentState = ref.read(vpnStateProvider);
                        if (currentState == VpnState.disconnected) {
                          ref.read(vpnStateProvider.notifier).state = VpnState.connecting;
                          Future.delayed(const Duration(seconds: 2), () {
                            ref.read(vpnStateProvider.notifier).state = VpnState.connected;
                          });
                        } else {
                          ref.read(vpnStateProvider.notifier).state = VpnState.disconnected;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Text('SELECTED SERVER', style: TextStyle(fontSize: 9, color: textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(height: 2),
                    Text(servers.isNotEmpty ? servers[selectedIndex].name : 'No Node Selected', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (isConnected) ...[
                      const SizedBox(height: 16),
                      Divider(color: borderColor),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        Column(children: [
                          Text('DURATION', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: textSecondary)),
                          Text(AppUtils.formatDuration(duration), style: TextStyle(fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: textPrimary)),
                        ]),
                        Column(children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.arrow_downward, size: 10, color: AppColors.greenOnline), const SizedBox(width: 3), Text('DL', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.greenOnline))]),
                          Text(dlSpeed, style: TextStyle(fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: textPrimary)),
                        ]),
                        Column(children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.arrow_upward, size: 10, color: AppColors.blueUpload), const SizedBox(width: 3), Text('UL', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.blueUpload))],
                          Text(ulSpeed, style: TextStyle(fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: textPrimary)),
                        ]),
                      ]),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildServerList(context, ref, isDark, cardColor, borderColor, textPrimary, textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildServerList(BuildContext context, WidgetRef ref, bool isDark, Color cardColor, Color borderColor, Color textPrimary, Color textSecondary) {
    final servers = ref.watch(serversProvider);
    final selectedIndex = ref.watch(selectedServerIndexProvider);
    return Column(children: [
      Row(children: [
        Expanded(child: Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor)), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(children: [Icon(Icons.expand_more, size: 20, color: textPrimary), const SizedBox(width: 6), Expanded(child: Text('Server List', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary))), Text('(${servers.length})', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textSecondary)), IconButton(onPressed: () {}, icon: Icon(Icons.refresh, size: 14, color: textSecondary), padding: EdgeInsets.zero)]) ))),
        const SizedBox(width: 8),
        Container(width: 46, height: 46, decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)), child: IconButton(onPressed: () {}, icon: Icon(Icons.add_link, size: 20, color: textPrimary))),
      ]),
      const SizedBox(height: 8),
      ...servers.asMap().entries.map((entry) => Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: entry.key == selectedIndex ? textPrimary.withOpacity(0.4) : borderColor)), margin: const EdgeInsets.only(bottom: 4), child: InkWell(onTap: () => ref.read(selectedServerIndexProvider.notifier).state = entry.key, borderRadius: BorderRadius.circular(10), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: entry.key == selectedIndex ? textPrimary : Colors.transparent, border: Border.all(color: entry.key == selectedIndex ? textPrimary : textSecondary, width: 1.2))), const SizedBox(width: 10), Expanded(child: Text(entry.value.name, style: TextStyle(fontSize: 13, fontWeight: entry.key == selectedIndex ? FontWeight.w900 : FontWeight.bold, color: textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis)), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: BoxDecoration(color: entry.value.isOffline ? Colors.transparent : AppColors.greenOnline.withOpacity(0.13), borderRadius: BorderRadius.circular(4), border: Border.all(color: entry.value.isChecking ? borderColor : entry.value.isOffline ? AppColors.redOffline : AppColors.greenOnline)), child: entry.value.isChecking ? SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 1.5, color: textSecondary)) : entry.value.isOffline ? Text('OFFLINE', style: TextStyle(fontSize: 9, color: AppColors.redOffline, fontWeight: FontWeight.bold)) : Text('${entry.value.latencyMs ? 0} ms', style: TextStyle(fontSize: 9, color: AppColors.greenOnline, fontWeight: FontWeight.bold))))]))))).toList(),
    ]);
  }
}