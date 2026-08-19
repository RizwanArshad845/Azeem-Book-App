import '../../catalog/entities/test.dart';

/// project_spec.md §9.2's `Test` entity genuinely has no `price` field —
/// `CartItem.price`/`discountedPrice` are the only place price lives in the
/// schema — so a price has to be assigned at add-to-cart time rather than
/// read off `Test`. This is a deliberate, deterministic (not random)
/// mapping from `Test.kind` so a demo cart looks stable/consistent across
/// app sessions rather than showing a different price for the same test
/// each time it's added.
double priceForTest(Test test) {
  switch (test.kind) {
    case TestKind.subjectWiseGuessPaper:
      return 250.0;
    case TestKind.subjectWiseSimplePaper:
      return 150.0;
    case TestKind.chapterWise:
      return 100.0;
  }
}
