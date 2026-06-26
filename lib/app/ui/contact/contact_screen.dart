import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/colors.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    return SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
      Center(child: Column(children: [
        Text('Contact', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary)),
        const SizedBox(height: 4),
        Text('Get in touch with us', style: TextStyle(fontSize: 12, color: textSecondary)),
      ])),
      const SizedBox(height: 20),
      _ContactItem(label: 'TELEGRAM', value: '@Swnt7771', icon: Icons.send, cardColor: cardColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary),
      const SizedBox(height: 12),
      _ContactItem(label: 'FACEBOOK', value: 'Sal W Tun', icon: Icons.share, cardColor: cardColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary),
      const SizedBox(height: 12),
      _ContactItem(label: 'PHONE', value: '09674688300', icon: Icons.phone, cardColor: cardColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary),
      const SizedBox(height: 12),
      _ContactItem(label: 'ADDRESS', value: 'Thin Gun Nyi Naung, Myawaddy', icon: Icons.place, cardColor: cardColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary),
      const Spacer(),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, height: 48, child: FilledButton.icon(onPressed: (){}, icon: const Icon(Icons.map, size: 18), label: const Text('Open in Maps', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), style: FilledButton.styleFrom(backgroundColor: textPrimary, foregroundColor: isDark ? Colors.white : Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),
    ]));
  }
}

class _ContactItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color cardColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  const _ContactItem({required this.label, required this.value, required this.icon, required this.cardColor, required this.borderColor, required this.textPrimary, required this.textSecondary});
  @override
  Widget build(BuildContext context) {
    return Card(color: cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: borderColor)), elevation: 0, child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor)), child: Icon(icon, size: 16, color: textPrimary)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondary)), Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary))]),
    ])));
  }
}