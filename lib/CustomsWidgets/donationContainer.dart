import 'package:flutter/material.dart';

class DonationContainer extends StatelessWidget {
  final ImageProvider? image;
  final VoidCallback? onTap;
  final String? title;
  final String? city;
  final String? province;
  final String? country;

  const DonationContainer({
    this.city,
    this.province,
    this.country,
    this.title,
    this.onTap,
    this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEAFFE2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                    image: image!,
                    fit: BoxFit.cover,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      print('❌ Error loading image: $error');
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  )),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: const TextStyle(
                      fontFamily: 'semi-bold',
                    ),
                  ),
                  Text(
                    '$city, $province',
                    style: const TextStyle(fontFamily: 'light'),
                  ),
                  Text(
                    country!,
                    style: const TextStyle(fontFamily: 'light'),
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
