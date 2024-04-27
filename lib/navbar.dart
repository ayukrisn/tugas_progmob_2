import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          onDestinationSelected: (index) {
            controller.selectedIndex.value = index;
            switch (index) {
              case 0:
                Get.offNamed('/profile');
                break;
              case 1:
                Get.offNamed('/anggota');
                break;
            }
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Profile'),
            NavigationDestination(
                icon: Icon(Icons.calendar_month), label: 'Anggota'),
          ],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
}
