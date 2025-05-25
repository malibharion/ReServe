// providers/student_help_provider.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:reserve/Model/feeModels.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class StudentHelpProvider with ChangeNotifier {
  final SupabaseClient supabse = Supabase.instance.client;
  List<StudentHelpRequest> _requests = [];
  bool _isLoading = false;

  List<StudentHelpRequest> get requests => _requests;
  bool get isLoading => _isLoading;

  Future<void> fetchStudentHelpRequests() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await supabse
          .from('student_help_requests')
          .select('*')
          .order('created_at', ascending: false);

      _requests = (response as List)
          .map((item) => StudentHelpRequest.fromMap(item))
          .toList();
    } catch (e) {
      debugPrint('Error fetching student help requests: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> uploadImage(String path, Uint8List fileBytes) async {
    try {
      final fileExt = path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'student_documents/$fileName';

      await supabse.storage.from('reserve').uploadBinary(filePath, fileBytes);

      return supabse.storage.from('reserve').getPublicUrl(filePath);
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> submitHelpRequest({
    required String name,
    required String fatherName,
    required Uint8List? feeSlipImage,
    required Uint8List? cnicImage,
  }) async {
    if (feeSlipImage == null || cnicImage == null) {
      throw Exception('Both fee slip and CNIC images are required');
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Upload images
      final feeSlipUrl = await uploadImage('fee_slip.jpg', feeSlipImage);
      final cnicUrl = await uploadImage('cnic.jpg', cnicImage);

      if (feeSlipUrl == null || cnicUrl == null) {
        throw Exception('Failed to upload images');
      }

      // Insert request
      await supabse.from('student_help_requests').insert({
        'name': name,
        'father_name': fatherName,
        'fee_slip_url': feeSlipUrl,
        'cnic_url': cnicUrl,
        'status': 'Pending',
      });

      // Refresh data
      await fetchStudentHelpRequests();
    } catch (e) {
      debugPrint('Error submitting help request: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
