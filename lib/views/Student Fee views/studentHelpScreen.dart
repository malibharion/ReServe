import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/textfeild.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:reserve/StateManagment/studentHelpProvider.dart';

class StudentHelpScreen extends StatefulWidget {
  const StudentHelpScreen({super.key});

  @override
  State<StudentHelpScreen> createState() => _StudentHelpScreenState();
}

class _StudentHelpScreenState extends State<StudentHelpScreen> {
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  File? _feeSlipImage;
  File? _cnicImage;
  final _picker = ImagePicker();

  Future<void> _pickImage(bool isFeeSlip) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          if (isFeeSlip) {
            _feeSlipImage = File(pickedFile.path);
          } else {
            _cnicImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _submitRequest() async {
    if (_nameController.text.isEmpty || _fatherNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (_feeSlipImage == null || _cnicImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload both images')),
      );
      return;
    }

    try {
      final provider = Provider.of<StudentHelpProvider>(context, listen: false);
      await provider.submitHelpRequest(
        name: _nameController.text,
        status: 'Pending',
        fatherName: _fatherNameController.text,
        feeSlipImage: await _feeSlipImage!.readAsBytes(),
        cnicImage: await _cnicImage!.readAsBytes(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted successfully!')),
      );

      _nameController.clear();
      _fatherNameController.clear();
      setState(() {
        _feeSlipImage = null;
        _cnicImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting request: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    final themeGreen = const Color(0xFF5DCE35);
    final gradientColors = [Color(0xFF5DCE35), Color(0xFF0ABF53)];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          localizationProvider.locale.languageCode == 'en'
              ? 'Student Help Request'
              : 'طالب علم کی مدد کی درخواست',
          style: TextStyle(
            fontFamily: 'semi-bold',
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCardForm(themeGreen),
              const SizedBox(height: 20),
              _buildImageUploadButton(
                title: localizationProvider.locale.languageCode == 'en'
                    ? 'Upload Fee Slip'
                    : 'فیس سلپ اپ لوڈ کریں',
                imageFile: _feeSlipImage,
                onTap: () => _pickImage(true),
                themeColor: themeGreen,
              ),
              const SizedBox(height: 16),
              _buildImageUploadButton(
                title: localizationProvider.locale.languageCode == 'en'
                    ? 'Upload CNIC'
                    : 'شناختی کارڈ اپ لوڈ کریں',
                imageFile: _cnicImage,
                onTap: () => _pickImage(false),
                themeColor: themeGreen,
              ),
              const SizedBox(height: 30),
              _buildSubmitButton(gradientColors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardForm(Color themeGreen) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Card(
      elevation: 8,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            MyTextFeild(
              controller: _nameController,
              prefixIcon: Icons.person,
              hintText: localizationProvider.locale.languageCode == 'en'
                  ? 'Student Name'
                  : 'طالب علم کا نام',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            MyTextFeild(
              controller: _fatherNameController,
              prefixIcon: Icons.badge_outlined,
              hintText: localizationProvider.locale.languageCode == 'en'
                  ? 'Father\'s Name'
                  : 'والد کا نام',
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(List<Color> gradientColors) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton.icon(
        onPressed: _submitRequest,
        icon: const Icon(Icons.send, color: Colors.white),
        label: Text(
          localizationProvider.locale.languageCode == 'en'
              ? 'Submit Request'
              : 'درخواست جمع کروائیں',
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'semi-bold',
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadButton({
    required String title,
    required File? imageFile,
    required VoidCallback onTap,
    required Color themeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: themeColor, width: 1.5),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(2, 4),
            )
          ],
        ),
        child: imageFile != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      imageFile,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_upload_rounded,
                        size: 40, color: themeColor),
                    const SizedBox(height: 8),
                    Text(title,
                        style: TextStyle(
                            color: themeColor,
                            fontSize: 16,
                            fontFamily: 'medium')),
                  ],
                ),
              ),
      ),
    );
  }
}
