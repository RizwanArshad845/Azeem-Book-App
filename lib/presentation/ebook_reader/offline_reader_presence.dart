import 'package:flutter/foundation.dart';

/// True while the offline ebook reader is on screen. `App` hides its
/// full-screen offline overlay while this is set, since that's the one screen
/// that works with no connection. A plain notifier rather than a provider:
/// it's flipped from the reader's `initState`/`dispose` (via post-frame
/// callbacks), where Riverpod state can't be modified.
final offlineReaderOpen = ValueNotifier<bool>(false);
