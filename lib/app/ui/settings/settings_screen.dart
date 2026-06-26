import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/colors.dart';
import '../../shared/providers/vpn_provider.dart';
import '../../shared/theme/app_theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final isDarkMode = ref.watch(isDarkModeProvider);
    final textSize = ref.watch(textSizeProvider);
    final logs = ref.watch(logsProvider);
    return SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
      Center(child: Column(children: [
        Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary)),
        const SizedBox(height: 4),
        Text('Customize your experience', style: TextStyle(fontSize: 12, color: textSecondary)),
      ])),
      const SizedBox(height: 20),
      Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor)), elevation: 0, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(Icons.palette, size: 18, color: textPrimary), const SizedBox(width: 6), Text('Theme', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary))]),
        const SizedBox(height: 16),
        Row(children: [Expanded(child: _ThemeButton(label: 'Light', icon: Icons.light_mode, isSelected: !isDarkMode, isDark: isDark, onTap: () => ref.read(isDarkModeProvider.notifier).state = false)), const SizedBox(width: 8), Expanded(child: _ThemeButton(label: 'Dark', icon: Icons.dark_mode, isSelected: isDarkMode, isDark: isDark, onTap: () => ref.read(isDarkModeProvider.notifier).state = true))]),]))),
      const SizedBox(height: 16),
      Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor)), elevation: 0, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(Icons.format_size, size: 18, color: textPrimary), const SizedBox(width: 6), Text('Text Size', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary))]),
        const SizedBox(height: 16),
        Row(children: ['small', 'medium', 'large'].map((s) {
          final isSel = textSize == s;
          final label = s[0].toUpperCase() + s.substring(1);
          return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: GestureDetector(onTap: () => ref.read(textSizeProvider.notifier).state = s, child: Container(height: 38, alignment: Alignment.center, decoration: BoxDecoration(color: isSel ? textPrimary : (isDark ? const Color(0xFF1E1E1C) : const Color(0xFFE5E5E5)), borderRadius: BorderRadius.circular(6)), child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSel ? (isDark ? const Color(0xFF14171B) : Colors.white) : textPrimary)))));
        }).toList()),]))),
      const SizedBox(height: 16),
      Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor)), elevation: 0, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(Icons.share, size: 18, color: textPrimary), const SizedBox(width: 8), Text('Share Galaxy Tunnel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary))]), const SizedBox(height: 8), Text('Share with friends and family', style: TextStyle(fontSize: 11, color: textSecondary)), const SizedBox(height: 10), SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () {}, icon: Icon(Icons.qr_code_scanner, size: 16, color: textPrimary), label: Text('Share Now', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)), style: FilledButton.styleFrom(backgroundColor: isDark ? const Color(0xFF2A2B30) : const Color(0xFFE5E5E5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),]) ),
      const SizedBox(height: 16),
      Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor)), elevation: 0, child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(Icons.terminal, size: 20, color: textPrimary), const SizedBox(width: 6), Expanded(child: Text('Diagnostics & Logs', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary))), Text('[${logs.length}]', style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: textSecondary, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 10),
        if (logs.isNotEmpty) ...[Container(height: 160, decoration: BoxDecoration(color: isDark ? const Color(0xFF0F1115) : const Color(0xFFF9F9FA), borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor)), padding: const EdgeInsets.all(10), child: ListView(children: logs.reversed.map((l) => Text(l, style: TextStyle(fontSize: 9, fontFamily: 'monospace', color: l.contains('failed') || l.contains('Error') ? const Color(0xFFF87171) : (l.contains('success') || l.contains('established') ? const Color(0xFF34D399) : textSecondary)))).toList())),const SizedBox(height: 8), Row(children: [Expanded(child: _LogButton(label: 'Clear', icon: Icons.delete_outline, isDark: isDark, onTap: () => ref.read(logsProvider.notifier).state = [])), const SizedBox(width: 8), Expanded(child: _LogButton(label: 'Copy', icon: Icons.content_copy, isDark: isDark, onTap: () {}))])] else Padding(padding: const EdgeInsets.all(8), child: Text('Empty logs session.', style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: textSecondary)))])),
    ]));
  }
}

class _ThemeButton extends StatelessWidget {
  final String label; final IconData icon; final bool isSelected; final bool isDark; final VoidCallback onTap;
  const _ThemeButton({required this.label, required this.icon, required this.isSelected, required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? (isDark ? Colors.white : Colors.black) : (isDark ? const Color(0xFF1E1E1C) : const Color(0xFFE5E5E5));
    final fg = isSelected ? (isDark ? Colors.black : Colors.white) : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);
    return GestureDetector(onTap: onTap, child: Container(height: 38, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 14, color: fg), const SizedBox(width: 6), Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg))])));
  }
}

class _LogButton extends StatelessWidget {
  final String label; final IconData icon; final bool isDark; final VoidCallback onTap;
  const _LogButton({required this.label, required this.icon, required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(height: 34, decoration: BoxDecoration(color: isDark ? const Color(0xFF2A2B30) : const Color(0xFFE5E5E5), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary), const SizedBox(width: 4), Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary))])));
  }
}