import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../domain/catalog/entities/chapter.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../student_home/viewmodel/student_home_viewmodel.dart';

/// In-app lecture player for one chapter's YouTube video. Full-screen on top
/// of the shell (no bottom nav), with "Next chapter" and the screen's one
/// primary action: attempting this chapter's test.
class ChapterVideoView extends ConsumerWidget {
  const ChapterVideoView({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  final String subjectId;
  final String chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chaptersForSubjectProvider(subjectId));
    final isOwned = ref.watch(
      purchasedSubjectIdsProvider.select(
        (ids) => ids.value?.contains(subjectId) ?? false,
      ),
    );
    bool canWatch(Chapter c) =>
        c.youtubeUrl != null && (isOwned || c.isFreeSample);
    return AsyncValueWidget<List<Chapter>>(
      value: chaptersAsync,
      loading: () => const Scaffold(body: LoadingIndicator()),
      onRetry: () => ref.invalidate(chaptersForSubjectProvider(subjectId)),
      data: (chapters) {
        final sorted = [...chapters]..sort((a, b) => a.order.compareTo(b.order));
        final index = sorted.indexWhere((c) => c.id == chapterId);
        if (index < 0 || !canWatch(sorted[index])) {
          return Scaffold(
            appBar: AppBar(),
            body: EmptyStateView(
              icon: Icons.lock_outline_rounded,
              message: index >= 0 && sorted[index].youtubeUrl != null
                  ? context.l10n.chapterVideoLocked
                  : context.l10n.chapterVideoUnavailable,
            ),
          );
        }
        final next = sorted.skip(index + 1).where(canWatch).firstOrNull;
        return _LecturePlayer(
          // New chapter → new player.
          key: ValueKey(chapterId),
          subjectId: subjectId,
          chapter: sorted[index],
          nextChapter: next,
        );
      },
    );
  }
}

class _LecturePlayer extends StatefulWidget {
  const _LecturePlayer({
    super.key,
    required this.subjectId,
    required this.chapter,
    required this.nextChapter,
  });

  final String subjectId;
  final Chapter chapter;
  final Chapter? nextChapter;

  @override
  State<_LecturePlayer> createState() => _LecturePlayerState();
}

class _LecturePlayerState extends State<_LecturePlayer> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final url = widget.chapter.youtubeUrl;
    final videoId =
        url == null ? null : YoutubePlayerController.convertUrlToId(url);
    if (videoId != null) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showFullscreenButton: true,
          strictRelatedVideos: true,
          showVideoAnnotations: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  // Fallback for links the embed player can't parse (playlists, shorts with
  // odd params, etc.): hand off to the YouTube app as before.
  Future<void> _openExternally() async {
    final uri = Uri.tryParse(widget.chapter.youtubeUrl ?? '');
    final launched =
        uri != null && await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      AppSnackbar.show(context, context.l10n.chapterVideoOpenError);
    }
  }

  String get _testListPath => AppRoutes.studentHomeChapterTests
      .replaceFirst(':subjectId', widget.subjectId)
      .replaceFirst(':chapterId', widget.chapter.id);

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final next = widget.nextChapter;

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(widget.chapter.title)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (controller != null)
              YoutubePlayer(controller: controller)
            else
              AspectRatio(
                aspectRatio: 16 / 9,
                child: EmptyStateView(
                  icon: Icons.ondemand_video_rounded,
                  message: context.l10n.chapterVideoOpenError,
                  actionLabel: context.l10n.chapterActionWatchVideo,
                  onAction: _openExternally,
                ),
              ),
            Padding(
              padding: EdgeInsets.all(context.dimens.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.chapterOrderLabel(widget.chapter.order),
                    style: context.textStyles.labelMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: context.dimens.xs),
                  Text(
                    widget.chapter.title,
                    style: context.textStyles.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(context.dimens.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (next != null) ...[
                    AppButton(
                      label: context.l10n.lectureNextChapter,
                      variant: AppButtonVariant.outlined,
                      icon: Icons.skip_next_rounded,
                      onPressed: () => context.pushReplacement(
                        AppRoutes.chapterLecturePath(widget.subjectId, next.id),
                      ),
                    ),
                    SizedBox(height: context.dimens.sm),
                  ],
                  AppButton(
                    label: context.l10n.lectureAttemptTest,
                    icon: Icons.quiz_outlined,
                    onPressed: () => context.push(_testListPath),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
