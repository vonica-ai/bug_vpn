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
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(16), children: [
            Center(child: Column(children: [
              Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary)),
              Text('Customize your experience', style: TextStyle(fontSize: 12, color: textSecondary)),
            ]),
            ),
            const SizedBox(height: 20),
            _buildCard(isDark: isDark, cardColor: cardColor, borderColor: borderColor, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.palette, size: 18, color: textPrimary), const SizedBox(width: 6), Text('Theme', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary))]),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _buildThemeButton(label: 'Light', icon: Icons.light_mode, isSelected: !isDarkMode, isDark: isDark, onTap: () { ref.read(themeModeProvider.notifier).state = ThemeMode.light; })),
                const SizedBox(width: 8),
                Expanded(child: _buildThemeButton(label: 'Dark', icon: Icons.dark_mode, isSelected: isDarkMode, isDark: isDark, onTap: () { ref.read(themeModeProvider.notifier).state = ThemeMode.dark; })),
              ]),
            ]),
            ),
            const SizedBox(height: 16),
            _buildCard(isDark: isDark, cardColor: cardColor, borderColor: borderColor, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.format_size, size: 18, color: textPrimary), const SizedBox(width: 6), Text('Text Size', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary))]),
              const SizedBox(height: 8),
              Row(children: ['small', 'medium', 'large'].map((size) {
                final isSel = textSize == size;
                final label = size[0].toUpperCase() + size.substring(1);
                return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: _buildSizeButton(label: label, isSelected: isSel, isDark: isDark, onTap: () { ref.read(textSizeProvider.notifier).state = size; })));
              }).toList(),
              ),
            ]),
            ),
            const SizedBox(height: 16),
            _buildCard(isDark: isDark, cardColor: cardColor, borderColor: borderColor, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.share, size: 18, color: textPrimary), const SizedBox(width: 8), Text('Share Galaxy Tunnel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary))]),
              const SizedBox(height: 8),
              Text('Share with friends and family', style: TextStyle(fontSize: 11, color: textSecondary)),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () {}, icon: Icon(Icons.qr_code_scanner, size: 16, color: textPrimary), label: Text('Share Now', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)), style: FilledButton.styleFrom(backgroundColor: isDark ? const Color(0xFF2A2B30) : const Color(0xFFE5E5E5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
            ]),
            ),
            const SizedBox(height: 16),
            _buildCard(isDark: isDark, cardColor: cardColor, borderColor: borderColor, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(logs.isNotEmpty ? Icons.expand_more : Icons.navigate_next, size: 20, color: textPrimary), const SizedBox(width: 6), Text('Diagnostics & Logs', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)), const Spacer(), Text('[${logs.length}]', style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: textSecondary, fontWeight: FontWeight.bold))])],),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCard({required bool isDark, required Color cardColor, required Color borderColor, required Widget child}) => Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor)), elevation: 0, child: Padding(padding: const EdgeInsets.all(16), child: child));
  Widget _buildThemeButton({required String label, required IconData icon, required bool isSelected, required bool isDark, required VoidCallback onTap}) => GestureDetector(onTap: onTap, child: Container(height: 38, decoration: BoxDecoration(color: isSelected ? (isDark ? Colors.white : Colors.black) : (isDark ? const Color(0xFF1E1E1C) : const Color(0xFFE5E5E5)), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 14, color: isSelected ? (isDark ? Colors.black : Colors.white) : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)), const SizedBox(width: 6), Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? (isDark ? Colors.black : Colors.white) : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)))]));
  Widget _buildSizeButton({required String label, required bool isSelected, required bool isDark, required VoidCallback onTap}) => GestureDetector(onTap: onTap, child: Container(height: 38, decoration: BoxDecoration(color: isSelected ? (isDark ? Colors.white : Colors.black) : (isDark ? const Color(0xFF1E1E1C) : const Color(0xFFE5E5E5)), borderRadius: BorderRadius.circular(6)), alignment: Alignment.center, child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? (isDark ? Colors.black : Colors.white) : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary))));
}