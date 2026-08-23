import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_error_view.dart';
import 'loading_indicator.dart';

/// Uniform loading/data/error rendering for any [AsyncValue] per §8, so no
/// screen hand-rolls its own `.when(...)` branches.
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.skeleton,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final Widget? skeleton;
  final Widget Function()? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => skeleton ?? loading?.call() ?? const LoadingIndicator(),
      error: (error, _) => AppErrorView(message: error.toString(), onRetry: onRetry),
    );
  }
}
