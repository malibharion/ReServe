import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/donationContainer.dart';
import 'package:reserve/CustomsWidgets/orgaaznizationContainer.dart';
import 'package:reserve/StateManagment/organzationColor.dart';

class MainOrganizationScreen extends StatefulWidget {
  const MainOrganizationScreen({super.key});

  @override
  State<MainOrganizationScreen> createState() => _MainOrganizationScreenState();
}

class _MainOrganizationScreenState extends State<MainOrganizationScreen> {
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
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Consumer<ChnageColor>(
                builder: (context, colorProvider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OrganizationTopScreenWidget(
                      onTap: () {
                        colorProvider.changeColor(0);
                      },
                      color: colorProvider.selectedIndex == 0
                          ? Colors.green
                          : Colors.white,
                      text: 'Food',
                      textColor: colorProvider.selectedIndex == 0
                          ? Colors.white
                          : Colors.black,
                      topLeftRadius: 10,
                      bottonLeftRadius: 10,
                    ),
                    OrganizationTopScreenWidget(
                      onTap: () {
                        colorProvider.changeColor(1);
                      },
                      color: colorProvider.selectedIndex == 1
                          ? Colors.green
                          : Colors.white,
                      text: 'Non Food',
                      textColor: colorProvider.selectedIndex == 1
                          ? Colors.white
                          : Colors.black,
                    ),
                    OrganizationTopScreenWidget(
                      onTap: () {
                        colorProvider.changeColor(2);
                      },
                      color: colorProvider.selectedIndex == 2
                          ? Colors.green
                          : Colors.white,
                      text: 'Student fee',
                      textColor: colorProvider.selectedIndex == 2
                          ? Colors.white
                          : Colors.black,
                      topRightRadius: 10,
                      bottonRightRadius: 10,
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DonationContainer(
                    onTap: () {},
                    image: AssetImage(Images[index]),
                    title: title[index],
                  ),
                ),
                itemCount: 10,
              )
            ],
          ),
        ),
      )),
    );
  }
}
