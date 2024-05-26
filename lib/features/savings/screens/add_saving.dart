import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';


class AddSaving extends StatefulWidget {
  const AddSaving({super.key});

  @override
  State<AddSaving> createState() => _AddSavingState();
}

class _AddSavingState extends State<AddSaving> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

    @override
  void initState() {
    super.initState();
    addSaving();
  }

    Future<void> addSaving() async {
    try {
      final _response = await _dio.post(
        '$_apiUrl/tabungan',
        data: {
          'anggota_id': 103,
          'trx_id': 3,
          'trx_nominal': 827462
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      print(responseData);
      setState(() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Tabungan berhasil ditambahkan!"),
              content: Text('Yeay!'),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {},
                ),
              ],
            );
          });
      });
      
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Oops!"),
              content: Text(e.response?.data['message'] ?? 'An error occurred'),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}