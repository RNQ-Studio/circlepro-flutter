import '../domain/event_enums.dart';
import '../domain/event_registration_entity.dart';
import 'event_model.dart';

EventRegistrationEntity eventRegistrationFromJson(Map<String, dynamic> json) {
  return EventRegistrationEntity(
    id: json['id'] as String,
    eventDivisionId: json['event_division_id'] as String,
    userId: json['user_id'] as int,
    status: RegistrationStatus.fromValue(json['status'] as String?),
    paymentId: json['payment_id'] as String?,
    bibNumber: json['bib_number'] as String?,
    qrCode: json['qr_code'] as String?,
    checkedInAt: json['checked_in_at'] != null ? DateTime.parse(json['checked_in_at'] as String) : null,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
    userName: json['user_name'] as String?,
    userAvatarUrl: json['user_avatar_url'] as String?,
    division: json['division'] != null ? eventDivisionFromJson(json['division'] as Map<String, dynamic>) : null,
    event: json['event'] != null ? eventFromJson(json['event'] as Map<String, dynamic>) : null,
    targetButt: json['target_butt'] as int?,
    targetLetter: json['target_letter'] as String?,
  );
}

Map<String, dynamic> eventRegistrationToJson(EventRegistrationEntity reg) {
  return {
    'id': reg.id,
    'event_division_id': reg.eventDivisionId,
    'user_id': reg.userId,
    'status': reg.status.value,
    if (reg.paymentId != null) 'payment_id': reg.paymentId,
    if (reg.bibNumber != null) 'bib_number': reg.bibNumber,
    if (reg.qrCode != null) 'qr_code': reg.qrCode,
    if (reg.checkedInAt != null) 'checked_in_at': reg.checkedInAt!.toUtc().toIso8601String(),
    'created_at': reg.createdAt.toUtc().toIso8601String(),
    'updated_at': reg.updatedAt.toUtc().toIso8601String(),
    if (reg.targetButt != null) 'target_butt': reg.targetButt,
    if (reg.targetLetter != null) 'target_letter': reg.targetLetter,
  };
}
