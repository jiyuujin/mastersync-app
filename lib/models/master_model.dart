class Master {
  final String id;
  final String name;
  final String ownerName;
  final String? imageUrl;
  final String? memo;
  final bool isSameDayDisposal;
  final bool isOpen;
  final String createdAt;
  final String updatedAt;

  Master({
    required this.id,
    required this.name,
    required this.ownerName,
    this.imageUrl,
    this.memo,
    required this.isSameDayDisposal,
    required this.isOpen,
    required this.createdAt,
    required this.updatedAt,
  });
}
