import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';

import '../../../../shared/extension/extensions.dart';
import '../../../../shared/extension/v2ray_extensions.dart';
import '../../../../shared/theme/colors.dart';
import '../providers/v2ray_provider.dart';
import 'usage_status_card.dart';

class UsageStatusCards extends ConsumerStatefulWidget {
  const UsageStatusCards({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UsageStatusCardsState();
}

class _UsageStatusCardsState extends ConsumerState<UsageStatusCards>
    with SingleTickerProviderStateMixin {
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
          begin: Offset(0, 0.1),
        ),
      ],
      child: Row(
        children: [
          Expanded(
            child: UsageStatusCard(
              iconColor: AppColors.blue,
              icon: UIcons.regularRounded.chevron_double_down,
              label: 'Download',
              value: status.download.formatAsBytes(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: UsageStatusCard(
              iconColor: AppColors.red,
              icon: UIcons.regularRounded.chevron_double_up,
              label: 'Upload',
              value: status.upload.formatAsBytes(),
            ),
          ),
        ],
      ),
    );
  }
}
