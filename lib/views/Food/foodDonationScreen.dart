import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/textfeild.dart';
import 'package:reserve/Functions/donationServices.dart';
import 'package:reserve/StateManagment/Donations.dart';
import 'package:reserve/StateManagment/authProvider.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodDonationScreen extends StatefulWidget {
  const FoodDonationScreen({super.key});

  @override
  State<FoodDonationScreen> createState() => _FoodDonationScreenState();
}

class _FoodDonationScreenState extends State<FoodDonationScreen> {
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final donationProvider = Provider.of<DonationProvider>(context);
    final localizationProvider = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          localizationProvider.locale.languageCode == 'en'
              ? 'Donate Food Item'
              : 'خوراکی اشیاء عطیہ کریں',
          style: TextStyle(fontFamily: 'semi-bold'),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5DCE35),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Title Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizationProvider.locale.languageCode == 'en'
                                ? 'Let’s Share the Blessings 🍱'
                                : 'آئیں رحمتیں بانٹیں 🍱',
                            style: TextStyle(
                                fontFamily: 'semi-bold', fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          Text(
                            localizationProvider.locale.languageCode == 'en'
                                ? 'Fill in the food details and contribute to your community.'
                                : 'خوراک کی تفصیلات بھریں اور اپنی کمیونٹی میں حصہ ڈالیں۔',
                            style: TextStyle(fontFamily: 'light', fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    /// Product Name
                    MyTextFeild(
                      controller: _productNameController,
                      prefixIcon: Icons.fastfood,
                      hintText: localizationProvider.locale.languageCode == 'en'
                          ? 'Product Name'
                          : 'مصنوعات کا نام',
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),

                    /// Description
                    MyTextFeild(
                      controller: _productDescriptionController,
                      prefixIcon: Icons.description,
                      hintText: localizationProvider.locale.languageCode == 'en'
                          ? 'Product Description'
                          : 'مصنوعات کی تفصیل',
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),

                    /// Image Picker
                    GestureDetector(
                      onTap: donationProvider.pickImage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF5DCE35), width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo,
                                color: Color(0xFF5DCE35)),
                            const SizedBox(width: 10),
                            Text(
                              localizationProvider.locale.languageCode == 'en'
                                  ? (donationProvider.selectedImage != null
                                      ? 'Image Selected'
                                      : 'Add Product Image')
                                  : (donationProvider.selectedImage != null
                                      ? 'تصویر منتخب ہے'
                                      : 'مصنوعات کی تصویر شامل کریں'),
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: 'light'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Location Capture
                    GestureDetector(
                      onTap: donationProvider.captureLocation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF5DCE35), width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on,
                                color: Color(0xFF5DCE35)),
                            const SizedBox(width: 10),
                            Text(
                              localizationProvider.locale.languageCode == 'en'
                                  ? (donationProvider.currentPosition != null
                                      ? 'Location Captured'
                                      : 'Capture Location')
                                  : (donationProvider.currentPosition != null
                                      ? 'مقام حاصل کر لیا گیا ہے'
                                      : 'مقام حاصل کریں'),
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: 'light'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (donationProvider.currentPosition != null)
                      Text(
                        '${donationProvider.currentPosition!.latitude}, ${donationProvider.currentPosition!.longitude}',
                        style: TextStyle(fontSize: 14, fontFamily: 'light'),
                      ),

                    const SizedBox(height: 30),

                    /// Donate Button
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
                                localizationProvider.locale.languageCode == 'en'
                                    ? 'Please fill all fields, pick image, and capture location.'
                                    : 'براہ کرم تمام فیلڈز پُر کریں، تصویر منتخب کریں، اور مقام حاصل کریں۔',
                              ),
                            ),
                          );
                          return;
                        }

                        donationProvider.setLoading(true);

                        try {
                          final imageUrl = await DonationService()
                              .uploadImage(donationProvider.selectedImage!);

                          final position = donationProvider.currentPosition!;
                          final address = donationProvider.currentAddress!;

                          await DonationService().donateFoodItem(
                            productName: _productNameController.text,
                            productDescription:
                                _productDescriptionController.text,
                            imageUrl: imageUrl,
                            latitude: position.latitude,
                            longitude: position.longitude,
                            city: address['city'] ?? '',
                            area: address['area'] ?? '',
                            province: address['province'] ?? '',
                            country: address['country'] ?? '',
                            userId:
                                Supabase.instance.client.auth.currentUser?.id ??
                                    "",
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                localizationProvider.locale.languageCode == 'en'
                                    ? 'Donation added successfully!'
                                    : 'عطیہ کامیابی سے شامل کر دیا گیا ہے!',
                              ),
                            ),
                          );

                          donationProvider.clear();
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }

                        donationProvider.setLoading(false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5DCE35),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(double.infinity, 55),
                      ),
                      child: donationProvider.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              localizationProvider.locale.languageCode == 'en'
                                  ? 'Donate'
                                  : 'عطیہ کریں',
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'semi-bold',
                                color: Colors.white,
                              ),
                            ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          /// Optional Loading Overlay
          if (donationProvider.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
