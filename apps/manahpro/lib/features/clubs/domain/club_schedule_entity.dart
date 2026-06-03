class ClubScheduleEntity {
  const ClubScheduleEntity({
    required this.id,
    required this.organizationId,
    required this.title,
    this.description,
    this.location,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
    this.myAttendance,
  });

  final String id;
  final String organizationId;
  final String title;
  final String? description;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;
  final int createdBy;
  final ClubAttendanceStatusEntity? myAttendance;

  factory ClubScheduleEntity.fromJson(Map<String, dynamic> json) {
    return ClubScheduleEntity(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      location: json['location'] as String?,
      startTime: DateTime.parse(json['start_time'] as String).toLocal(),
      endTime: DateTime.parse(json['end_time'] as String).toLocal(),
      createdBy: json['created_by'] as int? ?? 0,
      myAttendance: json['my_attendance'] != null
          ? ClubAttendanceStatusEntity.fromJson(
              json['my_attendance'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ClubAttendanceStatusEntity {
  const ClubAttendanceStatusEntity({
    this.id,
    required this.status,
    this.remark,
  });

  final String? id;
  final String status;
  final String? remark;

  factory ClubAttendanceStatusEntity.fromJson(Map<String, dynamic> json) {
    return ClubAttendanceStatusEntity(
      id: json['id'] as String?,
      status: json['status'] as String? ?? 'absent',
      remark: json['remark'] as String?,
    );
  }
}

class ClubAttendanceEntity {
  const ClubAttendanceEntity({
    this.id,
    required this.userId,
    this.fullName,
    this.username,
    this.avatarUrl,
    this.status,
    this.remark,
  });

  final String? id;
  final int userId;
  final String? fullName;
  final String? username;
  final String? avatarUrl;
  final String? status;
  final String? remark;

  factory ClubAttendanceEntity.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return ClubAttendanceEntity(
      id: json['id'] as String?,
      userId: user?['id'] as int? ?? 0,
      fullName: user?['full_name'] as String?,
      username: user?['username'] as String?,
      avatarUrl: user?['avatar_url'] as String?,
      status: json['status'] as String?,
      remark: json['remark'] as String?,
    );
  }
}

class ClubMyAttendanceHistoryEntity {
  const ClubMyAttendanceHistoryEntity({
    required this.id,
    required this.status,
    this.remark,
    this.markedAt,
    required this.scheduleTitle,
    required this.scheduleStartTime,
  });

  final String id;
  final String status;
  final String? remark;
  final DateTime? markedAt;
  final String scheduleTitle;
  final DateTime scheduleStartTime;

  factory ClubMyAttendanceHistoryEntity.fromJson(Map<String, dynamic> json) {
    final sched = json['schedule'] as Map<String, dynamic>;
    return ClubMyAttendanceHistoryEntity(
      id: json['id'] as String,
      status: json['status'] as String? ?? 'absent',
      remark: json['remark'] as String?,
      markedAt: json['marked_at'] != null ? DateTime.parse(json['marked_at'] as String).toLocal() : null,
      scheduleTitle: sched['title'] as String? ?? '',
      scheduleStartTime: DateTime.parse(sched['start_time'] as String).toLocal(),
    );
  }
}

