import 'package:flutter/material.dart';

class DonationContainer extends StatefulWidget {
  final ImageProvider? image;
  final VoidCallback? onTap;
  final String? title;
  final String? location;
  const DonationContainer({
    this.location,
    this.title,
    this.onTap,
    this.image,
    super.key,
  });

  @override
  State<DonationContainer> createState() => _DonationContainerState();
}

class _DonationContainerState extends State<DonationContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFEAFFE2), borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(
                      image: widget.image!,
                    ))),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    widget.title!,
                    style: TextStyle(
                      fontFamily: 'semi-bold',
                    ),
                  ),
                  Text(
                    widget.location!,
                    style: TextStyle(fontFamily: 'light'),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
