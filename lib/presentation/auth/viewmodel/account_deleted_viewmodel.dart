import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Event bus for "the backend says this account was deleted". The network
/// layer can't show UI, so `main.dart` bumps this counter (via
/// `SessionExpiryNotifier.onAccountDeleted`) and `App` listens to it to open
/// the blocking dialog on the root navigator. A counter rather than a bool so
/// two events in a row each trigger a listener callback.
class AccountDeletedEventNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void notify() => state = state + 1;
}

final accountDeletedEventProvider =
    NotifierProvider<AccountDeletedEventNotifier, int>(
      AccountDeletedEventNotifier.new,
    );
