import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  Anggota? anggota;
  int id = 0;
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.settings.arguments != null) {
      id = ModalRoute.of(context)?.settings.arguments as int;
      getDetail();
    }
  }

  Future<void> getDetail() async {
    try {
      final _response = await _dio.get(
        '${_apiUrl}/anggota/${id}',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      print(responseData);
      print(id);
      setState(() {
        anggota = Anggota.fromJson(responseData);
      });
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text('Detail Anggota',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Color(0xFF5E5695),
                )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: anggota == null
              ? Text("Belum ada anggota")
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text("ID"),
                      subtitle: Text("${anggota?.id}"),
                    ),
                    ListTile(
                      title: Text("Nomor Induk"),
                      subtitle: Text("${anggota?.nomor_induk}"),
                    ),
                    ListTile(
                      title: Text("Nama"),
                      subtitle: Text("${anggota?.nama}"),
                    ),
                    ListTile(
                      title: Text("Alamat"),
                      subtitle: Text("${anggota?.alamat}"),
                    ),
                    ListTile(
                      title: Text("Tanggal Lahir"),
                      subtitle: Text("${anggota?.tgl_lahir}"),
                    ),
                    ListTile(
                      title: Text("Telepon"),
                      subtitle: Text("${anggota?.telepon}"),
                    ),
                    ListTile(
                      title: Text("Image URL"),
                      subtitle: Text("${anggota?.image_url}"),
                    ),
                    ListTile(
                      title: Text("Status Aktif"),
                      subtitle: Text("${anggota?.status_aktif}"),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFF857BC9),
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 10)),
                                  child: Text('Edit Anggota',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          color: Colors.white))),
                            ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
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
    final data = json['data'] as Map<String, dynamic>?;

    if (data != null) {
      final anggotaData = data['anggota'] as Map<String, dynamic>?;

      if (anggotaData != null) {
        return Anggota(
          id: anggotaData['id'],
          nomor_induk: anggotaData['nomor_induk'],
          nama: anggotaData['nama'],
          alamat: anggotaData['alamat'],
          tgl_lahir: anggotaData['tgl_lahir'],
          telepon: anggotaData['telepon'],
          image_url: anggotaData['image_url'],
          status_aktif: anggotaData['status_aktif'],
        );
      }
    }

    // If data or anggotaData is null, throw an exception or return a default instance
    throw Exception('Failed to parse Anggota from JSON');
  }
}
