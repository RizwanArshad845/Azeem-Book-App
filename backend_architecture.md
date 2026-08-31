# Azeem Publications — Backend Architecture & Coding Conventions (Django + DRF)

> Companion to `backend.md`. That doc is the **data/API contract** (models, endpoints, error mapping, trust boundaries) — *what* the backend must expose. This doc is *how* the Django project implementing it should be structured: MVT layering, ORM conventions, service-layer pattern, settings, testing, and code style. Read both before writing any Django code; `backend.md`'s §-references below (§1, §2.2, §4.3, §4.5, §4.6, §4.9, §5, §6) refer to that doc.

---

## 1. Django is MVT, not MVC — map roles explicitly

Django's **View** is the controller (it receives the request, orchestrates Model + Serializer, returns a response); the **Template** role is replaced by the DRF **Serializer** for this API-only backend (no HTML rendered anywhere — there's a web Admin app per `backend.md` §6, but it's a separate client consuming this same JSON API, not server-rendered templates here). Concretely, per app:

| MVT role | File | Responsibility |
|---|---|---|
| Model | `models.py` | Schema + row-level invariants only (`CheckConstraint`s like the `discount_applied`-requires-`teacher_id` rule in `backend.md` §2.2, `clean()` validation, simple computed properties). No request/response logic. |
| Serializer (= "Template" for JSON) | `serializers.py` | Shape + validate JSON in/out. Field-level validation only (format, required-ness). Never contains cross-model business rules. |
| View (= "Controller") | `views.py` | Thin: parse request → call a service function → serialize response. No business logic inline — see §3. |
| URLconf | `urls.py` (per app) + root `config/urls.py` | Route table only, no logic. The entry point equivalent to Node's `index.js` is `config/wsgi.py`/`config/asgi.py`, not `urls.py`. |

## 2. Project layout

```
project_root/
├── config/                      # the "project" package (settings, root urls, wsgi/asgi)
│   ├── settings/
│   │   ├── base.py              # shared settings
│   │   ├── dev.py                # DEBUG=True, local DB, console email/SMS backend
│   │   ├── prod.py               # DEBUG=False, env-sourced secrets, real SMS/DB
│   │   └── test.py               # fast password hasher, in-memory/sqlite for CI
│   ├── urls.py                   # includes each app's urls.py under /api/v1/...
│   ├── celery.py                 # Celery app instance — see §6.1
│   ├── wsgi.py / asgi.py
├── apps/
│   ├── accounts/                 # User, Teacher, Student, Salesman, Admin, OTP (backend.md §1)
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   ├── services.py           # business logic — see §3
│   │   ├── tasks.py              # Celery tasks (OTP SMS send) — see §6.1
│   │   ├── permissions.py        # IsOwnerOrReadOnly-style role checks (backend.md §3)
│   │   ├── urls.py
│   │   ├── admin.py
│   │   ├── migrations/
│   │   └── tests/
│   │       ├── test_models.py
│   │       ├── test_services.py
│   │       └── test_views.py
│   ├── catalog/                  # ClassLevel, BoardClass, Subject, Chapter, Campus, Test, Question
│   ├── tests_app/                # TestAttempt, SubmissionAnswer, LiveTestRegistration (named tests_app to avoid clashing with Django's own "tests" convention)
│   ├── commerce/                 # Cart, CartItem, Payment, EarningsRecord
│   └── notifications/            # Notification
├── manage.py
├── requirements/
│   ├── base.txt
│   ├── dev.txt
│   └── prod.txt
└── pyproject.toml                # black/isort/ruff config, §7
```

Each Django app in `apps/` corresponds exactly to a row in `backend.md` §1 — don't add extra apps or merge these five without a reason, since `backend.md`'s §-cross-references assume this boundary.

## 3. Service layer — where business logic actually lives

Views and models must **not** contain the trust-sensitive logic from `backend.md` §4.6 (purchase gating, earnings attribution) or the grading logic implied by the `tests_app` row in §1. Put it in a `services.py` per app: plain functions (not classes) that take/return domain objects, are called from views, and are unit-testable without spinning up HTTP.

```python
# apps/commerce/services.py
from decimal import Decimal
from django.db import transaction

@transaction.atomic
def checkout(student_id: str) -> Payment:
    cart = Cart.objects.select_related("student").get(student_id=student_id)
    payment = Payment.objects.create(student_id=student_id, amount=cart.total_amount, status="pending")
    # ... charge gateway ...
    payment.status = "success"
    payment.save(update_fields=["status"])
    _attribute_earnings(cart)          # server-computed, never client-posted — see backend.md §4.6
    return payment

def _attribute_earnings(cart: Cart) -> None:
    for item in cart.items.select_related("test__subject"):
        enrollment = SubjectEnrollment.objects.filter(
            student=cart.student, subject=item.test.subject, teacher__isnull=False
        ).first()
        if enrollment:
            EarningsRecord.objects.create(
                teacher=enrollment.teacher, student=cart.student,
                amount=item.price * Decimal("0.10"), trigger_event="paidPackPurchase",
            )
```

The view stays thin:

```python
# apps/commerce/views.py
class CheckoutView(APIView):
    def post(self, request):
        payment = checkout(request.data["studentId"])
        return Response(PaymentSerializer(payment).data, status=201)
```

Rule of thumb: if a piece of logic touches **more than one model** or enforces a **trust boundary** (`backend.md` §4.6's purchase gate and commission calc, the grading re-validation in §4.5, OTP lockout in §5), it belongs in `services.py`, not in the view or a model method. Model methods are fine for logic scoped to that single row (e.g., `Test.recompute_stats()` deriving `question_count`/`duration_minutes`/`total_marks` from its `Question` set, per `backend.md` §2.2).

## 4. ORM conventions

- **Avoid N+1 queries** on every list endpoint that nests relations — e.g. `/teachers/{id}/students` (`backend.md` §4.3) and `TestAttempt.answers` nesting (§3) must use `select_related()` (FK/O2O) and `prefetch_related()` (M2M/reverse FK) explicitly; don't rely on default lazy loading.
- **Custom managers/querysets** for repeated filters instead of duplicating `.filter(...)` chains across views — e.g. `Teacher.objects.approved()`, `TestAttempt.objects.for_student(student_id)`.
- **`transaction.atomic`** around any multi-model write that must succeed/fail together — checkout + earnings attribution (§4.6), test submission + grading (§4.5), OTP verify + token issuance (§5).
- **`F()` expressions** for concurrent-safe increments (e.g. `Teacher.actual_earnings` credited from multiple purchases) instead of read-modify-write in Python, which race under concurrent requests.
- **Constraints at the DB layer, not just serializer validation** — the `discount_applied`-requires-`teacher_id` rule (`backend.md` §2.2) is a `CheckConstraint` on the model, so it holds even for writes that bypass DRF (Django admin, management commands, shell).
- **Migrations**: one migration per logical schema change, never hand-edited after being applied in any shared environment; `makemigrations --check` in CI to catch missing migrations.

## 5. Settings & secrets

Use `django-environ` (or `python-decouple`) to read all secrets (`SECRET_KEY`, DB credentials, JWT signing key, SMS vendor keys) from environment variables — never commit them. `config/settings/base.py` holds shared config; `dev.py`/`prod.py`/`test.py` import from it and override (`DEBUG`, `ALLOWED_HOSTS`, `DATABASES`, email/SMS backend). `manage.py` and `wsgi.py` select the settings module via `DJANGO_SETTINGS_MODULE` env var, not a hardcoded string.

**CORS**: the Admin web app (`backend.md` §6) is a separate browser-origin client hitting this same API, so install `django-cors-headers` and scope `CORS_ALLOWED_ORIGINS` to the Admin app's real origin(s) in `prod.py` (not `CORS_ALLOW_ALL_ORIGINS`). The Flutter mobile app and Salesman APK aren't browser clients and aren't affected by CORS.

## 6. Auth implementation

Use `djangorestframework-simplejwt` for the JWT issuance described in `backend.md` §5 (short-lived access + refresh, `user_id`/`role` claims). OTP itself (generation, SMS dispatch, lockout counter) is not something DRF ships — model it as its own small piece in `apps/accounts/services.py` (e.g. `request_otp(phone, role)` / `verify_otp(phone, otp, role)`), backed by a Redis-cached attempt counter per §5's lockout requirement, not a Python-process-local counter (won't survive multi-worker deployment).

### 6.1 Async tasks (Phase 2 / nice-to-have, not a Phase-1 blocker)

SMS dispatch (OTP request) and notification fanout (`backend.md` §4.7) are both external-I/O-bound and shouldn't block the request/response cycle. Once the SMS vendor is confirmed (`backend.md` §5's open item), move the actual send into a Celery task (`apps/accounts/tasks.py`, `send_otp_sms.delay(phone, code)`) backed by Redis as the broker — reusing the same Redis instance already used for the lockout counter above. Not required to ship Phase 1 with synchronous SMS sending, but flagged here so it isn't accidentally load-bearing in the request path long-term.

## 7. Testing conventions

`pytest-django` + `factory_boy` (factories per model, mirroring the `backend.md` §2.2 table) + DRF's `APIClient`. Minimum coverage expectation for a production backend:
- **`test_models.py`**: constraint violations raise (e.g. `discount_applied=True, teacher=None` must fail at the DB layer).
- **`test_services.py`**: the §3 trust-boundary functions — checkout/earnings attribution, purchase-gate re-check on submit, OTP lockout — tested without HTTP, since these are the highest-risk code paths in the doc.
- **`test_views.py`**: one test per endpoint in `backend.md` §4 covering the happy path + each documented error in the "Errors" column, plus a cross-role permission test (a student token must 403 on another student's `{id}`-scoped path).

## 8. Pagination & filtering

Default to DRF's `PageNumberPagination` globally in settings, matching the `page`/`page_size` params already named in `/teachers/{id}/students` (`backend.md` §4.3). Use `django-filter` for the `?query=&campus_id=&status=&sort_by=` style filtering on that same endpoint rather than hand-rolling query-param parsing per view.

## 9. Global exception handling

Implement a custom DRF exception handler (`config/exception_handler.py`, wired via `EXCEPTION_HANDLER` in settings) that produces the `{"error": {"code": ..., "message": ...}}` shape recommended in `backend.md` §4.9 for every 400/401/403/404/500, so error-shape consistency is enforced centrally rather than per-view.

## 10. Code style

`black` + `isort` + `ruff` (or `flake8`), configured in `pyproject.toml`, run via `pre-commit`. Keep views/services under the "thin view, fat service, thin model" split from §1–§3 rather than letting logic drift back into views as the app grows.
