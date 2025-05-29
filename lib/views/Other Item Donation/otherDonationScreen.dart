import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/studentFeeContainer.dart';
import 'package:reserve/Functions/locationEnabler.dart';
import 'package:reserve/Model/donation.dart';
import 'package:reserve/Model/otherDonationModel.dart';
import 'package:reserve/StateManagment/Donations.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtherItmeDonationDetailScreen extends StatefulWidget {
  final OtherDonation donation;
  const OtherItmeDonationDetailScreen({super.key, required this.donation});

  @override
  State<OtherItmeDonationDetailScreen> createState() =>
      _OtherItmeDonationDetailScreenState();
}

class _OtherItmeDonationDetailScreenState
    extends State<OtherItmeDonationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    final donationProvider = Provider.of<DonationProvider>(context);
    final SupabaseClient _supabase = Supabase.instance.client;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenTopContainer(
                onTap: () => Navigator.pop(context),
                image: NetworkImage(widget.donation.imagePath),
              ),
              const SizedBox(height: 20),
              Text(
                widget.donation.productName,
                style: const TextStyle(fontFamily: 'semi-bold', fontSize: 20),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Text(
                localizationProvider.locale.languageCode == 'en'
                    ? 'Description'
                    : 'تفصیل',
                style: TextStyle(fontFamily: 'semi-bold', fontSize: 20),
              ),
              Text(
                widget.donation.productDescription.length > 100
                    ? widget.donation.productDescription.substring(0, 100)
                    : widget.donation.productDescription,
                style: const TextStyle(fontFamily: 'light'),
              ),
              if (widget.donation.username != null) ...[
                const SizedBox(height: 20),
                Text(
                  localizationProvider.locale.languageCode == 'en'
                      ? 'Donated by'
                      : 'عطا کردہ',
                  style: TextStyle(fontFamily: 'semi-bold', fontSize: 20),
                ),
                Text(
                  widget.donation.username!,
                  style: const TextStyle(fontFamily: 'light'),
                ),
              ],
              if (widget.donation.mobileNumber != null) ...[
                const SizedBox(height: 10),
                Text(
                  widget.donation.mobileNumber!,
                  style: const TextStyle(fontFamily: 'light'),
                ),
              ],
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final userId = _supabase.auth.currentUser?.id;
                      if (userId == null) {
                        return;
                      }

                      final position =
                          await LocationService.getCurrentLocation();
                      if (position == null) return;

                      final address =
                          await LocationService.getAddressFromLatLng(position);
                      if (address == null) return;

                      await donationProvider.otherDonations(
                        isFood: false,
                        donationId: widget.donation.id,
                        requesterId: userId,
                        latitude: position.latitude.toString(),
                        longitude: position.longitude.toString(),
                        status: 'Pending',
                        city: address['city'] ?? 'Unknown',
                        area: address['area'] ?? 'Unknown',
                        province: address['province'] ?? 'Unknown',
                        country: address['country'] ?? 'Unknown',
                      );

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Request sent successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  child: Text(
                    localizationProvider.locale.languageCode == 'en'
                        ? 'Request'
                        : 'درخواست',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'semi-bold',
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5DCE35),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(double.infinity, 50)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
