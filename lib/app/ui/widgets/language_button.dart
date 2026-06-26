import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;
  const LanguageButton({super.key, required this.label, required this.isActive, required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final activeBg = isDark ? Colors.white : Colors.black;
    final activeText = isDark ? Colors.black : Colors.white;
    final inactiveBg = isDark ? const Color(0xFF24272C) : const Color(0xFFF5F5F5);
    final inactiveText = isDark ? const Color(0xFFA3A39E) : const Color(0xFF666666);
    final borderColor = isDark ? const Color(0x0C0FFFFF) : const Color(0xFFE5E5E5);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: isActive ? activeBg : inactiveBg, borderRadius: BorderRadius.circular(4), border: Border.all(color: borderColor)),
        child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isActive ? activeText : inactiveText)),
      ),
    );
  }
}