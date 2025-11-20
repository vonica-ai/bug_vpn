// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [FadeEffect(), ScaleEffect()],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 4,
          backgroundColor: Colors.black12,
          strokeAlign: BorderSide.strokeAlignOutside,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
