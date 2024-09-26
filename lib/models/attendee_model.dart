class Attendee {
  final String id;
  final String userId;
  final String displayName;
  final String role;
  final String? imageUrl;
  final String? receiptId;
  final String? activatedAt;
  final String createdAt;
  final String updatedAt;

  Attendee({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.role,
    this.imageUrl,
    this.receiptId,
    this.activatedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
