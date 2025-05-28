import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:reserve/views/Organization/organizationMainScreen.dart';
import 'package:reserve/views/Organization/stundetFeeScreen.dart';

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
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizationProvider.locale.languageCode == 'en'
              ? 'All Requests'
              : 'تمام درخواستیں',
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.card_giftcard),
              text: localizationProvider.locale.languageCode == 'en'
                  ? 'Donations'
                  : 'عطیات',
            ),
            Tab(
              icon: const Icon(Icons.school),
              text: localizationProvider.locale.languageCode == 'en'
                  ? 'Student Fees'
                  : 'طالب علم کی فیس',
            ),
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
