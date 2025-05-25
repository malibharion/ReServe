// models/student_help_request.dart
class StudentHelpRequest {
  final String id;
  final String name;
  final String fatherName;
  final String feeSlipUrl;
  final String cnicUrl;
  final DateTime createdAt;
  final String status;

  StudentHelpRequest({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.feeSlipUrl,
    required this.cnicUrl,
    required this.createdAt,
    this.status = 'Pending',
  });

  factory StudentHelpRequest.fromMap(Map<String, dynamic> data) {
    return StudentHelpRequest(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      fatherName: data['father_name'] ?? '',
      feeSlipUrl: data['fee_slip_url'] ?? '',
      cnicUrl: data['cnic_url'] ?? '',
      createdAt: DateTime.parse(data['created_at']),
      status: data['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'father_name': fatherName,
      'fee_slip_url': feeSlipUrl,
      'cnic_url': cnicUrl,
      'status': status,
    };
  }
}
