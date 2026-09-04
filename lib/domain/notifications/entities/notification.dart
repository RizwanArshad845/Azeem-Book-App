import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';

/// `recipientRole` of a [Notification] (project_spec.md §9.2). Schema
/// fidelity requires all four roles even though this app (Teacher + Student
/// only — Admin/Salesman are separate apps, §9.1) will ever construct
/// `teacher`/`student` recipients.
enum NotificationRecipientRole { admin, teacher, student, salesman }

/// `type` of a [Notification] (project_spec.md §9.2). Full 27-value wire
/// enum per `FRONTEND_INTEGRATION.md` §7 — of these, §8 documents only 11
/// as actually fired by the backend today (`studentRegistered`,
/// `teacherAwaitingApproval`, `studentEnrolled`, `discountAnnouncement`,
/// `newTestUploaded`, `paymentSuccessful`, `earningsCredited`,
/// `liveTestCompleted`, `otpLockoutTriggered`, `resultReady`,
/// `testGradingFailed`); the rest are defined-but-unused enum values
/// (refunds, payouts, question flagging, etc. — each needs a whole feature
/// built first). All 27 are listed here (not just the 11 live ones) so a
/// single unrecognized notification never throws and kills the whole
/// notifications-list fetch (`$enumDecode` in the generated
/// `NotificationDto.fromJson`) — see [unknown] for the true last-resort
/// fallback beyond even this list.
enum NotificationType {
  studentRegistered,
  profileUpdatePending,
  teacherAwaitingApproval,
  phoneRecoveryRequested,
  accountDeletionRequested,
  studentPurchasedPack,
  teacherPayoutRequested,
  refundRequested,
  paymentFailedAlert,
  salesmanSeededTeacher,
  questionFlagged,
  liveTestCompleted,
  otpLockoutTriggered,
  roleViolationAttempt,
  earningsCredited,
  studentEnrolled,
  profileUpdateApproved,
  payoutDisbursed,
  newTestUploaded,
  discountAnnouncement,
  liveTestReminder,
  freeAttemptsExhausted,
  paymentSuccessful,
  salesmanCommissionCredited,
  teacherJoinedWithCode,
  resultReady,
  testGradingFailed,

  /// Not a real wire value — `@JsonKey(unknownEnumValue: ...)` fallback on
  /// `NotificationDto.type` for any future type added server-side before
  /// this enum is updated to match.
  unknown,
}

/// A single notification entry for either a Teacher or Student recipient
/// (project_spec.md §9.2, §10.2).
@freezed
abstract class Notification with _$Notification {
  const factory Notification({
    required String id,
    required String recipientId,
    required NotificationRecipientRole recipientRole,
    required NotificationType type,
    required String message,
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _Notification;
}
