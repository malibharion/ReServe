// screens/student_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/Model/feeModels.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:reserve/StateManagment/studentHelpProvider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentRequestsScreen extends StatefulWidget {
  const StudentRequestsScreen({super.key});

  @override
  State<StudentRequestsScreen> createState() => _StudentRequestsScreenState();
}

class _StudentRequestsScreenState extends State<StudentRequestsScreen>
    with SingleTickerProviderStateMixin {
  final SupabaseClient supabase = Supabase.instance.client;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentHelpProvider>(context, listen: false)
          .fetchStudentHelpRequests();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizationProvider.locale.languageCode == 'en'
              ? 'Student Help Requests'
              : 'طلباء کی مدد کی درخواستیں',
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
                text: localizationProvider.locale.languageCode == 'en'
                    ? 'Pending'
                    : 'زیر التواء'),
            Tab(
                text: localizationProvider.locale.languageCode == 'en'
                    ? 'Completed'
                    : 'مکمل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestList(localizationProvider.locale.languageCode == 'en'
              ? 'Pending'
              : 'زیر التواء'),
          _buildRequestList(localizationProvider.locale.languageCode == 'en'
              ? 'Completed'
              : 'مکمل'),
        ],
      ),
    );
  }

  Widget _buildRequestList(String status) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Consumer<StudentHelpProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.requests.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredRequests = provider.requests
            .where((request) => request.status == status)
            .toList();

        if (filteredRequests.isEmpty) {
          return Center(
            child: Text(
              localizationProvider.locale.languageCode == 'en'
                  ? 'No requests found'
                  : 'کوئی درخواستیں نہیں ملیں',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchStudentHelpRequests(),
          child: ListView.builder(
            itemCount: filteredRequests.length,
            itemBuilder: (context, index) {
              return _buildRequestCard(filteredRequests[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildRequestCard(StudentHelpRequest request) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${localizationProvider.locale.languageCode == 'en' ? 'Name' : 'نام'}: ${request.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${localizationProvider.locale.languageCode == 'en' ? 'Father Name' : 'ولدیت کا نام'}: ${request.fatherName}',
            ),
            const SizedBox(height: 10),
            Text(
              localizationProvider.locale.languageCode == 'en'
                  ? 'Fee Slip:'
                  : 'فیس سلپ:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Image.network(request.feeSlipUrl,
                height: 150, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(
              localizationProvider.locale.languageCode == 'en'
                  ? 'CNIC:'
                  : 'شناختی کارڈ:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Image.network(request.cnicUrl,
                height: 150, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(
              '${localizationProvider.locale.languageCode == 'en' ? 'Status' : 'حیثیت'}: ${request.status}',
              style: TextStyle(
                color:
                    request.status == 'Pending' ? Colors.orange : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (request.status == 'Pending')
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _updateStatus(request.id, 'Completed'),
                  child: Text(
                    localizationProvider.locale.languageCode == 'en'
                        ? 'Mark as Completed'
                        : 'مکمل نشان زد کریں',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(String id, String newStatus) async {
    try {
      final provider = Provider.of<StudentHelpProvider>(context, listen: false);

      await provider.supabse
          .from('student_help_requests')
          .update({'status': newStatus}).eq('id', id);

      await provider.fetchStudentHelpRequests();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }
}
