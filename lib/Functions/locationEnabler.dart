import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static Future<Map<String, String>?> getAddressFromLatLng(
      Position position) async {
    try {
      print(
          "📍 Starting reverse geocoding for: ${position.latitude}, ${position.longitude}");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      print("✅ Placemarks fetched: ${placemarks.length}");

      if (placemarks.isEmpty) {
        print("⚠️ No placemarks returned.");
        return null;
      }

      final Placemark placemark = placemarks.first;

      print("✅ Placemark details:");
      print("City: ${placemark.locality}");
      print("Province/State: ${placemark.administrativeArea}");
      print("Country: ${placemark.country}");

      return {
        'city': placemark.locality ?? 'Unknown',
        'province': placemark.administrativeArea ?? 'Unknown',
        'country': placemark.country ?? 'Unknown',
      };
    } catch (e) {
      print("❌ Error in getAddressFromLatLng: $e");
      return null;
    }
  }
}
