import '../../../../domain/common/result.dart';
import '../../../../domain/notifications/entities/notification.dart';
import '../../models/notification_dto.dart';

/// Same method signatures as [NotificationRemoteDataSource] so the
/// repository can swap between the two based purely on
/// `AppConfig.isMockMode` (§6.2).
abstract class NotificationDummyDataSource {
  Future<Result<List<NotificationDto>>> getNotifications(String recipientId);

  Future<Result<void>> markAsRead(String notificationId);
}

/// In-memory dummy notifications, structurally identical to what the real
/// API will eventually return (project_spec.md §6.1). Simulates network
/// latency via [Future.delayed] so the viewmodel exercises the same
/// `AsyncValue` loading states it will against the real API. Seeded across
/// three sample recipients — two students, one teacher — with a mix of
/// read/unread and every `NotificationType` (§10.2).
class NotificationDummyDataSourceImpl implements NotificationDummyDataSource {
  NotificationDummyDataSourceImpl() {
    _seed();
  }

  static const _latency = Duration(milliseconds: 400);

  // Sample recipient ids, following the `${role.name}-$phoneNumber` pattern
  // synthesized by AuthDummyDataSourceImpl — any string works here since
  // this store is standalone, but reusing that shape keeps dummy data
  // plausible end-to-end.
  static const studentIdA = 'student-03001234567';
  static const studentIdB = 'student-03007654321';
  static const teacherIdA = 'teacher-03009876543';

  final List<NotificationDto> _notifications = [];

  void _seed() {
    final now = DateTime.now();
    _notifications.addAll([
      NotificationDto(
        id: 'notif-1',
        recipientId: studentIdA,
        recipientRole: NotificationRecipientRole.student,
        type: NotificationType.newTestUploaded,
        message: 'New Chemistry chapter-wise test uploaded.',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 20)),
      ),
      NotificationDto(
        id: 'notif-2',
        recipientId: studentIdA,
        recipientRole: NotificationRecipientRole.student,
        type: NotificationType.liveTestReminder,
        message: 'Physics guess paper live test starts in 1 hour.',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationDto(
        id: 'notif-3',
        recipientId: studentIdA,
        recipientRole: NotificationRecipientRole.student,
        type: NotificationType.discountAnnouncement,
        message: '20% off on all Biology test packs this week only.',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      NotificationDto(
        id: 'notif-4',
        recipientId: studentIdB,
        recipientRole: NotificationRecipientRole.student,
        type: NotificationType.newTestUploaded,
        message: 'New Maths chapter-wise test uploaded for Chapter 7.',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      NotificationDto(
        id: 'notif-5',
        recipientId: studentIdB,
        recipientRole: NotificationRecipientRole.student,
        type: NotificationType.discountAnnouncement,
        message: 'Eid sale: flat 15% off on English test bundles.',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      NotificationDto(
        id: 'notif-6',
        recipientId: teacherIdA,
        recipientRole: NotificationRecipientRole.teacher,
        type: NotificationType.studentRegistered,
        message: 'Ali Raza registered at 2:45 PM.',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 45)),
      ),
      NotificationDto(
        id: 'notif-7',
        recipientId: teacherIdA,
        recipientRole: NotificationRecipientRole.teacher,
        type: NotificationType.studentRegistered,
        message: 'Sana Malik registered at 11:10 AM.',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      NotificationDto(
        id: 'notif-8',
        recipientId: teacherIdA,
        recipientRole: NotificationRecipientRole.teacher,
        type: NotificationType.profileUpdatePending,
        message: 'Your profile update is pending Admin approval.',
        isRead: false,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationDto(
        id: 'notif-9',
        recipientId: teacherIdA,
        recipientRole: NotificationRecipientRole.teacher,
        type: NotificationType.teacherAwaitingApproval,
        message: 'Your teacher account is awaiting Admin approval.',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      NotificationDto(
        id: 'notif-10',
        recipientId: studentIdA,
        recipientRole: NotificationRecipientRole.student,
        type: NotificationType.liveTestReminder,
        message: 'Chemistry guess paper live test starts tomorrow at 5 PM.',
        isRead: false,
        createdAt: now.subtract(const Duration(days: 1, hours: 1)),
      ),
    ]);
  }

  @override
  Future<Result<List<NotificationDto>>> getNotifications(
    String recipientId,
  ) async {
    await Future.delayed(_latency);
    final items =
        _notifications.where((n) => n.recipientId == recipientId).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Success(items);
  }

  @override
  Future<Result<void>> markAsRead(String notificationId) async {
    await Future.delayed(_latency);
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
    return const Success(null);
  }
}
