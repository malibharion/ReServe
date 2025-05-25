import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/Functions/locationEnabler.dart';
import 'package:reserve/Model/donation.dart';
import 'package:reserve/StateManagment/Donations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodDetailScreen extends StatefulWidget {
  final Donation donation;
  const FoodDetailScreen({super.key, required this.donation});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F2),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.donation.id,
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      image: DecorationImage(
                        image: NetworkImage(widget.donation.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ListView(
                  children: [
                    Text(
                      widget.donation.productName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'semi-bold',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.donation.productDescription.isNotEmpty
                          ? widget.donation.productDescription
                          : 'No description provided.',
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    if (widget.donation.username != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Donated by',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            widget.donation.username!,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    if (widget.donation.mobileNumber != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '📞 ${widget.donation.mobileNumber}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final userId = _supabase.auth.currentUser?.id;
                    if (userId == null) return;

                    final position = await LocationService.getCurrentLocation();
                    if (position == null) return;

                    final address =
                        await LocationService.getAddressFromLatLng(position);
                    if (address == null) return;

                    await donationProvider.requestDonation(
                      isFood: true,
                      donationId: widget.donation.id,
                      requesterId: userId,
                      city: address['city'] ?? 'Unknown',
                      area: address['area'] ?? 'Unknown',
                      province: address['province'] ?? 'Unknown',
                      country: address['country'] ?? 'Unknown',
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('✅ Request sent successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('❌ Error: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5DCE35),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                icon: const Icon(Icons.request_page_rounded),
                label: const Text(
                  'Request',
                  style: TextStyle(fontSize: 18, fontFamily: 'semi-bold'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
