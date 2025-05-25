import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeNavigationContainer extends StatelessWidget {
  final String name;
  final ImageProvider? image;

  const HomeNavigationContainer({
    super.key,
    this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Image(
            image: image!,
            width: 45.w,
            height: 45.h,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'regular',
          ),
        ),
      ],
    );
  }
}
