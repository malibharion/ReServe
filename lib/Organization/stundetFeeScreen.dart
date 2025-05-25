// screens/student_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/Model/feeModels.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Help Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestList('Pending'),
          _buildRequestList('Completed'),
        ],
      ),
    );
  }

  Widget _buildRequestList(String status) {
    return Consumer<StudentHelpProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.requests.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredRequests = provider.requests
            .where((request) => request.status == status)
            .toList();

        if (filteredRequests.isEmpty) {
          return const Center(child: Text('No requests found'));
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
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${request.name}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Father Name: ${request.fatherName}'),
            const SizedBox(height: 10),
            const Text('Fee Slip:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Image.network(request.feeSlipUrl,
                height: 150, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 10),
            const Text('CNIC:', style: TextStyle(fontWeight: FontWeight.bold)),
            Image.network(request.cnicUrl,
                height: 150, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text('Status: ${request.status}',
                style: TextStyle(
                  color: request.status == 'Pending'
                      ? Colors.orange
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                )),
            if (request.status == 'Pending')
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _updateStatus(request.id, 'Completed'),
                  child: const Text('Mark as Completed'),
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
