class LogsStatusMasterSync {
  final String id;
  final String masterId;
  final String? assignedTeamName;
  final String? assigneeName;
  final int? count;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  LogsStatusMasterSync({
    required this.id,
    required this.masterId,
    this.assignedTeamName,
    this.assigneeName,
    this.count,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
