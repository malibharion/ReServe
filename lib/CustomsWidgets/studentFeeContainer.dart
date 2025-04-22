import 'package:flutter/material.dart';

class ScreenTopContainer extends StatefulWidget {
  final ImageProvider image;
  final VoidCallback? onTap;
  const ScreenTopContainer({
    required this.image,
    this.onTap,
    super.key,
  });

  @override
  State<ScreenTopContainer> createState() => _ScreenTopContainerState();
}

class _ScreenTopContainerState extends State<ScreenTopContainer> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
            child: SizedBox(
              height: 250, // control the image height here
              width: double.infinity,
              child: Image(
                image: widget.image,
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.03,
            left: MediaQuery.of(context).size.width * 0.02,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
