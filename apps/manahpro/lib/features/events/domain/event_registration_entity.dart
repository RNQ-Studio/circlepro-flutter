import 'event_division_entity.dart';
import 'event_entity.dart';
import 'event_enums.dart';

class EventRegistrationEntity {
  const EventRegistrationEntity({
    required this.id,
    required this.eventDivisionId,
    required this.userId,
    required this.status,
    this.paymentId,
    this.bibNumber,
    this.qrCode,
    this.checkedInAt,
    required this.createdAt,
    required this.updatedAt,
    this.division,
    this.event,
    this.userName,
    this.userAvatarUrl,
    this.targetButt,
    this.targetLetter,
  });

  final String id;
  final String eventDivisionId;
  final int userId;
  final RegistrationStatus status;
  final String? paymentId;
  final String? bibNumber;
  final String? qrCode;
  final DateTime? checkedInAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Optionals / Loaded relations
  final EventDivisionEntity? division;
  final EventEntity? event;
  final String? userName;
  final String? userAvatarUrl;
  final int? targetButt;
  final String? targetLetter;

  EventRegistrationEntity copyWith({
    String? id,
    String? eventDivisionId,
    int? userId,
    RegistrationStatus? status,
    String? paymentId,
    String? bibNumber,
    String? qrCode,
    DateTime? checkedInAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    EventDivisionEntity? division,
    EventEntity? event,
    String? userName,
    String? userAvatarUrl,
    int? targetButt,
    String? targetLetter,
  }) {
    return EventRegistrationEntity(
      id: id ?? this.id,
      eventDivisionId: eventDivisionId ?? this.eventDivisionId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      paymentId: paymentId ?? this.paymentId,
      bibNumber: bibNumber ?? this.bibNumber,
      qrCode: qrCode ?? this.qrCode,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      division: division ?? this.division,
      event: event ?? this.event,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      targetButt: targetButt ?? this.targetButt,
      targetLetter: targetLetter ?? this.targetLetter,
    );
  }
}
