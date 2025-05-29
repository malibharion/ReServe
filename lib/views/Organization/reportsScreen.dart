import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reserve/Functions/supabaseServices.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? startDate;
  DateTime? endDate;
  final format = DateFormat('yyyy-MM-dd');
  final SupabaseService _service = SupabaseService();
  List<Map<String, dynamic>> combinedData = [];
  bool isLoading = false;

  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade800,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      fetchData();
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final food = await _service.fetchFoodDonations(startDate, endDate);
    final other = await _service.fetchOtherDonations(startDate, endDate);
    final fee = await _service.fetchStudentHelpRequests(startDate, endDate);

    List<Map<String, dynamic>> allData = [];

    for (var item in food) {
      allData.add({
        'type': 'Food',
        'title': item.productName,
        'desc': item.description ?? '',
        'date': item.createdAt,
      });
    }

    for (var item in other) {
      allData.add({
        'type': 'Other',
        'title': item.productName,
        'desc': item.description ?? '',
        'date': item.createdAt,
      });
    }

    for (var item in fee) {
      allData.add({
        'type': 'Fee',
        'title': item.name,
        'desc': 'CNIC: ${item.cnicUrl ?? 'N/A'}',
        'date': item.createdAt,
      });
    }

    allData.sort((a, b) => b['date'].compareTo(a['date']));

    setState(() {
      combinedData = allData;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Food':
        return Colors.green;
      case 'Other':
        return Colors.orange;
      case 'Fee':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Ledger'),
      ),
      body: Column(
        children: [
          // ---------------------- Header with Filter ----------------------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.filter_list, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      startDate != null && endDate != null
                          ? '${format.format(startDate!)} → ${format.format(endDate!)}'
                          : 'Select Date Range',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDateRange,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Pick",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),

          // ---------------------- Data List ----------------------
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : combinedData.isEmpty
                    ? const Center(
                        child: Text(
                            'No data available for the selected date range.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: combinedData.length,
                        itemBuilder: (context, index) {
                          final item = combinedData[index];
                          final color = _getTypeColor(item['type']);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item['type'],
                                        style: TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Description
                                if (item['desc'] != null &&
                                    item['desc'].toString().isNotEmpty)
                                  Text(
                                    item['desc'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),

                                const SizedBox(height: 10),

                                // Date
                                Text(
                                  'Date: ${DateFormat.yMMMd().format(item['date'])}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF6F9FF),
    );
  }
}
