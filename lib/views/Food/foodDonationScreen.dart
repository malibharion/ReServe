import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/textfeild.dart';
import 'package:reserve/Functions/donationServices.dart';
import 'package:reserve/Functions/locationEnabler.dart';
import 'package:reserve/StateManagment/Donations.dart';
import 'package:reserve/StateManagment/authProvider.dart';
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

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Donate Food Item', style: TextStyle(fontFamily: 'semi-bold')),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                MyTextFeild(
                  controller: _productNameController,
                  prefixIcon: Icons.shopping_bag,
                  hintText: 'Product Name',
                  obscureText: false,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                MyTextFeild(
                  controller: _productDescriptionController,
                  prefixIcon: Icons.description,
                  hintText: 'Product Description',
                  obscureText: false,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                // Image Picker Button
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
                      ? 'Image selected'
                      : 'Add Product Image',
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
                      ? 'Location captured: ${donationProvider.currentPosition!.latitude}, ${donationProvider.currentPosition!.longitude}'
                      : 'No location captured',
                  style: TextStyle(fontSize: 16.sp, fontFamily: 'light'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                // Donate Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
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
                        print('Donation added successfully!');

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Donation added successfully!')),
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
                            'Donate',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
