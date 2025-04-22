import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/donationContainer.dart';
import 'package:reserve/StateManagment/Donations.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Donations'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: donationProvider.isLoading &&
                  donationProvider.otherDonationsItems.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final donation =
                              donationProvider.otherDonationsItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: DonationContainer(
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
                            ),
                          );
                        },
                        itemCount: donationProvider.otherDonationsItems.length,
                      )
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const OtherItmeDonation();
          }));
        },
        label: const Text(
          'Donate',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.volunteer_activism,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightGreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
