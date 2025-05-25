import 'package:flutter/material.dart';
import 'package:reserve/Organization/organizationMainScreen.dart';
import 'package:reserve/Organization/stundetFeeScreen.dart';

class MainRequestsScreen extends StatefulWidget {
  const MainRequestsScreen({super.key});

  @override
  State<MainRequestsScreen> createState() => _MainRequestsScreenState();
}

class _MainRequestsScreenState extends State<MainRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('All Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.card_giftcard), text: 'Donations'),
            Tab(icon: Icon(Icons.school), text: 'Student Fees'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DonationRequestsScreen(),
          StudentRequestsScreen(),
        ],
      ),
    );
  }
}
