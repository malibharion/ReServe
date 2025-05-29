import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherDonationsScreen extends StatefulWidget {
  const OtherDonationsScreen({super.key});

  @override
  State<OtherDonationsScreen> createState() => _OtherDonationsScreenState();
}

class _OtherDonationsScreenState extends State<OtherDonationsScreen> {
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
      final data = await supabase.from('other_donation_requests').select('''
      status,
      created_at,
      city,
      province,
      latitude,
      longitude,
      other_donation_id,
      requestor_id,
      requester:requestor_id (
        username,
        mobile_number,
        user_profile_pic
      ),
      donation:other_donation_id (
        id,
        product_name,
        city,
        latitude,
        longitude,
        province,
        image_path,
        donor:user_id (
          username,
          mobile_number,
          user_profile_pic
        )
      )
    ''').order('created_at', ascending: false);

      // Transform the data to include a composite ID for easier reference
      final transformedData = data.map((item) {
        return {
          ...item,
          'id':
              '${item['other_donation_id']}_${item['requestor_id']}', // Create a composite ID
        };
      }).toList();

      setState(() {
        donationRequests = transformedData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching other donation requests: $e');
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

  Future<void> updateStatus(String newStatus, String compositeId) async {
    try {
      print(
          '🔄 Attempting to update status to $newStatus for compositeId: $compositeId');

      final ids = compositeId.split('_');
      if (ids.length != 2) {
        print(
            '❌ Invalid compositeId format. Expected format: otherDonationId_requestorId');
        return;
      }

      final otherDonationId = ids[0];
      final requestorId = ids[1];

      // Update status in other_donation_requests
      final updateRequestResponse = await supabase
          .from('other_donation_requests')
          .update({'status': newStatus})
          .eq('other_donation_id', otherDonationId)
          .eq('requestor_id', requestorId);

      print('✅ Updated other_donation_requests: $updateRequestResponse');

      // Update status in other_donations table
      final updateDonationResponse = await supabase
          .from('other_donations')
          .update({'status': newStatus}).eq('id', otherDonationId);

      print('✅ Updated other_donations: $updateDonationResponse');

      setState(() {
        donationRequests = donationRequests.map((item) {
          if (item['id'] == compositeId) {
            return {...item, 'status': newStatus};
          }
          return item;
        }).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $newStatus')),
      );
    } catch (e) {
      print('❌ Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
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
        if (path.startsWith('http')) return path;
        return supabase.storage.from('reserve').getPublicUrl(path);
      } catch (e) {
        print('Error getting profile image URL: $e');
        return null;
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
          shadowColor: Colors.blue.withOpacity(0.3),
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
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? 'No image available'
                            : 'کوئی تصویر دستیاب نہیں',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                const SizedBox(height: 15),
                Text(
                  donation != null
                      ? donation['product_name'] ?? 'No product'
                      : 'No product',
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
                      future:
                          getProfileImageUrl(requester?['user_profile_pic']),
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
                          Text(requester?['username'] ?? ''),
                          Text(
                            '📍 ${item['city'] ?? ''}, ${item['province'] ?? ''}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(requester?['mobile_number'] ?? ''),
                        ],
                      ),
                    ),
                  ],
                ),
                if (item['latitude'] != null && item['longitude'] != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.location_on, color: Colors.blue),
                      label: Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? 'Requester Location'
                            : 'درخواست دہندہ کا مقام',
                        style: const TextStyle(color: Colors.blue),
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
                      future: getProfileImageUrl(donor?['user_profile_pic']),
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
                          Text(donor?['username'] ?? ''),
                          Text(
                            '📍 ${donation?['city'] ?? ''}, ${donation?['province'] ?? ''}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(donor?['mobile_number'] ?? ''),
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
                      icon: const Icon(Icons.location_on, color: Colors.blue),
                      label: Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? 'Donor Location'
                            : 'دانی کا مقام',
                        style: const TextStyle(color: Colors.blue),
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
                          : () => updateStatus('Approved', item['id']),
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
                          : () => updateStatus('Rejected', item['id']),
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
        backgroundColor: const Color(0xFF4285F4),
        title: Text(
          localizationProvider.locale.languageCode == 'en'
              ? 'Other Donation Requests'
              : 'دیگر عطیہ کی درخواستیں',
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
