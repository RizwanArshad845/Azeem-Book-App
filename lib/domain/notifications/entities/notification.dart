import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';

/// `recipientRole` of a [Notification] (project_spec.md §9.2). Schema
/// fidelity requires all four roles even though this app (Teacher + Student
/// only — Admin/Salesman are separate apps, §9.1) will ever construct
/// `teacher`/`student` recipients.
enum NotificationRecipientRole { admin, teacher, student, salesman }

/// `type` of a [Notification] (project_spec.md §9.2). Drives the message
/// copy shown in the Notifications tab (§10.2): student-facing types are
/// `newTestUploaded`, `discountAnnouncement`, `liveTestReminder`;
/// teacher-facing types are `studentRegistered`, `profileUpdatePending`,
/// `teacherAwaitingApproval`.
enum NotificationType {
  studentRegistered,
  profileUpdatePending,
  teacherAwaitingApproval,
  newTestUploaded,
  discountAnnouncement,
  liveTestReminder,
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
