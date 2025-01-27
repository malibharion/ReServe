import 'package:flutter/material.dart';
import 'package:reserve/CustomsWidgets/donationContainer.dart';

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
  final List<String> Images = [
    'assets/images/jacket 1.jpg',
    'assets/images/jacket 2.jpg',
    'assets/images/jacket 4.jpg',
    'assets/images/jacket3.jpg',
    'assets/images/machine 1.jpg',
    'assets/images/machine 2.jpg',
  ];
  final List<String> title = [
    'Leather Jacket',
    'Normal jacket',
    'Sports Jacket',
    'Jacket',
    'Washing Machine',
    'Washing Machine 2',
    'Flour bags 7',
    'Flour bags 8',
    'Flour bags 9',
    'Flour bags 10',
  ];
  final List<String> location = [
    'Lahore',
    'Karachi',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Peshawar',
    'Quetta',
    'Sukkur',
    'Hyderabad',
    'Multan'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DonationContainer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtherItmeDonationDetailScreen(
                            image: AssetImage(Images[index]),
                            name: title[index],
                            location: location[index],
                            description:
                                'This is is availble for donation if any body need this they can contact us.',
                          ),
                        ),
                      );
                    },
                    image: AssetImage(Images[index]),
                    title: title[index],
                    location: location[index],
                  ),
                ),
                itemCount: 5,
              )
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OtherItmeDonation();
          }));
        },
        label: Text(
          'Donate',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.volunteer_activism,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightGreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
