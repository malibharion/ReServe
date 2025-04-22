import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class DonationService {
  final supabase = Supabase.instance.client;

  Future<String> uploadImage(File imageFile) async {
    print("🖼️ Uploading image...");
    final fileName =
        'donation_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final response =
        await supabase.storage.from('reserve').upload(fileName, imageFile);

    if (response.isEmpty) {
      print("❌ Image upload failed. Response is empty.");
      throw Exception('Failed to upload image');
    }

    final publicUrl = supabase.storage.from('reserve').getPublicUrl(fileName);
    print("✅ Image uploaded successfully. Public URL: $publicUrl");
    return publicUrl;
  }

  //Other Donations
  Future<void> otherItems({
    required String productName,
    required String productDescription,
    required String imageUrl,
    required double latitude,
    required double longitude,
    required String city,
    required String area,
    required String province,
    required String country,
    required String userId,
  }) async {
    print("📦 Sending donation request...");
    print("Product: $productName");
    print("Description: $productDescription");
    print("Location: $latitude, $longitude");
    print("Address: $city, $area, $province, $country");
    print("User ID: $userId");

    final response = await supabase.from('other_donations').insert({
      'product_name': productName,
      'product_description': productDescription,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'area': area,
      'province': province,
      'country': country,
      'image_path': imageUrl,
      'user_id': userId,
    });

    print("✅ Donation request sent successfully. Response: $response");
  }

//Food Donations
  Future<void> donateFoodItem({
    required String productName,
    required String productDescription,
    required String imageUrl,
    required double latitude,
    required double longitude,
    required String city,
    required String area,
    required String province,
    required String country,
    required String userId,
  }) async {
    print("📦 Sending donation request...");
    print("Product: $productName");
    print("Description: $productDescription");
    print("Location: $latitude, $longitude");
    print("Address: $city, $area, $province, $country");
    print("User ID: $userId");

    final response = await supabase.from('donations').insert({
      'product_name': productName,
      'product_description': productDescription,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'area': area,
      'province': province,
      'country': country,
      'image_path': imageUrl,
      'user_id': userId,
    });

    print("✅ Donation request sent successfully. Response: $response");
  }

  Future<List<Map<String, dynamic>>> fetchDonations() async {
    final response = await supabase
        .from('donations')
        .select('*, user_profiles(username, mobile_number)')
        .order('created_at', ascending: false);

    return response as List<Map<String, dynamic>>;
  }

  Future<void> requestDonation({
    required String donationId,
    required String requesterId,
    required String city,
    required String area,
    required String province,
    required String country,
  }) async {
    await supabase.from('donation_requests').insert({
      'donation_id': donationId,
      'requester_id': requesterId,
      'city': city,
      'area': area,
      'province': province,
      'country': country,
    });
  }
}
