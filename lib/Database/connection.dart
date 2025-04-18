import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConnection {
  static const String Url = 'https://qbpptukfwaykzdyfpfay.supabase.co';
  static const String key =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFicHB0dWtmd2F5a3pkeWZwZmF5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQyNTgwNzcsImV4cCI6MjA1OTgzNDA3N30.sx10HHwnLSa_fle2_PZcoSygPntwSngBlqDOIwzNyc8';
  static Future initialize() async {
    await Supabase.initialize(url: Url, anonKey: key);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
