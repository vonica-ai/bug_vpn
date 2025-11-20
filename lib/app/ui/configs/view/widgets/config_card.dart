// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';
import 'package:uicons/uicons.dart';

import '../../../../shared/theme/colors.dart';
import '../../../../shared/utils/utils.dart';

class ConfigCard extends StatelessWidget {
  final V2RayURL config;
  final bool isSelected;
  final int index;
  final String type;
  final Map<String, int> configsPing;
  final VoidCallback onPing;
  final VoidCallback onTap;
  const ConfigCard({
    super.key,
    required this.config,
    required this.isSelected,
    required this.index,
    required this.type,
    required this.configsPing,
    required this.onPing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(width: 2, color: isSelected ? AppColors.green : Colors.grey.shade300),
      ),
      margin: const EdgeInsets.all(0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSelected ? Theme.of(context).primaryColor : AppColors.red,
          child: Text('${index + 1}'),
        ),
        title: Text(config.remark, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('Network : ${config.network.toUpperCase()}'),
        titleTextStyle: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        selected: isSelected,
        contentPadding: const EdgeInsets.only(left: 16, right: 8),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (configsPing.containsKey(config.url) && configsPing[config.url]! > 0)
              Text(
                '${configsPing[config.url]} ms',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppUtils.pingColor(configsPing[config.url]!),
                ),
              ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Get config ping',
              onPressed: onPing,
              icon: Icon(UIcons.regularRounded.tachometer_fastest),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
