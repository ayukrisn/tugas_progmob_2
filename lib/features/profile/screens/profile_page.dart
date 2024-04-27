import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class UserData {
  final int id;
  final String name;
  final String email;

  UserData({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? userData;
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  Future<void> getUser() async {
    try {
      final _response = await _dio.get(
        '${_apiUrl}/user',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      setState(() {
        userData = UserData.fromJson(responseData['data']['user']);
      });
      print('User data: ${userData?.id}');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: userData == null
              ? CircularProgressIndicator()
              : ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hello, ${userData?.name}!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Color(0xFF5E5695),
                                      )),
                              const SizedBox(height: 4),
                              Text('Email: ${userData?.email}',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(26, 94, 86, 149)),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.notifications_none,
                                  size: 32,
                                  color: Colors.black,
                                ),
                              ),
                            )
                            // const CircleAvatar(
                            //   radius: 28,
                            //   backgroundImage:
                            //       AssetImage('assets/avatar5.jpeg'),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ],
                )

          // : Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Text('User ID: ${userData?.id}'),
          //       Text('Name: ${userData?.name}'),
          //       Text('Email: ${userData?.email}'),
          //     ],
          //   ),
          ),
    );
  }
}
