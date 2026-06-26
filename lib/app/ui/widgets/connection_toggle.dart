import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/colors.dart';
import '../../shared/providers/vpn_provider.dart';

class ConnectionToggle extends ConsumerWidget {
  final VoidCallback onToggle;
  const ConnectionToggle({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnState = ref.watch(vpnStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isConnected = vpnState == VpnState.connected;
    final isConnecting = vpnState == VpnState.connecting;
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 140, height: 56,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF14161B) : const Color(0xFFECECEC),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        padding: const EdgeInsets.all(4),
        child: Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Text('OFF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: !isConnected ? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary) : (isDark ? AppColors.darkTextSecondary.withOpacity(0.3) : AppColors.lightTextSecondary.withOpacity(0.3)))),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Text('ON', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isConnected ? AppColors.greenOnline : AppColors.greenOnline.withOpacity(0.3))),
              ),
            ],
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: isConnected ? Alignment.centerRight : isConnecting ? Alignment.center : Alignment.centerLeft,
            child: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: isConnected ? AppColors.greenOnline : isConnecting ? AppColors.orangeConnecting : isDark ? const Color(0xFF2E3238) : const Color(0xFFC5C5C2),
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2)),
              ),
              child: Center(child: isConnecting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color> Colors.wrsite)) : Icon(isConnected ? Icons.shield : Icons.power_settings_new, color: Colors.white, size: 20)),
            ),
          ),
        ]),
      ),
    );
  }
}