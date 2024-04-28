import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:tugas_progmob_2/features/users/screens/user_detail.dart';

import 'package:tugas_progmob_2/utils/theme/theme.dart';
import 'package:tugas_progmob_2/features/authentication/screens/splash_screen.dart';
import 'package:tugas_progmob_2/features/authentication/screens/login_page.dart';
import 'package:tugas_progmob_2/features/authentication/screens/register_page.dart';
import 'package:tugas_progmob_2/features/profile/screens/profile_page.dart';
import 'package:tugas_progmob_2/features/users/screens/users_list.dart';

Future<void> main() async{
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    final myStorage = GetStorage();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: TAppTheme.theme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(name: '/anggota', page: () => UsersList()),
        GetPage(name: '/anggota/detail', page: () => UserDetail()),
      ],
    );
  }
}