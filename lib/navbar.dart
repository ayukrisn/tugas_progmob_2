import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tugas_progmob_2/features/profile/screens/profile_page.dart';
import 'package:tugas_progmob_2/features/users/screens/users_list.dart';
import 'package:tugas_progmob_2/features/transaction/screens/transaction_type.dart';
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.group), label: 'Anggota'),
            NavigationDestination(icon: Icon(Icons.savings), label: 'Tabungan'),
            NavigationDestination(icon: Icon(Icons.payments_rounded), label: 'Transaksi')
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    ProfilePage(),
    UsersList(),
    Center(
      child: Container(
        padding: EdgeInsets.all(16),
        child: const Text(
          "This page has not been built yet! Stay tuned and for the meantime, you can check our Home and Buddies page. Thank you :D",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    ),
    TransactionType(),
  ];
}
