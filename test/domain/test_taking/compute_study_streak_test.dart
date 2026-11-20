import 'package:azeem_book_app/domain/test_taking/usecases/compute_study_streak.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 3, 10, 9, 30);
  DateTime day(int d, [int hour = 12]) => DateTime(2026, 3, d, hour);

  group('computeStudyStreak', () {
    test('is 0 with no attempts', () {
      expect(computeStudyStreak(const [], now: now), 0);
    });

    test('counts consecutive days ending today', () {
      expect(
        computeStudyStreak([day(10, 8), day(9), day(8), day(6)], now: now),
        3,
      );
    });

    test('still counts a streak that ended yesterday', () {
      expect(computeStudyStreak([day(9), day(8)], now: now), 2);
    });

    test('is 0 when the last attempt was two or more days ago', () {
      expect(computeStudyStreak([day(8), day(7)], now: now), 0);
    });

    test('multiple attempts on one day count once', () {
      expect(
        computeStudyStreak([day(10, 1), day(10, 8), day(9, 23)], now: now),
        2,
      );
    });

    test('crosses month boundaries', () {
      final march1 = DateTime(2026, 3, 1, 10);
      expect(
        computeStudyStreak([
          march1,
          DateTime(2026, 2, 28, 10),
          DateTime(2026, 2, 27, 10),
        ], now: march1),
        3,
      );
    });
  });
}
