import 'package:flutter/material.dart';

class MyTextFeild extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final IconData? prefixIcon;

  const MyTextFeild({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
  });

  @override
  State<MyTextFeild> createState() => _MyTextFeildState();
}

class _MyTextFeildState extends State<MyTextFeild> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(
          widget.prefixIcon,
          color: Color(0xFF63D13D),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF63D13D),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF5DCE35),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: widget.hintText,
        labelStyle: TextStyle(color: Colors.grey),
      ),
    );
  }
}
