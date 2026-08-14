import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsentViewModel extends Notifier<bool> {
  @override
  bool build() => false;

  void setAcknowledged(bool value) {
    state = value;
  }
}

final consentViewModelProvider =
    NotifierProvider<ConsentViewModel, bool>(ConsentViewModel.new);
