import 'dart:async';
import 'package:flutter/material.dart';

/// Prevents UI flicker by delaying the rendering of loading spinners/skeletons.
///
/// If a request completes in under [delay] (default 250ms), the user never
/// sees a flash of loading state. If it takes longer, the loading state
/// smoothly fades in.
class DelayedLoader extends StatefulWidget {
  const DelayedLoader({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 250),
  });

  final Widget child;
  final Duration delay;

  @override
  State<DelayedLoader> createState() => _DelayedLoaderState();
}

class _DelayedLoaderState extends State<DelayedLoader> {
  bool _show = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) {
        setState(() => _show = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) {
      return const SizedBox.shrink();
    }
    return AnimatedOpacity(
      opacity: _show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 150),
      child: widget.child,
    );
  }
}
