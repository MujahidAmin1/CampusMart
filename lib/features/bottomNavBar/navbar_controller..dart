
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var currentScreenProvider = StateProvider.autoDispose<int?>(
 (ref) => 0
);

 navigateTo(WidgetRef ref, int screen) {
  if (screen != ref.watch(currentScreenProvider)) {
    ref.read(currentScreenProvider.notifier).state = screen;
  }
}

