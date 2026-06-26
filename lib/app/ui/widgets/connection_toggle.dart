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
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final bgColor = isDark ? const Color(0xFF14161B) : const Color(0xFFECECEC);
    final thumbColor = isConnected
        ? AppColors.greenOnline
        : isConnecting
            ? AppColors.orangeConnecting
            : (isDark ? const Color(0xFF2E3238) : const Color(0xFFC5C5C2));
    final thumbBorder = isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2);

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 140, height: 56,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(4),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Text('OFF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: textSecondary.withOpacity(isConnected ? 0.3 : 1.0))),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Text('ON', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.greenOnline.withOpacity(isConnected ? 1.0 : 0.3))),
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
                  color: thumbColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: thumbBorder),
                ),
                child: Center(
                  child: isConnecting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Icon(isConnected ? Icons.shield : Icons.power_settings_new, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}