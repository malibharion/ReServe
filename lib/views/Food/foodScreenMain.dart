import 'package:flutter/material.dart';
import 'package:reserve/CustomsWidgets/donationContainer.dart';
import 'package:reserve/views/Food/foodDetailScreen.dart';
import 'package:reserve/views/Food/foodDonationScreen.dart';

class FoodScreenMain extends StatefulWidget {
  const FoodScreenMain({super.key});

  @override
  State<FoodScreenMain> createState() => _FoodScreenMainState();
}

class _FoodScreenMainState extends State<FoodScreenMain> {
  final List<String> Images = [
    'assets/images/food container.png',
    'assets/images/food container.png',
    'assets/images/food container.png',
    'assets/images/food container.png',
    'assets/images/food container.png',
    'assets/images/food container.png',
    'assets/images/food container.png',
    'assets/images/food container.png',
    'assets/images/food container.png',
    'assets/images/food container.png'
  ];
  final List<String> title = [
    'Flour bags 1',
    'Flour bags 2',
    'Flour bags 3',
    'Flour bags 4',
    'Flour bags 5',
    'Flour bags 6',
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
                          builder: (context) => FoodDetailScreen(
                            image: AssetImage(Images[index]),
                            name: title[index],
                            location: location[index],
                            description:
                                'This is a good quality flour available if anybody can contact us.',
                          ),
                        ),
                      );
                    },
                    image: AssetImage(Images[index]),
                    title: title[index],
                    location: location[index],
                  ),
                ),
                itemCount: 10,
              )
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FoodDonationScreen();
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
