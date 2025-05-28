import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<int?> fetchCurrentUserId() async {
  try {
    final userUUID = supabase.auth.currentUser?.id;
    if (userUUID == null) return null;

    final data = await supabase
        .from('user_profiles')
        .select('id')
        .eq('auth_user_id', userUUID)
        .maybeSingle();

    if (data == null) {
      print('No user profile found for UUID: $userUUID');
      return null;
    }

    return data['id'] as int?;
  } catch (e) {
    print('Error fetching user profile: $e');
    return null;
  }
}
