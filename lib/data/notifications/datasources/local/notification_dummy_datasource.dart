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

/// In-memory dummy notifications seeded with realistic teacher and student events.
class NotificationDummyDataSourceImpl implements NotificationDummyDataSource {
  NotificationDummyDataSourceImpl() {
    _seed();
  }

  static const _latency = Duration(milliseconds: 400);

  static const studentIdA = 'student-03001234567';
  static const studentIdB = 'student-03007654321';
  static const teacherIdA = 'teacher-03009876543';

  final List<NotificationDto> _notifications = [];

  void _seed() {
    final now = DateTime.now();
    _notifications.addAll([
      // Teacher activity stream
      NotificationDto(
        id: 'notif-t1',
        recipientId: teacherIdA,
        recipientRole: NotificationRecipientRole.teacher,
        type: NotificationType.studentRegistered,
        message: 'Ali Ahmed registered and added you as their teacher.',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
      NotificationDto(
        id: 'notif-t2',
        recipientId: teacherIdA,
        recipientRole: NotificationRecipientRole.teacher,
        type: NotificationType.studentRegistered,
        message: 'Fatima Zahra purchased Physics Chapter-wise Bundle (+Rs. 500 commission).',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationDto(
        id: 'notif-t3',
        recipientId: teacherIdA,
        recipientRole: NotificationRecipientRole.teacher,
        type: NotificationType.studentRegistered,
        message: 'Hamza Tariq purchased Chemistry Test Bundle (+Rs. 500 commission).',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      NotificationDto(
        id: 'notif-t4',
        recipientId: teacherIdA,
        recipientRole: NotificationRecipientRole.teacher,
        type: NotificationType.studentRegistered,
        message: 'Usman Khalid registered at 10:15 AM.',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationDto(
        id: 'notif-t5',
        recipientId: teacherIdA,
        recipientRole: NotificationRecipientRole.teacher,
        type: NotificationType.teacherAwaitingApproval,
        message: 'Your teacher account is approved and active.',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 3)),
      ),

      // Student activity stream
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
    ]);
  }

  @override
  Future<Result<List<NotificationDto>>> getNotifications(
    String recipientId,
  ) async {
    await Future.delayed(_latency);
    final isTeacherQuery = recipientId.toLowerCase().contains('teacher') ||
        recipientId.startsWith('t-') ||
        recipientId.startsWith('usr-teacher');

    final items = _notifications.where((n) {
      if (n.recipientId == recipientId) return true;
      if (isTeacherQuery && n.recipientRole == NotificationRecipientRole.teacher) {
        return true;
      }
      return false;
    }).toList()
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
