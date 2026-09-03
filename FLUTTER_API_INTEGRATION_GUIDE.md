# Flutter Mobile App — REST API Integration Guide

This guide details all the REST API endpoints, request/response models, headers, and step-by-step instructions required to replace mock data in `azeem_book_app` with the live Django backend.

---

## 1. Global Setup & Network Layer

### Base Configuration
* **Base URL:** `http://<SERVER_HOST>:8000/api` (e.g., `http://10.0.2.2:8000/api` for Android Emulator or `http://localhost:8000/api` for iOS Simulator).
* **Headers:**
  ```http
  Content-Type: application/json
  Authorization: Bearer <JWT_ACCESS_TOKEN>
  ```

### Authentication & Interceptors
1. **Token Persistence:** Save the JWT token securely in `flutter_secure_storage`.
2. **Error Interceptor (`error_interceptor.dart`):**
   * Catch `401 Unauthorized`: Clear stored token and redirect user to `PhoneEntryView`.
   * Catch `400 Bad Request` / `500 Internal Error`: Map raw API/HTTP errors to human-readable UI messages.

### User-Friendly Error Handling Guidelines
> [!IMPORTANT]
> **Never show raw technical error messages** (e.g. `Status code 404`, `Internal Server Error 500`, `DioException [bad response]`, `FormatException`) to the user.

Always map HTTP errors and network exceptions in `error_interceptor.dart` to clean, helpful UI messages:

| HTTP Status / Exception | Technical Error | User-Friendly UI Message |
| :--- | :--- | :--- |
| **No Internet Connection** | `SocketException` / `DioExceptionType.connectionTimeout` | *"Unable to connect. Please check your internet connection and try again."* |
| **400 Bad Request** | OTP incorrect or expired | *"The OTP code entered is incorrect or expired. Please request a new one."* |
| **401 Unauthorized** | JWT expired or invalid | *"Your session has expired. Please log in again."* |
| **403 Forbidden** | Access restricted | *"You don't have permission to access this resource."* |
| **404 Not Found** | Resource missing | *"The requested item or test could not be found."* |
| **429 Too Many Requests** | Rate limit hit | *"Too many attempts. Please wait a moment before trying again."* |
| **500 / 502 / 503 Server Error** | Django/Server Exception | *"Something went wrong on our end. Please try again later."* |

---

## 2. Authentication & Signup Flow

### Step 1: Request OTP
* **Endpoint:** `POST /auth/otp/request`
* **Request Body:**
  ```json
  {
    "phoneNumber": "+923001234567"
  }
  ```
* **Response (200 OK):**
  ```json
  {
    "message": "OTP sent successfully"
  }
  ```

### Step 2: Verify OTP
* **Endpoint:** `POST /auth/otp/verify`
* **Request Body:**
  ```json
  {
    "phoneNumber": "+923001234567",
    "otp": "123456"
  }
  ```
* **Response (200 OK):**
  ```json
  {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6...",
    "userId": "usr_uuid_12345",
    "role": "student",
    "onboardingCompleted": false
  }
  ```

---

## 3. Student Onboarding & Profile Management

### Step 1: Fetch Catalog Options for Onboarding
* **Get Board Classes:** `GET /catalog/board-classes`
  ```json
  [
    { "id": "bc_9th_uuid", "name": "9th Class", "isEnabled": true },
    { "id": "bc_10th_uuid", "name": "10th Class", "isEnabled": true }
  ]
  ```
* **Get Campuses:** `GET /catalog/campuses`
  ```json
  [
    { "id": "cmp_1_uuid", "name": "Lahore Main Campus", "city": "Lahore" }
  ]
  ```

### Step 2: Complete Student Onboarding (Creation)
* **Endpoint:** `POST /students`
* **Headers:** `Authorization: Bearer <JWT>`
* **Request Body:**
  ```json
  {
    "id": "usr_uuid_12345",
    "name": "Ali Raza",
    "phoneNumber": "+923001234567",
    "campusId": "cmp_1_uuid",
    "boardClassId": "bc_9th_uuid"
  }
  ```
* **Response (201 Created):** Full Student Profile Object.

### Step 3: Set Subject & Teacher Enrollments
* **Endpoint:** `PUT /students/{studentId}/subject-enrollments`
* **Request Body:**
  ```json
  {
    "enrollments": [
      { "subjectId": "subj_physics_uuid", "teacherId": "tch_teacher1_uuid" },
      { "subjectId": "subj_math_uuid", "teacherId": null }
    ]
  }
  ```

---

## 4. Student Dashboard & Catalog Browsing

### Fetch Subjects
* **Endpoint:** `GET /catalog/subjects?boardClassId={boardClassId}`
* **Response:** Array of subjects linked to the student's class.

### Fetch Chapters
* **Endpoint:** `GET /catalog/chapters?subjectId={subjectId}`
* **Response:** List of chapters with `isFreeSample` boolean flag.

### Fetch Published Tests
* **Endpoint:** `GET /catalog/tests?subjectId={subjectId}&chapterId={chapterId}`
* **Note:** Only published tests (`isLive: true`) are returned.

---

## 5. Test Taking & Automated AI Grading Flow

### Step 1: Start Test Attempt
* **Endpoint:** `POST /tests/{testId}/start-attempt`
* **Response (200 OK):**
  ```json
  {
    "attempt_id": "att_789_uuid",
    "deadline_at": "2026-09-03T02:30:00Z",
    "questions": [
      {
        "id": "q_1",
        "type": "mcq",
        "question_text": "What is the capital of France?",
        "options": ["London", "Berlin", "Paris", "Rome"],
        "marks": 2
      },
      {
        "id": "q_2",
        "type": "shortAnswer",
        "question_text": "Explain photosynthesis.",
        "marks": 4
      }
    ]
  }
  ```

### Step 2: Auto-save Progress (Optional / Periodic)
* **Endpoint:** `PATCH /attempts/{attemptId}/answers`
* **Request Body:**
  ```json
  {
    "question_id": "q_1",
    "selected_option_index": 2
  }
  ```

### Step 3: Submit Test Attempt
* **Endpoint:** `POST /tests/{testId}/submit`
* **Request Body:**
  ```json
  {
    "answers": [
      { "question_id": "q_1", "selected_option_index": 2 },
      { "question_id": "q_2", "answer_text": "Plants use sunlight and chlorophyll to make food." }
    ]
  }
  ```
* **Response:** Triggers background AI grading pipeline.

### Step 4: Fetch Graded Results & Breakdown
* **Endpoint:** `GET /attempts/{attemptId}`
* **Response (When `status == "graded"`):**
  ```json
  {
    "id": "att_789_uuid",
    "status": "graded",
    "score_percent": 85.0,
    "total_marks_awarded": 17,
    "total_possible_marks": 20,
    "weak_chapter_ids": ["ch_chapter3_uuid"],
    "strong_chapter_ids": ["ch_chapter1_uuid"],
    "answers": [
      {
        "question_id": "q_2",
        "question_text": "Explain photosynthesis.",
        "type": "shortAnswer",
        "answer_text": "Plants use sunlight and chlorophyll to make food.",
        "expected_answer": "Photosynthesis is the process by which green plants use sunlight to synthesize nutrients from carbon dioxide and water.",
        "marks_awarded": 3,
        "possible_marks": 4,
        "token_judgements": [
          { "token": "photosynthesis", "used": true },
          { "token": "sunlight", "used": true },
          { "token": "glucose", "used": false }
        ],
        "justification": "Identified sunlight and photosynthesis, but missed glucose output.",
        "solution_explanation": "Photosynthesis produces glucose and oxygen.",
        "graded_by_ai": true
      }
    ]
  }
  ```

---

## 6. Cart & Purchase Flow

* **Get Cart:** `GET /students/{studentId}/cart`
* **Add to Cart:** `POST /students/{studentId}/cart` $\rightarrow$ `{ "testId": "test_uuid" }`
* **Remove from Cart:** `DELETE /students/{studentId}/cart?testId=test_uuid`
* **Checkout:** `POST /students/{studentId}/checkout` (Unlocks tests for student).

---

## 7. Migration Steps (Replacing Mock Data)

1. **Create Models:** Ensure Dart models in `lib/core/models/` have `fromJson()` and `toJson()` constructors matching the camelCase JSON fields above.
2. **Create ApiService / Repository:** Implement Dio HTTP calls in `lib/core/network/api_service.dart`.
3. **Update ViewModels:** Replace dummy list assignments in `StudentCartViewModel`, `TestListViewModel`, etc., with `await _apiService.fetch...()`.
4. **Test Live Connection:** Start your Django backend (`python manage.py runserver 0.0.0.0:8000`) and connect your mobile device or emulator!
