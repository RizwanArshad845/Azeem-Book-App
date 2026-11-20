/// Length of the student's current study streak: the number of consecutive
/// calendar days, ending today or yesterday, with at least one test attempt.
///
/// Ending "yesterday" still counts so a streak doesn't read as broken first
/// thing in the morning before today's attempt. Pure function over attempt
/// timestamps (compared as local calendar days) — no DI wiring needed.
int computeStudyStreak(
  Iterable<DateTime> attemptTimes, {
  required DateTime now,
}) {
  DateTime dayOf(DateTime t) {
    final local = t.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  final days = attemptTimes.map(dayOf).toSet();
  if (days.isEmpty) return 0;

  final today = dayOf(now);
  var cursor = days.contains(today)
      ? today
      : DateTime(today.year, today.month, today.day - 1);
  var streak = 0;
  while (days.contains(cursor)) {
    streak++;
    // Calendar arithmetic (not `subtract(Duration(days: 1))`) so DST
    // transitions can't skip or repeat a day.
    cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
  }
  return streak;
}
