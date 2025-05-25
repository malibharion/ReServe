import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeContainer2 extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final ImageProvider image;

  const HomeContainer2({
    required this.text,
    required this.onTap,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            Image(
              image: image,
              width: double.infinity,
              height: 180.h,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              height: 180.h,
              color: Colors.black.withOpacity(0.4),
            ),
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
