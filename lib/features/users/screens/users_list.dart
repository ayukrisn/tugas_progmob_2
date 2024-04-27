import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class AnggotaData {
  final int id; 
  final String nomor_induk;
  final String nama;
  final String alamat;
  final String tgl_lahir;
  final String telepon;

  AnggotaData({
    required this.id,
    required this.nomor_induk,
    required this.nama,
    required this.alamat,
    required this.tgl_lahir,
    required this.telepon,
  });

  factory AnggotaData.fromJson(Map<String, dynamic> json) {
    return AnggotaData(
      id: json['id'],
      nomor_induk: json['nomor_induk'],
      nama: json['nama'],
      alamat: json['alamat'],
      tgl_lahir: json['tgl_lahir'],
      telepon: json['telepon'],
    );
  }
}


class UsersList extends StatefulWidget {
  const UsersList();

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  AnggotaData? anggotaData;
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text('Anggota',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Color(0xFF5E5695),
                )),
        actions: [
          Icon(Icons.more_vert),
          SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Text('Hello, world!'), // Replace with your desired widget
      ),
    );
  }
}
