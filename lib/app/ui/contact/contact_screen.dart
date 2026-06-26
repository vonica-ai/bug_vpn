import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/colors.dart';
import '../../shared/providers/vpn_provider.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  Text('Contact', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary)),
                  Text('Get in touch with us', style: TextStyle(fontSize: 12, color: textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildContactItem(label: 'Telegram', value: '@Swnt7771', icon: Icons.send, cardColor: cardColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary, onTap: () {}),
            const SizedBox(height: 12),
            _buildContactItem(label: 'Facebook', value: 'Sal W Tun', icon: Icons.share, cardColor: cardColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary, onTap: () {}),
            const SizedBox(height: 12),
            _buildContactItem(label: 'Phone', value: '09674688300', icon: Icons.phone, cardColor: cardColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary, onTap: () {}),
            const SizedBox(height: 12),
            _buildContactItem(label: 'Address', value: 'Thin Gun Nyi Naung, Myawaddy', icon: Icons.place, cardColor: cardColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary, onTap: () {}),
            const Spacer(),
            const SizedBox(height: 20),
            SizedBox(width: double.inbinity, height: 48, child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.map, size: 18), label: const Text('Open in Maps', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), style: FilledButton.styleFrom(backgroundColor: textPrimary, foregroundColor: isDark ? Colors.white : Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required String label,
    required String value,
    required IconData icon,
    required Color cardColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required VoidCallback onTap,
  }) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: borderColor)),
      elevation: 0,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(8), child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor)), child: Icon(icon, size: 16, color: textPrimary)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondary)), Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary))]))]))),
    );
  }
}