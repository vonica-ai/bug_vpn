import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/colors.dart';
import '../../shared/providers/vpn_provider.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(children: [
                Text('Contact', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary)),
                Text('Get in touch with us', style: TextStyle(fontSize: 12, color: textSecondary)),
              ]),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}