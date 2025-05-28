import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/donationContainer.dart';
import 'package:reserve/StateManagment/Donations.dart';
import 'package:reserve/StateManagment/localization.dart';

import 'package:reserve/views/Other%20Item%20Donation/OtherDonation.dart';
import 'package:reserve/views/Other%20Item%20Donation/otherDonationScreen.dart';

class OtherItmeDonationScreenMain extends StatefulWidget {
  const OtherItmeDonationScreenMain({super.key});

  @override
  State<OtherItmeDonationScreenMain> createState() =>
      _OtherItmeDonationScreenMainState();
}

class _OtherItmeDonationScreenMainState
    extends State<OtherItmeDonationScreenMain> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DonationProvider>(context, listen: false)
          .fetchOtherDonation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);
    final localizationProvider = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizationProvider.locale.languageCode == 'en'
              ? 'Other Donations'
              : 'دیگر عطیات',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: donationProvider.isLoading &&
                  donationProvider.otherDonationsItems.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<DonationProvider>(context, listen: false)
                        .fetchOtherDonation();
                  },
                  child: ListView.separated(
                    itemCount: donationProvider.otherDonationsItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final donation =
                          donationProvider.otherDonationsItems[index];
                      return DonationContainer(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OtherItmeDonationDetailScreen(
                                donation: donation,
                              ),
                            ),
                          );
                        },
                        image: NetworkImage(donation.imagePath),
                        title: donation.productName,
                        city: donation.city,
                        province: donation.province,
                        country: donation.country,
                      );
                    },
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const OtherItmeDonation()));
        },
        label: Text(
          localizationProvider.locale.languageCode == 'en'
              ? 'Donate'
              : 'عطا کریں',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        icon: const Icon(Icons.volunteer_activism, color: Colors.white),
        backgroundColor: Colors.lightGreen,
        elevation: 6,
      ),
    );
  }
}
