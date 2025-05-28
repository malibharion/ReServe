import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class YourDonationsScreen extends StatefulWidget {
  const YourDonationsScreen({super.key});

  @override
  State<YourDonationsScreen> createState() => _YourDonationsScreenState();
}

class _YourDonationsScreenState extends State<YourDonationsScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _donations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final foodRes =
        await supabase.from('donations').select().eq('user_id', userId);

    final otherRes =
        await supabase.from('other_donations').select().eq('user_id', userId);

    setState(() {
      _donations = [...foodRes, ...otherRes];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Donations'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _donations.isEmpty
              ? const Center(child: Text('No donations found.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _donations.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final donation = _donations[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: donation['image_path'] != null
                            ? NetworkImage(donation['image_path'])
                            : const AssetImage('assets/images/default_food.png')
                                as ImageProvider,
                      ),
                      title: Text(donation['product_name'] ?? 'No Name'),
                      subtitle: Text(
                          donation['product_description'] ?? 'No Description'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on,
                              size: 18, color: Colors.grey),
                          Text(
                            '${donation['city'] ?? ''}, ${donation['country'] ?? ''}',
                            style: const TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
