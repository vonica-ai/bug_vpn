import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/colors.dart';
import '../../shared/providers/vpn_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final t1 = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final t2 = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final isDarkMode = ref.watch(isDarkModeProvider);
    final textSize = ref.watch(textSizeProvider);
    final logs = ref.watch(logsProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(children: [
              Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: t1)),
              const SizedBox(height: 4),
              Text('Customize your experience', style: TextStyle(fontSize: 12, color: t2)),
            ]),
          ),
          const SizedBox(height: 20),
          // Theme Card
          Card(
            color: card,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: border)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.palette, size: 18, color: t1),
                    const SizedBox(width: 6),
                    Text('Theme', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: t1)),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: _buildThemeButton(
                        'Light', Icons.light_mode, !isDarkMode, isDark,
                        () => ref.read(isDarkModeProvider.notifier).state = false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildThemeButton(
                        'Dark', Icons.dark_mode, isDarkMode, isDark,
                        () => ref.read(isDarkModeProvider.notifier).state = true,
                      ),
                    ),
                  ])),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Text Size Card
          Card(
            color: card,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: border)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.format_size, size: 18, color: t1),
                    const SizedBox(width: 6),
                    Text('Text Size', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: t1)),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    for (final s in ['small', 'medium', 'large'])
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: GestureDetector(
                            onTap: () => ref.read(textSizeProvider.notifier).state = s,
                            child: Container(
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: textSize == s ? t1 : (isDark ? const Color(0xFF1E1E1C) : const Color(0xFFE5E5E5)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                s[0].toUpperCase() + s.substring(1),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: textSize == s ? (isDark ? const Color(0xFF14171B) : Colors.white) : t1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Share Card
          Card(
            color: card,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: border)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.share, size: 18, color: t1),
                    const SizedBox(width: 8),
                    Text('Share Galaxy Tunnel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: t1)),
                  ]),
                  const SizedBox(height: 8),
                  Text('Share with friends and family', style: TextStyle(fontSize: 11, color: t2)),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.qr_code_scanner, size: 16, color: t1),
                      label: Text('Share Now', style: TextStyle(color: t1, fontWeight: FontWeight.bold)),
                      style: FilledButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF2A2B30) : const Color(0xFFE5E5E5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Logs Card
          Card(
            color: card,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: border)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.terminal, size: 20, color: t1),
                    const SizedBox(width: 6),
                    Expanded(child: Text('Diagnostics & Logs', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: t1))),
                    Text('[${logs.length}]', style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: t2, fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 10),
                  if (logs.isNotEmpty) ...[
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F1115) : const Color(0xFFF9F9FA),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: border),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: ListView(
                        children: logs.reversed.map((l) => Text(
                          l,
                          style: TextStyle(
                            fontSize: 9,
                            fontFamily: 'monospace',
                            color: l.contains('failed') || l.contains('Error')
                                ? const Color(0xFFF87171)
                                : (l.contains('success') || l.contains('established') ? const Color(0xFF34D399) : t2),
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => ref.read(logsProvider.notifier).state = [],
                          child: Container(
                            height: 34,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2A2B30) : const Color(0xFFE5E5E5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.delete_outline, size: 13, color: t1),
                              const SizedBox(width: 4),
                              Text('Clear', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: t1)),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 34,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2A2B30) : const Color(0xFFE5E5E5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.content_copy, size: 13, color: t1),
                              const SizedBox(width: 4),
                              Text('Copy', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: t1)),
                            ]),
                          ),
                        ),
                      ),
                    ]),
                  ] ELAK Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('Empty logs session.', style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: t2)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeButton(String label, IconData icon, bool isSel, bool isDark, VoidCallback onTap) {
    final bg = isSel
        ? (isDark ? Colors.white : Colors.black)
        : (isDark ? const Color(0xFF1E1E1C) : const Color(0xFFE5E5E5));
    final fg = isSel
        ? (isDark ? Colors.black : Colors.white)
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg)),
        ]),
      ),
    );
  }
}