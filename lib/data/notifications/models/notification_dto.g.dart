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
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
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
  NotificationType.newTestUploaded: 'newTestUploaded',
  NotificationType.discountAnnouncement: 'discountAnnouncement',
  NotificationType.liveTestReminder: 'liveTestReminder',
};
