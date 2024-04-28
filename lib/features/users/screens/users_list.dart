import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class AnggotaDatas {
  final List<Anggota> anggotaDatas;

  AnggotaDatas({required this.anggotaDatas});
  factory AnggotaDatas.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final anggota = data?['anggotas'] as List<dynamic>?;

    return AnggotaDatas(
      anggotaDatas: anggota
              ?.map((anggotaData) =>
                  Anggota.fromJson(anggotaData as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Anggota {
  final int id;
  final int nomor_induk;
  final String nama;
  final String alamat;
  final String tgl_lahir;
  final String telepon;
  final String? image_url;
  final int? status_aktif;

  Anggota({
    required this.id,
    required this.nomor_induk,
    required this.nama,
    required this.alamat,
    required this.tgl_lahir,
    required this.telepon,
     required this.image_url,
     required this.status_aktif,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'],
      nomor_induk: json['nomor_induk'],
      nama: json['nama'],
      alamat: json['alamat'],
      tgl_lahir: json['tgl_lahir'],
      telepon: json['telepon'],
      image_url: json['image_url'],
      status_aktif: json['status_aktif'],
    );
  }
}

class UsersList extends StatefulWidget {
  const UsersList();

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  AnggotaDatas? anggotaDatas;
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  Future<void> getAnggota() async {
    try {
      final _response = await _dio.get(
        '${_apiUrl}/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      print(responseData);
      setState(() {
        anggotaDatas = AnggotaDatas.fromJson(responseData);
      });
      if (anggotaDatas != null) {
        print('Data anggota:');
        print(anggotaDatas!.anggotaDatas);
        print(anggotaDatas!.anggotaDatas[0]);
        for (var anggota in anggotaDatas!.anggotaDatas) {
          print('ID: ${anggota.id}');
          print('Nama: ${anggota.nama}');
          print('Nomor Induk: ${anggota.nomor_induk}');
        }
      } else {
        print('anggotaDatas is null');
      }
      print('test');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getAnggota();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text('Anggota',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Color(0xFF5E5695),
                )),
        actions: const [
          Icon(Icons.more_vert),
          SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: anggotaDatas == null || anggotaDatas!.anggotaDatas.isEmpty
              ? Text("Belum ada anggota")
              : ListView.builder(
                  itemCount: anggotaDatas!.anggotaDatas.length,
                  itemBuilder: (context, index) {
                    final anggota = anggotaDatas!.anggotaDatas[index];
                    return ListTile(
                      title: Text(anggota.nama),
                      subtitle: Row(
                        children: [
                          Icon(Icons.phone, size: 14),
                          SizedBox(width: 6),
                          Text(anggota.telepon),
                        ],
                      ),
                      trailing: Icon(Icons.more_vert),
                      leading: const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/anggota.jpeg'),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'You clicked ${anggota.nama} contact!'),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
