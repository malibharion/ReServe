import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreenContainerName extends StatefulWidget {
  final String name;
  final ImageProvider? image;
  const HomeScreenContainerName({
    required this.name,
    required this.image,
    super.key,
  });

  @override
  State<HomeScreenContainerName> createState() =>
      _HomeScreenContainerNameState();
}

class _HomeScreenContainerNameState extends State<HomeScreenContainerName> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFEAFFE2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Welcome ${widget.name}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontFamily: 'semi-bold'),
            ),
            Image(image: widget.image!)
          ],
        ),
      ),
    );
  }
}
