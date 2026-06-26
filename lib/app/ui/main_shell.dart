import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/theme/colors.dart';
import '../shared/providers/vpn_provider.dart';
import '../shared/theme/app_theme_provider.dart';
import 'home/home_screen.dart';
import 'settings/settings_screen.dart';
import 'contact/contact_screen.dart';
import 'widgets/brand_text.dart';
import 'widgets/drawer_item.dart';
import 'widgets/language_button.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});
  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;
  final _screens = const [HomeScreen(), SettingsScreen(), ContactScreen()];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final language = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Divider(color: borderColor, height: 1)), title: GalaxyTunnelBrandText(fontSize: 16, isDark: isDark), actions: [Row(children: [LanguageButton(label: 'MY', isActive: language == 'my', isDark: isDark, onTap: () => ref.read(languageProvider.notifier).state = 'my'), const SizedBox(width: 4), LanguageButton(label: 'EN', isActive: language == 'en', isDark: isDark, onTap: () => ref.read(languageProvider.notifier).state = 'en'), const SizedBox(width: 8)])]),
      drawer: Drawer(child: Column(children: [Container(padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20), child: GalaxyTunnelBrandText(fontSize: 18, isDark: isDark)), Divider(color: borderColor), ])),
      body: _screens[_currentIndex],
    );
  }
}