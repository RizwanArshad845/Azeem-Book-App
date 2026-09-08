import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../notifications/viewmodel/notifications_viewmodel.dart';
import '../../teacher_earnings/viewmodel/teacher_earnings_viewmodel.dart';
import '../../teacher_onboarding/viewmodel/teacher_onboarding_viewmodel.dart';
import '../../teacher_students/viewmodel/teacher_students_viewmodel.dart';

/// Read-only accessor for the current teacher's profile.
final currentTeacherProvider = Provider<Teacher?>((ref) {
  return ref.watch(
    teacherOnboardingViewModelProvider.select((async) => async.value),
  );
});

/// Aggregate metrics and goal tracking data for the Overview dashboard.
class TeacherOverviewStats {
  const TeacherOverviewStats({
    required this.totalStudents,
    required this.activePaidStudents,
    required this.freeStudents,
    required this.actualEarnings,
    required this.declaredStudents,
    required this.remainingStudents,
    required this.projectedPotential,
    required this.goalProgressPercent,
  });

  final int totalStudents;
  final int activePaidStudents;
  final int freeStudents;
  final double actualEarnings;
  final int declaredStudents;
  final int remainingStudents;
  final double projectedPotential;
  final double goalProgressPercent;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeacherOverviewStats &&
        other.totalStudents == totalStudents &&
        other.activePaidStudents == activePaidStudents &&
        other.freeStudents == freeStudents &&
        other.actualEarnings == actualEarnings &&
        other.declaredStudents == declaredStudents &&
        other.remainingStudents == remainingStudents &&
        other.projectedPotential == projectedPotential &&
        other.goalProgressPercent == goalProgressPercent;
  }

  @override
  int get hashCode => Object.hash(
        totalStudents,
        activePaidStudents,
        freeStudents,
        actualEarnings,
        declaredStudents,
        remainingStudents,
        projectedPotential,
        goalProgressPercent,
      );
}

/// Computes live metrics across enrolled students, earnings, and declared potential.
final teacherOverviewStatsProvider = Provider<TeacherOverviewStats>((ref) {
  final teacher = ref.watch(currentTeacherProvider);
  final studentsAsync = ref.watch(teacherStudentsProvider);
  final earningsAsync = ref.watch(teacherEarningsProvider);

  final students = studentsAsync.value ?? [];
  final earnings = earningsAsync.value ?? [];

  final totalStudents = students.length;
  final activePaidStudents =
      students.where((s) {
        final enrollments = s.subjectEnrollments ?? [];
        return enrollments.any((e) => e.discountApplied);
      }).length;
  final freeStudents = totalStudents - activePaidStudents;

  final actualEarnings = earnings.fold<double>(0, (sum, r) => sum + r.amount);

  // No fallback to a fabricated goal — an undeclared count means there's
  // genuinely no target yet, and the guards below already render that
  // honestly (0% progress, no projected potential) instead of faking one.
  final declared = teacher?.declaredStudentCount ?? 0;

  final remainingStudents = (declared - totalStudents).clamp(0, 99999);
  // Average expected commission of Rs. 500 per student bundle
  final projectedPotential = remainingStudents * 500.0;
  final goalProgressPercent =
      declared > 0 ? (totalStudents / declared).clamp(0.0, 1.0) : 0.0;

  return TeacherOverviewStats(
    totalStudents: totalStudents,
    activePaidStudents: activePaidStudents,
    freeStudents: freeStudents,
    actualEarnings: actualEarnings,
    declaredStudents: declared,
    remainingStudents: remainingStudents,
    projectedPotential: projectedPotential,
    goalProgressPercent: goalProgressPercent,
  );
});

/// True only while [teacherStudentsProvider] has never resolved a value yet
/// (i.e. the very first load) — used to gate stat displays that would
/// otherwise flash 0 before real data arrives. A later background refresh
/// keeps showing the stale value instead of flipping this back to true.
final teacherStudentsLoadingProvider = Provider<bool>((ref) {
  final async = ref.watch(teacherStudentsProvider);
  return async.isLoading && !async.hasValue;
});

/// True only while [teacherEarningsProvider] has never resolved a value yet.
final teacherEarningsLoadingProvider = Provider<bool>((ref) {
  final async = ref.watch(teacherEarningsProvider);
  return async.isLoading && !async.hasValue;
});

/// Unread notification count for the top utility bar.
final teacherUnreadNotificationsCountProvider = Provider<int>((ref) {
  final notifs = ref.watch(notificationsViewModelProvider).value ?? [];
  return notifs.where((n) => !n.isRead).length;
});
