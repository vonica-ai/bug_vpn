import 'package:flutter/material.dart';
import '../../shared/theme/colors.dart';

class GalaxyTunnelBrandText extends StatelessWidget {
  final double fontSize;
  final bool isDark;

  const GalaxyTunnelBrandText({
    super.key,
    this.fontSize = 18,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'GALAXY ',
          style: TextStyle(
            color: primaryColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        Text(
          'TUNNEL',
          style: TextStyle(
            color: AppColors.cyanAccent,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
