import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import 'package:tugas_progmob_2/utils/theme/theme.dart';
import 'package:tugas_progmob_2/features/authentication/screens/splash_screen.dart';
import 'package:tugas_progmob_2/features/authentication/screens/login_page.dart';
import 'package:tugas_progmob_2/features/authentication/screens/register_page.dart';

import 'package:tugas_progmob_2/features/profile/screens/profile_page.dart';

import 'package:tugas_progmob_2/features/users/screens/users_list.dart';
import 'package:tugas_progmob_2/features/users/screens/add_user.dart';
import 'package:tugas_progmob_2/features/users/screens/user_detail.dart';
import 'package:tugas_progmob_2/features/users/screens/edit_user.dart';

import 'package:tugas_progmob_2/features/transaction/screens/transaction.dart';
import 'package:tugas_progmob_2/features/transaction/screens/transaction_type.dart';
import 'package:tugas_progmob_2/features/transaction/screens/bunga_list.dart';
import 'package:tugas_progmob_2/features/transaction/screens/add_bunga.dart';

import 'package:tugas_progmob_2/features/savings/screens/savings_list.dart';
import 'package:tugas_progmob_2/features/savings/screens/savings_detail.dart';
import 'package:tugas_progmob_2/features/savings/screens/add_saving.dart';

Future<void> main() async{
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
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
        GetPage(name: '/anggota/tambah', page: () => AddUser()),
        GetPage(name: '/anggota/edit', page: () => EditUser()),
        GetPage(name: '/transaction', page: () => Transaction()),
        GetPage(name: '/transactionType', page: () => TransactionType()),
        GetPage(name: '/bungaList', page: () => BungaList()),
        GetPage(name: '/bunga/tambah', page: () => AddBunga()),
        GetPage(name: '/savings', page: () => SavingList()),
        GetPage(name: '/savings/detail', page: () => SavingDetail()),
        GetPage(name: '/savings/tambah', page: () => AddSaving()),
      ],
    );
  }
}