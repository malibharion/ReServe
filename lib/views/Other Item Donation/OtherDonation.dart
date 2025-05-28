import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/studentFeeContainer.dart';
import 'package:reserve/CustomsWidgets/textfeild.dart';
import 'package:reserve/Functions/donationServices.dart';
import 'package:reserve/StateManagment/Donations.dart';
import 'package:reserve/StateManagment/authProvider.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtherItmeDonation extends StatefulWidget {
  const OtherItmeDonation({super.key});

  @override
  State<OtherItmeDonation> createState() => _OtherItmeDonationState();
}

class _OtherItmeDonationState extends State<OtherItmeDonation> {
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final donationProvider = Provider.of<DonationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizationProvider.locale.languageCode == 'en'
              ? 'Donate Items'
              : 'اشیاء عطیہ کریں',
          style: const TextStyle(fontFamily: 'semi-bold'),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            MyTextFeild(
              controller: _productNameController,
              prefixIcon: Icons.shopping_bag,
              hintText: localizationProvider.locale.languageCode == 'en'
                  ? 'Product Name'
                  : 'مصنوعات کا نام',
              obscureText: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            MyTextFeild(
              controller: _productDescriptionController,
              prefixIcon: Icons.description,
              hintText: localizationProvider.locale.languageCode == 'en'
                  ? 'Product Description'
                  : 'مصنوعات کی وضاحت',
              obscureText: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            ElevatedButton(
              onPressed: () {
                print("🔸 Button pressed - calling pickImage()");
                donationProvider.pickImage();
              },
              child: Icon(Icons.add_a_photo, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5DCE35),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: Size(double.infinity, 50),
              ),
            ),

            SizedBox(height: 8),
            Text(
              donationProvider.selectedImage != null
                  ? (localizationProvider.locale.languageCode == 'en'
                      ? 'Image selected'
                      : 'تصویر منتخب کی گئی ہے')
                  : (localizationProvider.locale.languageCode == 'en'
                      ? 'Add Product Image'
                      : 'مصنوعات کی تصویر شامل کریں'),
              style: TextStyle(fontSize: 16.sp, fontFamily: 'light'),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // Location Capture Button
            ElevatedButton(
              onPressed: () {
                print("🔸 Button pressed - calling location function()");
                donationProvider.captureLocation();
              },
              child: Icon(Icons.location_on, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5DCE35),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 8),
            Text(
              donationProvider.currentPosition != null
                  ? (localizationProvider.locale.languageCode == 'en'
                      ? 'Location captured: ${donationProvider.currentPosition!.latitude}, ${donationProvider.currentPosition!.longitude}'
                      : 'مقام حاصل کیا گیا: ${donationProvider.currentPosition!.latitude}, ${donationProvider.currentPosition!.longitude}')
                  : (localizationProvider.locale.languageCode == 'en'
                      ? 'No location captured'
                      : 'کوئی مقام حاصل نہیں کیا گیا'),
              style: TextStyle(fontSize: 16.sp, fontFamily: 'light'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_productNameController.text.isEmpty ||
                    _productDescriptionController.text.isEmpty ||
                    donationProvider.selectedImage == null ||
                    donationProvider.currentPosition == null ||
                    donationProvider.currentAddress == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please fill all fields, pick image, and capture location.',
                      ),
                    ),
                  );
                  return;
                }

                donationProvider.setLoading(true);

                try {
                  final imageUrl = await DonationService()
                      .uploadImage(donationProvider.selectedImage!);

                  // Use captured position and address from provider
                  final position = donationProvider.currentPosition!;
                  final address = donationProvider.currentAddress!;

                  await DonationService().otherItems(
                    productName: _productNameController.text,
                    productDescription: _productDescriptionController.text,
                    imageUrl: imageUrl,
                    latitude: position.latitude,
                    longitude: position.longitude,
                    city: address['city'] ?? '',
                    area: address['area'] ?? '',
                    province: address['province'] ?? '',
                    country: address['country'] ?? '',
                    userId: Supabase.instance.client.auth.currentUser?.id ?? "",
                  );
                  print('Donation added successfully!');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Donation added successfully!')),
                  );

                  donationProvider.clear();
                  Navigator.pop(context);
                } catch (e) {
                  print('Failed: ${e.toString()}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed: ${e.toString()}')),
                  );
                }

                donationProvider.setLoading(false);
              },
              child: donationProvider.isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      localizationProvider.locale.languageCode == 'en'
                          ? 'Donate'
                          : 'عطا کریں',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'semi-bold',
                        color: Colors.white,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5DCE35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
