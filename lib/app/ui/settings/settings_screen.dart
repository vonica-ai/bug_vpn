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
    return Scaffold(BackgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground, body: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [Center(child: Column(children: [Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary)), Text('Customize your experience', style: TextStyle(fontSize: 12, color: textSecondary))])), const SizedBox(height: 20)]) );
  } }