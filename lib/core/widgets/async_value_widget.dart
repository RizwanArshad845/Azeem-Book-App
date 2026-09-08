import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/common/failure.dart';
import 'app_error_view.dart';
import 'delayed_loader.dart';
import 'loading_indicator.dart';

/// Uniform loading/data/error rendering for any [AsyncValue] per §8.
///
/// Implements production Stale-While-Revalidate (SWR):
/// - Skips loading spinners on reload/refresh if cached data is already present.
/// - Retains and displays cached data if a background refresh fails.
/// - Uses [DelayedLoader] to prevent micro-spinners on fast network responses.
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.skeleton,
    this.loading,
    this.skipLoadingOnRefresh = true,
    this.skipLoadingOnReload = true,
    this.keepPreviousDataOnError = true,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final Widget? skeleton;
  final Widget Function()? loading;
  final bool skipLoadingOnRefresh;
  final bool skipLoadingOnReload;
  final bool keepPreviousDataOnError;

  @override
  Widget build(BuildContext context) {
    // If background refresh failed but we still have cached data, keep showing data
    if (keepPreviousDataOnError && value.hasError && value.hasValue) {
      return data(value.requireValue);
    }

    return value.when(
      // Only honor the skip-loading flags when there's cached data worth
      // not flickering away from. Riverpod's `ref.invalidate`/`ref.refresh`
      // produce a still-`AsyncError` (not `AsyncLoading`) state with
      // `isRefreshing: true` — if there's no data to fall back to instead
      // (the `keepPreviousDataOnError` branch above didn't apply), skipping
      // `loading()` here means a Retry tap re-renders the identical error
      // with zero visible change, making a genuine retry indistinguishable
      // from a dead button.
      skipLoadingOnRefresh: skipLoadingOnRefresh && value.hasValue,
      skipLoadingOnReload: skipLoadingOnReload && value.hasValue,
      data: data,
      loading: () =>
          skeleton ??
          loading?.call() ??
          const DelayedLoader(child: LoadingIndicator()),
      error: (error, _) => AppErrorView(
        message: error is Failure ? error.message : error.toString(),
        onRetry: onRetry,
        isOffline: error is NetworkFailure,
      ),
    );
  }
}
