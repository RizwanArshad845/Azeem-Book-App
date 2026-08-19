import '../../catalog/entities/test.dart';
import 'price_for_test.dart';

/// Sums [priceForTest] across every test in a subject bundle. Bundle-only
/// purchasing (project_spec.md §9.2 prose) means there is no separate
/// "bundle discount" rule layered on top of this — the only discount is the
/// existing teacher-discount rule, applied afterwards by the caller (see
/// `CartRepositoryImpl.addSubjectBundle`), exactly as it already was for
/// single-test pricing.
double priceForSubjectBundle(List<Test> tests) =>
    tests.fold(0.0, (sum, t) => sum + priceForTest(t));
