class OtherDonation {
  final String id;
  final String productName;
  final String productDescription;
  final String imagePath;
  final String area;
  final String city;
  final String province;
  final String country;
  final String userId;
  final String? username;
  final String? mobileNumber;
  final DateTime createdAt;

  OtherDonation({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.imagePath,
    required this.area,
    required this.city,
    required this.province,
    required this.country,
    required this.userId,
    this.username,
    this.mobileNumber,
    required this.createdAt,
  });

  factory OtherDonation.fromJson(Map<String, dynamic> json) {
    final String rawImagePath = json['image_path'];
    print('📝 Raw image_path from DB: $rawImagePath');

    String finalImageUrl;

    if (rawImagePath.startsWith('http')) {
      finalImageUrl = rawImagePath;
      print('✅ imagePath is already a full URL: $finalImageUrl');
    } else {
      final String baseUrl =
          'https://qbpptukfwaykzdyfpfay.supabase.co/storage/v1/object/public/reserve/';
      finalImageUrl = baseUrl + rawImagePath;
      print('🛠️ Built full image URL: $finalImageUrl');
    }

    return OtherDonation(
      id: json['id'],
      productName: json['product_name'],
      productDescription: json['product_description'],
      imagePath: finalImageUrl,
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      country: json['country'] ?? '',
      userId: json['user_id'],
      username: json['user_profiles']?['username'],
      mobileNumber: json['user_profiles']?['mobile_number'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'product_description': productDescription,
      'image_path': imagePath,
      'area': area,
      'city': city,
      'province': province,
      'country': country,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      // username & mobileNumber are not usually sent back in API requests
    };
  }
}
