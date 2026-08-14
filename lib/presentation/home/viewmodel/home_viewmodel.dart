import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../onboarding/viewmodel/onboarding_viewmodel.dart';

typedef HomeHeader = ({String name, String college});
final homeHeaderProvider = Provider<HomeHeader>((ref) {
  final name = ref.watch(onboardingViewModelProvider.select((s) => s.name));
  final college = ref.watch(onboardingViewModelProvider.select((s) => s.college));
  return (name: name, college: college);
});
