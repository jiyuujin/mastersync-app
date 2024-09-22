class Staff {
  final String id;
  final String name;
  final String? imageUrl;
  final String? xId;
  final String? githubId;
  final bool isOpen;
  final int? displayOrder;
  final String createdAt;
  final String updatedAt;

  Staff({
    required this.id,
    required this.name,
    this.imageUrl,
    this.xId,
    this.githubId,
    required this.isOpen,
    this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });
}
