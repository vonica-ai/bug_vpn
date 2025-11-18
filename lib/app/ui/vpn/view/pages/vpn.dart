import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';

import '../../../../shared/utils/utils.dart';
import '../../../home/view/pages/about.dart';
import '../widgets/connection_button.dart';
import '../widgets/selected_config_card.dart';
import '../widgets/status_info.dart';
import '../widgets/usage_status_cards.dart';

class VpnPage extends ConsumerWidget {
  const VpnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(AppUtils.appLabel),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const AboutPage(),
            ),
            icon: Icon(UIcons.solidRounded.question),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.scale(
              scale: 1.5,
              child: Transform.rotate(
                angle: 360 / 5,
                alignment: Alignment.center,
                child: const GridPaper(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withAlpha(0),
                  ],
                  stops: const [0.1, 0.4],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: kToolbarHeight + MediaQuery.paddingOf(context).top,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: StatusInfo(),
                  ),
                  Expanded(
                    flex: 1,
                    child: ConnectionButton(),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Spacer(flex: 2),
                        UsageStatusCards(),
                        Spacer(flex: 2),
                        SelectedConfigCard(),
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
