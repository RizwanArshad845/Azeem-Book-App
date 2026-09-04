// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationDto _$NotificationDtoFromJson(Map<String, dynamic> json) =>
    _NotificationDto(
      id: json['id'] as String,
      recipientId: json['recipientId'] as String,
      recipientRole: $enumDecode(
        _$NotificationRecipientRoleEnumMap,
        json['recipientRole'],
      ),
      type: $enumDecode(
        _$NotificationTypeEnumMap,
        json['type'],
        unknownValue: NotificationType.unknown,
      ),
      message: json['message'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationDtoToJson(
  _NotificationDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'recipientId': instance.recipientId,
  'recipientRole': _$NotificationRecipientRoleEnumMap[instance.recipientRole]!,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'message': instance.message,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$NotificationRecipientRoleEnumMap = {
  NotificationRecipientRole.admin: 'admin',
  NotificationRecipientRole.teacher: 'teacher',
  NotificationRecipientRole.student: 'student',
  NotificationRecipientRole.salesman: 'salesman',
};

const _$NotificationTypeEnumMap = {
  NotificationType.studentRegistered: 'studentRegistered',
  NotificationType.profileUpdatePending: 'profileUpdatePending',
  NotificationType.teacherAwaitingApproval: 'teacherAwaitingApproval',
  NotificationType.phoneRecoveryRequested: 'phoneRecoveryRequested',
  NotificationType.accountDeletionRequested: 'accountDeletionRequested',
  NotificationType.studentPurchasedPack: 'studentPurchasedPack',
  NotificationType.teacherPayoutRequested: 'teacherPayoutRequested',
  NotificationType.refundRequested: 'refundRequested',
  NotificationType.paymentFailedAlert: 'paymentFailedAlert',
  NotificationType.salesmanSeededTeacher: 'salesmanSeededTeacher',
  NotificationType.questionFlagged: 'questionFlagged',
  NotificationType.liveTestCompleted: 'liveTestCompleted',
  NotificationType.otpLockoutTriggered: 'otpLockoutTriggered',
  NotificationType.roleViolationAttempt: 'roleViolationAttempt',
  NotificationType.earningsCredited: 'earningsCredited',
  NotificationType.studentEnrolled: 'studentEnrolled',
  NotificationType.profileUpdateApproved: 'profileUpdateApproved',
  NotificationType.payoutDisbursed: 'payoutDisbursed',
  NotificationType.newTestUploaded: 'newTestUploaded',
  NotificationType.discountAnnouncement: 'discountAnnouncement',
  NotificationType.liveTestReminder: 'liveTestReminder',
  NotificationType.freeAttemptsExhausted: 'freeAttemptsExhausted',
  NotificationType.paymentSuccessful: 'paymentSuccessful',
  NotificationType.salesmanCommissionCredited: 'salesmanCommissionCredited',
  NotificationType.teacherJoinedWithCode: 'teacherJoinedWithCode',
  NotificationType.resultReady: 'resultReady',
  NotificationType.testGradingFailed: 'testGradingFailed',
  NotificationType.unknown: 'unknown',
};
