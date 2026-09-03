import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/notifications/entities/notification.dart';

part 'notification_dto.freezed.dart';
part 'notification_dto.g.dart';

/// Data-layer DTO mirroring the wire shape of `/notifications/{recipientId}`
/// per §9.2.
@freezed
abstract class NotificationDto with _$NotificationDto {
  const NotificationDto._();

  const factory NotificationDto({
    required String id,
    required String recipientId,
    required NotificationRecipientRole recipientRole,
    required NotificationType type,
    required String message,
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _NotificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  Notification toDomain() => Notification(
    id: id,
    recipientId: recipientId,
    recipientRole: recipientRole,
    type: type,
    message: message,
    isRead: isRead,
    createdAt: createdAt,
  );

  factory NotificationDto.fromDomain(Notification entity) => NotificationDto(
    id: entity.id,
    recipientId: entity.recipientId,
    recipientRole: entity.recipientRole,
    type: entity.type,
    message: entity.message,
    isRead: entity.isRead,
    createdAt: entity.createdAt,
  );
}
