import 'package:flutter/material.dart';

class HomeNavigationContainer extends StatefulWidget {
  final String name;
  final ImageProvider? image;
  const HomeNavigationContainer({
    super.key,
    this.image,
    required this.name,
  });

  @override
  State<HomeNavigationContainer> createState() =>
      _HomeNavigationContainerState();
}

class _HomeNavigationContainerState extends State<HomeNavigationContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFEAFFE2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Image(image: widget.image!),
          ),
        ),
        Text(widget.name, style: TextStyle(fontFamily: 'regular')),
      ],
    );
  }
}
