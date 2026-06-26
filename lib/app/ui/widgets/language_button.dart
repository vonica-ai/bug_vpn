import 'package:flutter/material.dart';
import '../../shared/theme/colors.dart';

class LanguageButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;
  const LanguageButton({super.key, required this.label, required this.isActive, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? (isDark ? Colors.white : Colors.black) : (isDark ? const Color(0xFF24272C) : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFE5E5E5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? (isDark ? Colors.black : Colors.white) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}