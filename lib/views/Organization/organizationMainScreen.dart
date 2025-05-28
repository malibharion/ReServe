import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationRequestsScreen extends StatefulWidget {
  const DonationRequestsScreen({super.key});

  @override
  State<DonationRequestsScreen> createState() => _DonationRequestsScreenState();
}

class _DonationRequestsScreenState extends State<DonationRequestsScreen> {
  final supabase = Supabase.instance.client;

  List<dynamic> donationRequests = [];
  bool isLoading = true;
  Future<void> launchMapsUrl(String latitude, String longitude) async {
    final googleMapsUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
    final androidMapUrl =
        Uri.parse("geo:$latitude,$longitude?q=$latitude,$longitude");

    try {
      if (await canLaunchUrl(androidMapUrl)) {
        await launchUrl(androidMapUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback
        await launchUrl(googleMapsUrl, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      print("Failed to launch map: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Could not open map: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    setState(() => isLoading = true);

    try {
      final data = await supabase.from('donation_requests').select('''
        id,
        status,
        created_at,
        city,
        province,
        latitude,
        longitude,
        requester:requester_id (
          username,
          mobile_number
        ),
        donation:donation_id (
          product_name,
          city,
          latitude,
          longitude,
          province,
          image_path,
          donor:user_id (
            username,
            mobile_number
          )
        )
      ''').order('created_at', ascending: false);

      setState(() {
        donationRequests = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching donation requests: $e');
      setState(() => isLoading = false);
    }
  }

  Future<String?> getImageUrl(String path) async {
    try {
      final cleanPath = path.replaceAll(
        'https://qbpptukfwaykzdyfpfay.supabase.co/storage/v1/object/public/reserve/',
        '',
      );

      return supabase.storage.from('reserve').getPublicUrl(cleanPath);
    } catch (e) {
      print('Error getting image URL: $e');
      return null;
    }
  }

  Widget buildRequestCard(dynamic item) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    final requester = item['requester'];
    final donation = item['donation'];
    final donor = donation != null ? donation['donor'] : null;
    final imagePath = donation != null ? donation['image_path'] : null;

    return FutureBuilder<String?>(
      future: imagePath != null ? getImageUrl(imagePath) : Future.value(null),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data;

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Text(
                    localizationProvider.locale.languageCode == 'en'
                        ? 'No image available'
                        : 'کوئی تصویر دستیاب نہیں',
                  ),

                const SizedBox(height: 10),

                Text(
                  donation != null
                      ? donation['product_name'] ??
                          (localizationProvider.locale.languageCode == 'en'
                              ? 'No product'
                              : 'کوئی مصنوعات نہیں')
                      : (localizationProvider.locale.languageCode == 'en'
                          ? 'No product'
                          : 'کوئی مصنوعات نہیں'),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),
                Text(
                  '${localizationProvider.locale.languageCode == 'en' ? 'Status' : 'حیثیت'}: ${item['status']}',
                  style: TextStyle(
                    color: item['status'] == 'Pending'
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),

                const Divider(height: 20, thickness: 1),

                Text(
                  localizationProvider.locale.languageCode == 'en'
                      ? 'Requester Info:'
                      : 'درخواست دہندہ کی معلومات:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  requester != null ? (requester['username'] ?? '') : '',
                ),
                Text(
                  '📍 ${item['city'] ?? ''}, ${item['province'] ?? ''}',
                ),
                Text(
                  requester != null
                      ? '📞 ${requester['mobile_number'] ?? ''}'
                      : '',
                ),

                if (item['latitude'] != null && item['longitude'] != null)
                  TextButton.icon(
                    icon: const Icon(Icons.location_on),
                    label: Text(
                      localizationProvider.locale.languageCode == 'en'
                          ? 'Requester Location (Google Maps)'
                          : 'درخواست دہندہ کا مقام (گوگل میپس)',
                    ),
                    onPressed: () {
                      final lat = item['latitude'].toString();
                      final lng = item['longitude'].toString();
                      launchMapsUrl(lat, lng);
                    },
                  ),

                // 🎁 Donor Info
                Text(
                  localizationProvider.locale.languageCode == 'en'
                      ? 'Donor Info:'
                      : 'دانی کی معلومات:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  donor != null ? (donor['username'] ?? '') : '',
                ),
                Text(
                  '📍 ${donation != null ? (donation['city'] ?? '') : ''}, ${donation != null ? (donation['province'] ?? '') : ''}',
                ),
                Text(
                  donor != null ? '📞 ${donor['mobile_number'] ?? ''}' : '',
                ),

                if (donation != null &&
                    donation['latitude'] != null &&
                    donation['longitude'] != null)
                  TextButton.icon(
                    icon: const Icon(Icons.location_on),
                    label: Text(
                      localizationProvider.locale.languageCode == 'en'
                          ? 'Donor Location (Google Maps)'
                          : 'دانی کا مقام (گوگل میپس)',
                    ),
                    onPressed: () {
                      final donorLat = donation['latitude'].toString();
                      final donorLng = donation['longitude'].toString();
                      launchMapsUrl(donorLat, donorLng);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5DCE35),
        title: Text(
          localizationProvider.locale.languageCode == 'en'
              ? 'Donation Requests'
              : 'عطیہ کی درخواستیں',
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchRequests,
              child: ListView.builder(
                itemCount: donationRequests.length,
                itemBuilder: (context, index) {
                  return buildRequestCard(donationRequests[index]);
                },
              ),
            ),
    );
  }
}
