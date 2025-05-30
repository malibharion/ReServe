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
    Future<String?> getProfileImageUrl(String? path) async {
      if (path == null || path.isEmpty) return null;

      try {
        // If the path already looks like a full URL, just return it directly
        if (path.startsWith('http')) {
          print('Profile image path is full URL: $path');
          return path;
        }

        // Otherwise, treat path as relative and get public URL from storage
        print('Profile image path is relative: $path');
        final publicUrl = supabase.storage.from('reserve').getPublicUrl(path);
        print('Generated public URL: $publicUrl');
        return publicUrl;
      } catch (e) {
        print('Error getting profile image URL: $e');
        return null;
      }
    }

    Future<void> updateStatus(String newStatus) async {
      try {
        final requestId = item['id'];
        if (requestId == null) return;

        await supabase
            .from('donation_requests')
            .update({'status': newStatus}).eq('id', requestId);

        setState(() {
          item['status'] = newStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to $newStatus')),
        );
      } catch (e) {
        print('Error updating status: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $e')),
        );
      }
    }

    return FutureBuilder<String?>(
      future: imagePath != null ? getImageUrl(imagePath) : Future.value(null),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data;

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          elevation: 6,
          shadowColor: Colors.green.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) =>
                          progress == null
                              ? child
                              : SizedBox(
                                  height: 180,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                ),
                      errorBuilder: (_, __, ___) =>
                          const Center(child: Text('Image not available')),
                    ),
                  )
                else
                  Text(
                    localizationProvider.locale.languageCode == 'en'
                        ? 'No image available'
                        : 'کوئی تصویر دستیاب نہیں',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                const SizedBox(height: 15),
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
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      localizationProvider.locale.languageCode == 'en'
                          ? 'Status: '
                          : 'حیثیت: ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: item['status'] == 'Pending'
                            ? Colors.orange[300]
                            : (item['status'] == 'Approved'
                                ? Colors.green[300]
                                : Colors.red[300]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['status'] ?? 'Unknown',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 25, thickness: 1),
                Row(
                  children: [
                    FutureBuilder<String?>(
                      future: getProfileImageUrl(requester != null
                          ? requester['user_profile_pic']
                          : null),
                      builder: (context, snap) {
                        final url = snap.data;
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              url != null ? NetworkImage(url) : null,
                          child: url == null
                              ? Text(
                                  localizationProvider.locale.languageCode ==
                                          'en'
                                      ? 'No\nProfile'
                                      : 'کوئی\nپروفائل نہیں',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[700]),
                                )
                              : null,
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizationProvider.locale.languageCode == 'en'
                                ? 'Requester Info'
                                : 'درخواست دہندہ کی معلومات',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[800]),
                          ),
                          Text(requester != null
                              ? (requester['username'] ?? '')
                              : ''),
                          Text(
                            '📍 ${item['city'] ?? ''}, ${item['province'] ?? ''}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(requester != null
                              ? '📞 ${requester['mobile_number'] ?? ''}'
                              : ''),
                        ],
                      ),
                    ),
                  ],
                ),
                if (item['latitude'] != null && item['longitude'] != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.location_on, color: Colors.green),
                      label: Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? 'Requester Location'
                            : 'درخواست دہندہ کا مقام',
                        style: const TextStyle(color: Colors.green),
                      ),
                      onPressed: () {
                        final lat = item['latitude'].toString();
                        final lng = item['longitude'].toString();
                        launchMapsUrl(lat, lng);
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FutureBuilder<String?>(
                      future: getProfileImageUrl(
                          donor != null ? donor['user_profile_pic'] : null),
                      builder: (context, snap) {
                        final url = snap.data;
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              url != null ? NetworkImage(url) : null,
                          child: url == null
                              ? Text(
                                  localizationProvider.locale.languageCode ==
                                          'en'
                                      ? 'No\nProfile'
                                      : 'کوئی\nپروفائل نہیں',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[700]),
                                )
                              : null,
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizationProvider.locale.languageCode == 'en'
                                ? 'Donor Info'
                                : 'دانی کی معلومات',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[800]),
                          ),
                          Text(donor != null ? (donor['username'] ?? '') : ''),
                          Text(
                            '📍 ${donation != null ? (donation['city'] ?? '') : ''}, ${donation != null ? (donation['province'] ?? '') : ''}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(donor != null
                              ? '📞 ${donor['mobile_number'] ?? ''}'
                              : ''),
                        ],
                      ),
                    ),
                  ],
                ),
                if (donation != null &&
                    donation['latitude'] != null &&
                    donation['longitude'] != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.location_on, color: Colors.green),
                      label: Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? 'Donor Location'
                            : 'دانی کا مقام',
                        style: const TextStyle(color: Colors.green),
                      ),
                      onPressed: () {
                        final donorLat = donation['latitude'].toString();
                        final donorLng = donation['longitude'].toString();
                        launchMapsUrl(donorLat, donorLng);
                      },
                    ),
                  ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle),
                      label: Text(
                          localizationProvider.locale.languageCode == 'en'
                              ? 'Approve'
                              : 'منظور کریں'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: item['status'] == 'Approved'
                          ? null
                          : () => updateStatus('Approved'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: Text(
                          localizationProvider.locale.languageCode == 'en'
                              ? 'Reject'
                              : 'رد کریں'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: item['status'] == 'Rejected'
                          ? null
                          : () => updateStatus('Rejected'),
                    ),
                  ],
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
