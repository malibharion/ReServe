import 'package:flutter/material.dart';
import 'package:reserve/Functions/statusFunction.dart';
import 'package:reserve/Model/donationStatus.dart';

class DonationStatusScreen extends StatefulWidget {
  final String userId; // Pass current user id

  DonationStatusScreen({required this.userId});

  @override
  _DonationStatusScreenState createState() => _DonationStatusScreenState();
}

class _DonationStatusScreenState extends State<DonationStatusScreen> {
  late Future<List<DonationStatus>> _statusesFuture;

  @override
  void initState() {
    super.initState();
    print(
        "[initState] Starting to fetch statuses for userId: ${widget.userId}");
    _statusesFuture = fetchUserStatuses(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    print("[build] Building DonationStatusScreen");
    return Scaffold(
      appBar: AppBar(title: Text('My Donation & Requests Status')),
      body: FutureBuilder<List<DonationStatus>>(
        future: _statusesFuture,
        builder: (context, snapshot) {
          print(
              "[FutureBuilder] Connection state: ${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("[FutureBuilder] Waiting for data...");
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("[FutureBuilder] Error occurred: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final statuses = snapshot.data ?? [];
          print("[FutureBuilder] Data received: ${statuses.length} items");

          if (statuses.isEmpty) {
            print("[FutureBuilder] No donation or request data found.");
            return Center(child: Text('No donation or request data found.'));
          }

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: statuses.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = statuses[index];
              print("[ListView] Rendering item #$index: ${item.name}");
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.type,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueAccent)),
                    SizedBox(height: 6),
                    Text(item.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 6),
                    Text(item.description),
                    SizedBox(height: 6),
                    Text('Status: ${item.status}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.green)),
                    if (item.imageUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(item.imageUrl!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover),
                        ),
                      )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
