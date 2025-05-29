import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/StateManagment/localization.dart';

import 'package:reserve/views/Organization/organizationMainScreen.dart';
import 'package:reserve/views/Organization/otherFoodDonationScreen.dart';
import 'package:reserve/views/Organization/reportsScreen.dart';
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
    _tabController = TabController(length: 4, vsync: this);
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
          isScrollable: true,
          tabs: [
            Tab(
              icon: const Icon(Icons.fastfood),
              text: localizationProvider.locale.languageCode == 'en'
                  ? 'Food Donations'
                  : 'خوراک کے عطیات',
            ),
            Tab(
              icon: const Icon(Icons.card_giftcard),
              text: localizationProvider.locale.languageCode == 'en'
                  ? 'Other Donations'
                  : 'دیگر عطیات',
            ),
            Tab(
              icon: const Icon(Icons.school),
              text: localizationProvider.locale.languageCode == 'en'
                  ? 'Student Fees'
                  : 'طالب علم کی فیس',
            ),
            Tab(
              icon: const Icon(Icons.assessment),
              text: localizationProvider.locale.languageCode == 'en'
                  ? 'Reports'
                  : 'رپورٹس',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DonationRequestsScreen(),
          OtherDonationsScreen(),
          StudentRequestsScreen(),
          ReportsScreen(),
        ],
      ),
    );
  }
}
