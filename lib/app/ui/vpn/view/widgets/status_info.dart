import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extension/v2ray_extensions.dart';
import '../providers/v2ray_provider.dart';
import 'connecting_time.dart';
import 'connection_status.dart';

class StatusInfo extends ConsumerStatefulWidget {
  const StatusInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatusInfoState();
}

class _StatusInfoState extends ConsumerState<StatusInfo> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Animate.defaultDuration);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(v2RayStatusProvider);
    ref.listen(
      v2RayStatusProvider,
      (previous, next) {
        if (previous != next) {
          if (next.isConnected) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        }
      },
    );
    return Animate(
      autoPlay: false,
      controller: _animationController,
      effects: const [
        FadeEffect(),
        SlideEffect(
          begin: Offset(0, -0.1),
        ),
      ],
      child: Column(
        children: [
          const Spacer(),
          ConnectingTime(value: status.duration),
          const Spacer(),
          ConnectionStatus(connected: status.isConnected),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
