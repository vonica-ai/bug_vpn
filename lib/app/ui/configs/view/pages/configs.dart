// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uicons/uicons.dart';

import '../../../../shared/extension/extensions.dart';
import '../../../../shared/extension/v2ray_extensions.dart';
import '../../../../shared/preferences/preferences.dart';
import '../../../../shared/utils/utils.dart';
import '../../../vpn/view/providers/v2ray_provider.dart';
import '../../data/models/config_model.dart';
import '../providers/configs_provider.dart';
import '../widgets/config_card.dart';
import '../widgets/config_error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/tab_bar_card.dart';

class ConfigsPage extends ConsumerWidget {
  const ConfigsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v2ray = ref.watch(v2rayProvider);
    final provider = ref.watch(configsProvider);
    final configsPing = ref.watch(configsPingProvider);
    final selectedConfig = ref.watch(selectedConfigProvider);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('All Configs'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(configsProvider),
            icon: Icon(UIcons.regularRounded.refresh),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: provider.when(
        skipError: false,
        skipLoadingOnRefresh: false,
        skipLoadingOnReload: false,
        data: (configs) {
          final collections = configs.groupBy((config) => AppUtils.parseConfigType(config.url));
          final types = collections.keys.toList()..sort();
          return DefaultTabController(
            length: types.length,
            child: Column(
              children: [
                Animate(
                  effects: const [
                    FadeEffect(),
                    SlideEffect(begin: Offset(0, -0.1)),
                  ],
                  child: Row(
                    children: [Expanded(child: TabBarCard(types: types))],
                  ),
                ),
                Expanded(
                  child: Animate(
                    effects: const [
                      FadeEffect(),
                      SlideEffect(begin: Offset(0, 0.1)),
                    ],
                    child: TabBarView(
                      children: [
                        ...types.map(
                          (type) => ListView.separated(
                            itemCount: collections[type]!.length,
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final config = collections[type]!.elementAt(index);
                              final isSelected = selectedConfig?.v2rayURL.url == config.url;
                              return ConfigCard(
                                config: config,
                                isSelected: isSelected,
                                index: index,
                                type: type,
                                configsPing: configsPing,
                                onPing: () => _getDelay(context, v2ray, config, ref),
                                onTap: () async {
                                  await v2ray.stopV2Ray();
                                  if (!context.mounted) return;
                                  await _getDelay(context, v2ray, config, ref);
                                  ref
                                      .read(selectedConfigPingProvider.notifier)
                                      .update((_) => configsPing[config.url]);
                                  ref
                                      .read(selectedConfigProvider.notifier)
                                      .update(
                                        ConfigModel(
                                          ping: configsPing[config.url],
                                          name: '${type.toUpperCase()} ${index + 1}',
                                          type: type,
                                          v2rayURL: config,
                                        ),
                                      );
                                  Preferences.instance.saveConfig(
                                    ConfigModel(
                                      ping: configsPing[config.url],
                                      name: '${type.toUpperCase()} ${index + 1}',
                                      type: type,
                                      v2rayURL: config,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) =>
            ConfigErrorWidget(onError: () => ref.invalidate(configsProvider)),
        loading: () => const LoadingWidget(),
      ),
    );
  }

  Future<void> _getDelay(BuildContext context, V2ray v2ray, V2RayURL config, WidgetRef ref) async {
    context.loaderOverlay.show();
    try {
      final ping = await v2ray.getDelayWithTimeout(config.getFullConfiguration());

      ref
          .read(configsPingProvider.notifier)
          .update(
            (state) => {
              ...state,
              ...{config.url: ping},
            },
          );
    } catch (e) {
      log(e.toString());
      AppUtils.configNotAvailableToast();
    }
    if (context.mounted) context.loaderOverlay.hide();
  }
}
