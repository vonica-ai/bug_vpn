import 'package:flutter/material.dart';
import '../../shared/theme/colors.dart';

class DrawerItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const DrawerItem({super.key, required this.label, required this.icon, required this.isActive, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isActive ? (isDark ? const Color(0x1F2A2A28) : const Color(0x0F000000)) : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Row(children: [
          if (isActive) ...[
            Container(width: 4, height: 24, decoration: BoxDecoration(color: textPrimary, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
          ] else
            const SizedBox(width: 16),
          Icon(icon, size: 20, color: isActive ? textPrimary : textSecondary),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? textPrimary : textSecondary)),
        ]),
      ),
    );
  }
}