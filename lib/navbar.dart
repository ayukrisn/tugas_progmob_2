import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tugas_progmob_2/features/profile/screens/profile_page.dart';
import 'package:tugas_progmob_2/features/users/screens/users_list.dart';
import 'package:tugas_progmob_2/features/transaction/screens/transaction.dart';
import 'package:tugas_progmob_2/features/savings/screens/savings_list.dart';
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
    SavingList(),
    Transaction(),
  ];
}
