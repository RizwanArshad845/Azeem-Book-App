import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../student_home/viewmodel/student_home_viewmodel.dart';

/// Faint, diagonal, repeating "Name · 0300-***-4567" overlay drawn over ebook
/// pages. Screenshots are already blocked, so this targets the remaining
/// leak — photographing the screen with another phone — by making any such
/// photo traceable to the account it came from. Ignores all touches.
class ReaderWatermark extends ConsumerWidget {
  const ReaderWatermark({super.key});

  static String _maskPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) return digits;
    return '${digits.substring(0, 4)}-***-${digits.substring(digits.length - 4)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(currentStudentProvider);
    if (student == null) return const SizedBox.shrink();
    final label = '${student.name} · ${_maskPhone(student.phoneNumber)}';
    final style = context.textStyles.titleSmall?.copyWith(
      color: context.colors.textPrimary.withValues(alpha: 0.10),
      fontWeight: FontWeight.w600,
    );

    return IgnorePointer(
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, box) {
            // Oversized so the rotated grid still covers the corners.
            final side = math.max(box.maxWidth, box.maxHeight) * 1.6;
            return OverflowBox(
              maxWidth: side,
              maxHeight: side,
              child: Transform.rotate(
                angle: -math.pi / 6,
                child: Wrap(
                  spacing: context.dimens.xl,
                  runSpacing: context.dimens.xxl * 1.5,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var i = 0; i < 80; i++) Text(label, style: style),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
