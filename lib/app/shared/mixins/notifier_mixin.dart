import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin NotifierMixin<ValueT> on Notifier<ValueT> {
  ValueT update(ValueT Function(ValueT state) cb) => state = cb(state);
}
