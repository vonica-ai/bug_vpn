import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavIndexProvider = NotifierProvider.autoDispose<BottomNavIndexNotifier, int>(
  BottomNavIndexNotifier.new,
);

class BottomNavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  update(int index) {
    state = index;
  }
}
