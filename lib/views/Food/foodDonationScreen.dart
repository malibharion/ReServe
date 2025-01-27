import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reserve/CustomsWidgets/studentFeeContainer.dart';
import 'package:reserve/CustomsWidgets/textfeild.dart';

class FoodDonationScreen extends StatefulWidget {
  const FoodDonationScreen({super.key});

  @override
  State<FoodDonationScreen> createState() => _FoodDonationScreenState();
}

class _FoodDonationScreenState extends State<FoodDonationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Donate Food Item', style: TextStyle(fontFamily: 'semi-bold')),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            MyTextFeild(
              prefixIcon: Icons.shopping_bag,
              hintText: 'Product Name',
              obscureText: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            MyTextFeild(
              prefixIcon: Icons.description,
              hintText: 'Product Description',
              obscureText: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5DCE35),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size(double.infinity, 50)),
            ),
            Text('Add Product Image',
                style: TextStyle(fontSize: 16.sp, fontFamily: 'light')),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5DCE35),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size(double.infinity, 50)),
            ),
            Text('Add Your Location',
                style: TextStyle(fontSize: 16.sp, fontFamily: 'light')),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Donate',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'semi-bold',
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5DCE35),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size(double.infinity, 50)),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
