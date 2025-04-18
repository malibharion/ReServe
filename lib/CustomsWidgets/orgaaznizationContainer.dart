import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizationTopScreenWidget extends StatefulWidget {
  final double? topRightRadius;
  final double? bottonRightRadius;
  final double? topLeftRadius;
  final double? bottonLeftRadius;
  final VoidCallback? onTap;
  final Color? textColor;
  final String? text;
  final Color? color;
  const OrganizationTopScreenWidget({
    this.topRightRadius = 0,
    this.bottonRightRadius = 0,
    this.topLeftRadius = 0,
    this.bottonLeftRadius = 0,
    this.textColor,
    this.onTap,
    this.color,
    this.text,
    super.key,
  });

  @override
  State<OrganizationTopScreenWidget> createState() =>
      _OrganizationTopScreenWidgetState();
}

class _OrganizationTopScreenWidgetState
    extends State<OrganizationTopScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.topLeftRadius!),
              bottomLeft: Radius.circular(widget.bottonLeftRadius!),
              topRight: Radius.circular(widget.topRightRadius!),
              bottomRight: Radius.circular(widget.bottonRightRadius!),
            ),
            border: Border.all(color: Colors.black)),
        child: Center(
          child: Text(widget.text!,
              style: TextStyle(
                  fontFamily: 'bold',
                  fontSize: 17.sp,
                  color: widget.textColor)),
        ),
      ),
    );
  }
}
