import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reserve/Functions/locationEnabler.dart';
import 'package:reserve/Model/donation.dart';
import 'package:reserve/Model/otherDonationModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DonationProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Donation> _donations = [];
  List<OtherDonation> _otherdonations = [];
  File? _selectedImage;
  Position? _currentPosition;
  Map<String, String>? _currentAddress;
  List<Donation> get donations => _donations;
  List<OtherDonation> get otherDonationsItems => _otherdonations;
  bool _isLoading = false;

  File? get selectedImage => _selectedImage;
  Position? get currentPosition => _currentPosition;
  Map<String, String>? get currentAddress => _currentAddress;
  bool get isLoading => _isLoading;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    print("🔸 pickImage() called");
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> captureLocation() async {
    print("🔸 captureLocation() called");
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      _currentPosition = position;

      final address = await LocationService.getAddressFromLatLng(position);
      if (address != null) {
        _currentAddress = address;
      }

      print("📍 Captured Position: $_currentPosition");
      print("🗺️ Captured Address: $_currentAddress");
      notifyListeners();
    } else {
      print("❌ Location capture failed. Position is null.");
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clear() {
    _selectedImage = null;
    _currentPosition = null;
    _currentAddress = null;
    _isLoading = false;
    notifyListeners();
  }

  //Fetch other donations
  Future<void> fetchOtherDonation() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase
          .from('other_donations')
          .select('*, user_profiles(username, mobile_number)')
          .order('created_at', ascending: false);

      _otherdonations = (response as List)
          .map((data) => OtherDonation.fromJson(data))
          .toList();
      print(_otherdonations);
    } catch (e) {
      print('Error fetching donations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //--------------------

  Future<void> fetchDonations() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase
          .from('donations')
          .select('*, user_profiles(username, mobile_number)')
          .order('created_at', ascending: false);

      _donations =
          (response as List).map((data) => Donation.fromJson(data)).toList();
      print(_donations);
    } catch (e) {
      print('Error fetching donations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //request other donations
  Future<void> otherDonations({
    required bool isFood,
    required String donationId,
    required String requesterId,
    required String city,
    required String area,
    required String province,
    required String country,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _supabase.from('other_donation_requests').insert({
        'isfood': isFood,
        'other_donation_id': donationId,
        'requester_id': requesterId,
        'city': city,
        'area': area,
        'province': province,
        'country': country,
      });
    } catch (e) {
      print('Error requesting donation: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //--------------------

  Future<void> requestDonation({
    required bool isFood,
    required String donationId,
    required String requesterId,
    required String city,
    required String area,
    required String province,
    required String country,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _supabase.from('donation_requests').insert({
        'isFood': isFood,
        'donation_id': donationId,
        'requester_id': requesterId,
        'city': city,
        'area': area,
        'province': province,
        'country': country,
      });
    } catch (e) {
      print('Error requesting donation: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
