import 'package:azeem_book_app/presentation/student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    // These are `.autoDispose` providers — keep them alive for the
    // duration of each test via an explicit listener, rather than relying
    // on `read()` timing between statements.
    container.listen(subjectSelectionViewModelProvider, (_, _) {});
    container.listen(selectedBoardClassViewModelProvider, (_, _) {});
    container.listen(selectedClassLevelViewModelProvider, (_, _) {});
  });

  test('SubjectSelectionViewModel.clear() empties the selection map', () {
    container
        .read(subjectSelectionViewModelProvider.notifier)
        .toggleSubject('cs_id');
    expect(container.read(subjectSelectionViewModelProvider), {
      'cs_id': null,
    });

    container.read(subjectSelectionViewModelProvider.notifier).clear();

    expect(container.read(subjectSelectionViewModelProvider), <String, String?>{});
  });

  test(
    'SelectedBoardClassViewModel.select() with a new value clears stale '
    'subject selections (I.C.S -> Pre-Engineering repro)',
    () {
      container
          .read(selectedBoardClassViewModelProvider.notifier)
          .select('ics_id');
      container
          .read(subjectSelectionViewModelProvider.notifier)
          .toggleSubject('cs_id');
      expect(container.read(subjectSelectionViewModelProvider), {
        'cs_id': null,
      });

      container
          .read(selectedBoardClassViewModelProvider.notifier)
          .select('preeng_id');

      expect(
        container.read(subjectSelectionViewModelProvider),
        <String, String?>{},
      );
      expect(container.read(selectedBoardClassViewModelProvider), 'preeng_id');
    },
  );

  test(
    'SelectedBoardClassViewModel.select() re-selecting the same value does '
    'not wipe in-progress selections',
    () {
      container
          .read(selectedBoardClassViewModelProvider.notifier)
          .select('ics_id');
      container
          .read(subjectSelectionViewModelProvider.notifier)
          .toggleSubject('cs_id');

      container
          .read(selectedBoardClassViewModelProvider.notifier)
          .select('ics_id');

      expect(container.read(subjectSelectionViewModelProvider), {
        'cs_id': null,
      });
    },
  );

  test(
    'SelectedClassLevelViewModel.select() resets both the board-class pick '
    'and any subject selections made under the previous class level',
    () {
      container
          .read(selectedClassLevelViewModelProvider.notifier)
          .select('11th');
      container
          .read(selectedBoardClassViewModelProvider.notifier)
          .select('ics_id');
      container
          .read(subjectSelectionViewModelProvider.notifier)
          .toggleSubject('cs_id');

      container
          .read(selectedClassLevelViewModelProvider.notifier)
          .select('9th');

      expect(container.read(selectedBoardClassViewModelProvider), null);
      expect(
        container.read(subjectSelectionViewModelProvider),
        <String, String?>{},
      );
    },
  );
}
