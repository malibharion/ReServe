import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DonationRequestsScreen extends StatefulWidget {
  const DonationRequestsScreen({super.key});

  @override
  State<DonationRequestsScreen> createState() => _DonationRequestsScreenState();
}

class _DonationRequestsScreenState extends State<DonationRequestsScreen> {
  final supabase = Supabase.instance.client;

  List<dynamic> donationRequests = [];
  bool isLoading = true;

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
        requester:requester_id (
          username,
          mobile_number
        ),
        donation:donation_id (
          product_name,
          city,
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
      // Remove any existing URL parts if present
      final cleanPath = path.replaceAll(
        'https://qbpptukfwaykzdyfpfay.supabase.co/storage/v1/object/public/reserve/',
        '',
      );

      // Get the public URL
      return supabase.storage.from('reserve').getPublicUrl(cleanPath);
    } catch (e) {
      print('Error getting image URL: $e');
      return null;
    }
  }

  Widget buildRequestCard(dynamic item) {
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
                // 🖼️ Image
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
                  const Text('No image available'),

                const SizedBox(height: 10),

                // 📦 Product Name
                Text(
                  donation != null
                      ? donation['product_name'] ?? 'No product'
                      : 'No product',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text('Status: ${item['status']}',
                    style: TextStyle(
                      color: item['status'] == 'Pending'
                          ? Colors.orange
                          : Colors.green,
                    )),
                const Divider(height: 20, thickness: 1),

                // 👤 Requester Info
                Text('Requester Info:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[800])),
                Text(requester != null ? (requester['username'] ?? '') : ''),
                Text('📍 ${item['city'] ?? ''}, ${item['province'] ?? ''}'),
                Text(requester != null
                    ? ('📞 ${requester['mobile_number'] ?? ''}')
                    : ''),
                const SizedBox(height: 10),

                // 🎁 Donor Info
                Text('Donor Info:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[800])),
                Text(donor != null ? (donor['username'] ?? '') : ''),
                Text(
                    '📍 ${donation != null ? (donation['city'] ?? '') : ''}, ${donation != null ? (donation['province'] ?? '') : ''}'),
                Text(donor != null
                    ? ('📞 ${donor['mobile_number'] ?? ''}')
                    : ''),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5DCE35),
        title: const Text('Donation Requests'),
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
