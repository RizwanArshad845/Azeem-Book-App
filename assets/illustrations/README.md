# Subject & card illustrations

Drop the AI-generated illustration PNGs here (512×512, transparent, brand palette
#115740 / #EF9F27). File names are resolved by `lib/core/utils/subject_illustration.dart`
and `lib/core/constants/app_assets.dart`.

Expected files (all optional — the UI falls back to native icons when missing):

- `test_paper.png` — shared test-card thumbnail
- `subject_physics.png`, `subject_chemistry.png`, `subject_biology.png`,
  `subject_maths.png`, `subject_english.png`, `subject_urdu.png`,
  `subject_computer.png`, `subject_accounting.png`, `subject_economics.png`,
  `subject_generic.png` (fallback)
- `practice_bank.png`, `attempts_hint.png`, `trophy.png`
- `promo_live.png`, `promo_discount.png`, `empty_tests.png`

See the approved plan for the exact generation prompts.
