import 'package:flutter/widgets.dart';

/// How many offline-safe screens (the downloaded-books list and the offline
/// ebook reader) are currently on screen. `App` hides its full-screen offline
/// overlay while this is above zero, since those screens work with no
/// connection. A counter (not a bool) so stacked screens — list → reader —
/// don't un-hide the overlay when only the top one closes.
///
/// A plain notifier rather than a provider: it's changed from `initState` /
/// `dispose`, where Riverpod state can't be modified.
final offlineSafeScreens = ValueNotifier<int>(0);

/// Mix into the `State` of a screen that works offline so the offline overlay
/// steps aside while it's open. Set [offlineSafe] to false to opt out (e.g.
/// the reader in streaming mode).
mixin OfflineSafeScreen<T extends StatefulWidget> on State<T> {
  bool get offlineSafe => true;

  @override
  void initState() {
    super.initState();
    // Deferred: initState runs mid-build, and the overlay listening to this
    // notifier is an ancestor — marking it dirty now would assert.
    if (offlineSafe) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => offlineSafeScreens.value++,
      );
    }
  }

  @override
  void dispose() {
    if (offlineSafe) {
      // Deferred: dispose can run during a build/finalize pass, where
      // notifying the overlay's listener would be illegal.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => offlineSafeScreens.value--,
      );
    }
    super.dispose();
  }
}
