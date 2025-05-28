import 'package:supabase_flutter/supabase_flutter.dart';

void setupDonationListener(Function(Map<String, dynamic>) onNewDonation) {
  final supabase = Supabase.instance.client;

  supabase
      .from('donations')
      .stream(primaryKey: ['id'])
      .order('created_at')
      .listen((donationRows) {
        if (donationRows.isNotEmpty) {
          onNewDonation(donationRows.last);
        }
      });
}
