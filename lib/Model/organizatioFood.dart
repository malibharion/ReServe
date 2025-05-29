class FoodOragnizationDonationModel {
  final String id;
  final String productName;
  final String? description;
  final String? city;
  final DateTime createdAt;

  FoodOragnizationDonationModel({
    required this.id,
    required this.productName,
    this.description,
    this.city,
    required this.createdAt,
  });

  factory FoodOragnizationDonationModel.fromMap(Map<String, dynamic> map) {
    return FoodOragnizationDonationModel(
      id: map['id'],
      productName: map['product_name'],
      description: map['product_description'],
      city: map['city'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

class OtherDonationOrganizationModel {
  final String id;
  final String productName;
  final String? description;
  final String? city;
  final DateTime createdAt;

  OtherDonationOrganizationModel({
    required this.id,
    required this.productName,
    this.description,
    this.city,
    required this.createdAt,
  });

  factory OtherDonationOrganizationModel.fromMap(Map<String, dynamic> map) {
    return OtherDonationOrganizationModel(
      id: map['id'],
      productName: map['product_name'],
      description: map['product_description'],
      city: map['city'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

class StudentHelpRequestModel {
  final String id;
  final String name;
  final String? fatherName;
  final String? feeSlipUrl;
  final String? cnicUrl;
  final String? status;
  final DateTime createdAt;

  StudentHelpRequestModel({
    required this.id,
    required this.name,
    this.fatherName,
    this.feeSlipUrl,
    this.cnicUrl,
    this.status,
    required this.createdAt,
  });

  factory StudentHelpRequestModel.fromMap(Map<String, dynamic> map) {
    return StudentHelpRequestModel(
      id: map['id'],
      name: map['name'],
      fatherName: map['father_name'],
      feeSlipUrl: map['fee_slip_url'],
      cnicUrl: map['cnic_url'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
