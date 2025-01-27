import 'package:flutter/material.dart';
import 'package:reserve/CustomsWidgets/studentFeeContainer.dart';

class FoodDetailScreen extends StatefulWidget {
  final ImageProvider? image;
  final String? name;
  final String? location;
  final String? description;
  const FoodDetailScreen(
      {super.key, this.image, this.name, this.location, this.description});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenTopContainer(
              onTap: () => Navigator.pop(context),
              image: widget.image!,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              widget.name!,
              style: TextStyle(fontFamily: 'semi-bold', fontSize: 20),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              widget.location!,
              style: TextStyle(fontFamily: 'semi-bold', fontSize: 20),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              'Description',
              style: TextStyle(fontFamily: 'semi-bold', fontSize: 20),
            ),
            Text(
              widget.description!.length > 100
                  ? widget.description!.substring(0, 100)
                  : widget.description!,
              style: TextStyle(fontFamily: 'light'),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Request',
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
