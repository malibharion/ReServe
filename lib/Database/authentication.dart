import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  final SupabaseClient _client = Supabase.instance.client;
  Future<String?> signup(
      {required String email,
      required String password,
      required String username,
      required String mobileNumber,
      required String cnic}) async {
    try {
      final authResponse =
          await _client.auth.signUp(email: email, password: password);

      if (authResponse.user == null) {
        print("Signup failed — no user created.");
        return "Signup failed — no user created.";
      }

      final insertResponse = await _client.from('user_profiles').insert({
        'email': email,
        'id': authResponse.user!.id,
        'username': username,
        'mobile_number': mobileNumber,
        'cnic': cnic,
        'role': 'user'
      });
      print(insertResponse);
      return null;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  // Log in existing user
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Log out
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
