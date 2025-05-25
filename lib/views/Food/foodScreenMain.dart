import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/donationContainer.dart';
import 'package:reserve/StateManagment/Donations.dart';

import 'package:reserve/views/Food/foodDetailScreen.dart';
import 'package:reserve/views/Food/foodDonationScreen.dart';

class FoodScreenMain extends StatefulWidget {
  const FoodScreenMain({super.key});

  @override
  State<FoodScreenMain> createState() => _FoodScreenMainState();
}

class _FoodScreenMainState extends State<FoodScreenMain> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DonationProvider>(context, listen: false).fetchDonations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF2),
      appBar: AppBar(
        title: const Text('Food'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: donationProvider.isLoading &&
                  donationProvider.donations.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final donation = donationProvider.donations[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: DonationContainer(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FoodDetailScreen(
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
                        itemCount: donationProvider.donations.length,
                      )
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const FoodDonationScreen();
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
