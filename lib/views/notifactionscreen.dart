import 'package:flutter/material.dart';
import 'package:reserve/Functions/notification.dart';

class DonationNotificationScreen extends StatefulWidget {
  @override
  _DonationNotificationScreenState createState() =>
      _DonationNotificationScreenState();
}

class _DonationNotificationScreenState
    extends State<DonationNotificationScreen> {
  List<Map<String, dynamic>> _donations = [];

  @override
  void initState() {
    super.initState();
    setupDonationListener((newDonation) {
      setState(() {
        _donations.insert(0, newDonation);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f4f8),
      appBar: AppBar(
        title: Text("📢 New Donations",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: _donations.isEmpty
          ? Center(
              child: Text(
                "No new donations yet!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: _donations.length,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final donation = _donations[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donation['product_name'] ?? 'No Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(donation['product_description'] ?? 'No Description'),
                      SizedBox(height: 8),
                      Text(
                        'City: ${donation['city'] ?? '-'} | Province: ${donation['province'] ?? '-'}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      donation['image_path'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                donation['image_path'],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
