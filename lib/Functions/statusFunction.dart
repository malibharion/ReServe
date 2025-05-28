import 'package:reserve/Model/donationStatus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<DonationStatus>> fetchUserStatuses(String userId) async {
  final supabase = Supabase.instance.client;
  List<DonationStatus> result = [];

  print('🔄 Fetching Food Donations for userId: $userId');
  final foodDonations = await supabase
      .from('donations')
      .select(
          'id, product_name, product_description, image_path, status') // ✅ include status
      .eq('user_id', userId)
      .order('created_at', ascending: false);

  for (final donation in foodDonations) {
    final requestStatusResponse = await supabase
        .from('donation_requests')
        .select('status')
        .eq('donation_id', donation['id'])
        .eq('requester_id', userId)
        .maybeSingle();

    final fallbackStatus = donation['status'] ?? 'Unknown';
    final finalStatus = requestStatusResponse != null
        ? requestStatusResponse['status']
        : fallbackStatus;

    print(
        '📦 Food Donation: ${donation['product_name']} - Status: $finalStatus');

    result.add(DonationStatus(
      type: 'Food Donation',
      name: donation['product_name'] ?? 'Unnamed',
      description: donation['product_description'] ?? '',
      status: finalStatus,
      imageUrl: donation['image_path'],
    ));
  }

  print('🔄 Fetching Other Donations for userId: $userId');
  final otherDonations = await supabase
      .from('other_donations')
      .select(
          'id, product_name, product_description, image_path, status') // ✅ include status
      .eq('user_id', userId)
      .order('created_at', ascending: false);

  for (final donation in otherDonations) {
    final requestStatusResponse = await supabase
        .from('other_donation_requests')
        .select('status')
        .eq('other_donation_id', donation['id'])
        .eq('requester_id', userId)
        .maybeSingle();

    final fallbackStatus = donation['status'] ?? 'Unknown';
    final finalStatus = requestStatusResponse != null
        ? requestStatusResponse['status']
        : fallbackStatus;

    print(
        '📦 Other Donation: ${donation['product_name']} - Status: $finalStatus');

    result.add(DonationStatus(
      type: 'Other Donation',
      name: donation['product_name'] ?? 'Unnamed',
      description: donation['product_description'] ?? '',
      status: finalStatus,
      imageUrl: donation['image_path'],
    ));
  }

  print('🔄 Fetching Food Donation Requests made by userId: $userId');
  final foodDonationRequests = await supabase
      .from('donation_requests')
      .select(
          'status, donation_id, donations(product_name, product_description, image_path)')
      .eq('requester_id', userId)
      .eq('isFood', true)
      .order('created_at', ascending: false);

  for (final request in foodDonationRequests) {
    final donation = request['donations'];
    final status = request['status'] ?? 'Pending';

    print('📨 Food Request for ${donation?['product_name']} - Status: $status');

    result.add(DonationStatus(
      type: 'Food Donation Request',
      name: donation?['product_name'] ?? 'Unnamed',
      description: donation?['product_description'] ?? '',
      status: status,
      imageUrl: donation?['image_path'],
    ));
  }

  print('🔄 Fetching Other Donation Requests made by userId: $userId');
  final otherDonationRequests = await supabase
      .from('other_donation_requests')
      .select(
          'status, other_donation_id, other_donations(product_name, product_description, image_path)')
      .eq('requester_id', userId)
      .eq('isfood', false)
      .order('created_at', ascending: false);

  for (final request in otherDonationRequests) {
    final donation = request['other_donations'];
    final status = request['status'] ?? 'Pending';

    print(
        '📨 Other Request for ${donation?['product_name']} - Status: $status');

    result.add(DonationStatus(
      type: 'Other Donation Request',
      name: donation?['product_name'] ?? 'Unnamed',
      description: donation?['product_description'] ?? '',
      status: status,
      imageUrl: donation?['image_path'],
    ));
  }

  print('🔄 Fetching Student Help Requests');
  final studentHelpRequests = await supabase
      .from('student_help_requests')
      .select('id, name, father_name, status')
      .order('created_at', ascending: false);

  for (final helpRequest in studentHelpRequests) {
    final status = helpRequest['status'] ?? 'Pending';

    print(
        '👨‍🎓 Student Help Request: ${helpRequest['name']} - Status: $status');

    result.add(DonationStatus(
      type: 'Student Help Request',
      name: helpRequest['name'] ?? 'Unnamed',
      description: helpRequest['father_name'] ?? '',
      status: status,
      imageUrl: null,
    ));
  }

  print('✅ Total statuses fetched: ${result.length}');
  return result;
}
