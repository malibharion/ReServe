import 'package:reserve/Model/organizatioFood.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<FoodOragnizationDonationModel>> fetchFoodDonations(
      DateTime? start, DateTime? end) async {
    final response = await _client
        .from('donations')
        .select()
        .gte('created_at', start?.toIso8601String() ?? '2000-01-01')
        .lte('created_at',
            end?.toIso8601String() ?? DateTime.now().toIso8601String());

    return (response as List)
        .map((e) => FoodOragnizationDonationModel.fromMap(e))
        .toList();
  }

  Future<List<OtherDonationOrganizationModel>> fetchOtherDonations(
      DateTime? start, DateTime? end) async {
    final response = await _client
        .from('other_donations')
        .select()
        .gte('created_at', start?.toIso8601String() ?? '2000-01-01')
        .lte('created_at',
            end?.toIso8601String() ?? DateTime.now().toIso8601String());

    return (response as List)
        .map((e) => OtherDonationOrganizationModel.fromMap(e))
        .toList();
  }

  Future<List<StudentHelpRequestModel>> fetchStudentHelpRequests(
      DateTime? start, DateTime? end) async {
    final response = await _client
        .from('student_help_requests')
        .select()
        .gte('created_at', start?.toIso8601String() ?? '2000-01-01')
        .lte('created_at',
            end?.toIso8601String() ?? DateTime.now().toIso8601String());

    return (response as List)
        .map((e) => StudentHelpRequestModel.fromMap(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchMyDonationRequests(
      String userId) async {
    final foodRequests = await _client
        .from('donation_requests')
        .select(
            'status, created_at, donation_id, donations(product_name, image_path)')
        .eq('requester_id', userId);

    final otherRequests = await _client
        .from('other_donation_requests')
        .select(
            'status, created_at, other_donation_id, other_donations(product_name, image_path)')
        .eq('requestor_id', userId);

    return [
      ...foodRequests.map((e) => {
            'type': 'Food',
            'status': e['status'],
            'created_at': e['created_at'],
            'product_name': e['donations']?['product_name'],
            'image_path': e['donations']?['image_path'],
          }),
      ...otherRequests.map((e) => {
            'type': 'Other',
            'status': e['status'],
            'created_at': e['created_at'],
            'product_name': e['other_donations']?['product_name'],
            'image_path': e['other_donations']?['image_path'],
          }),
    ];
  }
}
