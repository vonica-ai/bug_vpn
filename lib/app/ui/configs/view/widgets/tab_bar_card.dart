// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class TabBarCard extends StatelessWidget {
  const TabBarCard({super.key, required this.types});

  final List<String> types;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(width: 2, color: Colors.grey.shade300),
      ),
      margin: const EdgeInsets.all(16),
      child: TabBar(
        tabs: [...types.map((type) => Tab(text: type))],
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerHeight: 0,
        padding: const EdgeInsets.all(8),
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        splashBorderRadius: BorderRadius.circular(12),
        indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
