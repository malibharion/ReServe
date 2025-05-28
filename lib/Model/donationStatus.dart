class DonationStatus {
  final String type;
  final String name;
  final String status;
  final String description;
  final String? imageUrl;

  DonationStatus({
    required this.type,
    required this.name,
    required this.status,
    required this.description,
    this.imageUrl,
  });
}
