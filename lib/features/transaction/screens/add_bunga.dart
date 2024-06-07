import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class AddBunga extends StatefulWidget {
  const AddBunga({super.key});

  @override
  State<AddBunga> createState() => _AddBungaState();
}

class _AddBungaState extends State<AddBunga> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController persenController = TextEditingController();

  int? _selectedAktif;

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  Future<void> addBunga() async {
    try {
      final _response = await _dio.post(
        '$_apiUrl/addsettingbunga',
        data: {
          'persen': persenController.text,
          'isaktif': _selectedAktif,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_storage.read('token')}'
          },
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      print(responseData);
      setState(() {
        if (responseData['success']) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Yeay!"),
                  content: Text('Bunga berhasil ditambahkan!'),
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
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Wait...'),
                  content: Text(responseData['message']),
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
    return Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          title: Text('Lakukan Penambahan Bunga',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF5E5695),
                  )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DropdownButtonFormField<int>(
                          value: _selectedAktif,
                          onChanged: (value) {
                            setState(() {
                              _selectedAktif = value;
                            });
                          },
                          items: [
                            DropdownMenuItem<int>(
                              value: 0,
                              child: Text('Tidak Aktif'),
                            ),
                            DropdownMenuItem<int>(
                              value: 1,
                              child: Text('Aktif'),
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Status Bunga',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value == null
                              ? 'Silakan pilih status bunga'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: persenController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Persentase Bunga',
                            prefixIcon:
                                Icon(Icons.percent, color: Color(0xFF5E5695)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Silakan masukkan persentase bunga';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Nominal harus berupa angka';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState?.save();
                                      addBunga();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFF857BC9),
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10)),
                                  child: Text('Tambahkan Bunga',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          color: Colors.white))),
                            ),
                          ],
                        ),
                      ]))
            ],
          ),
        ));
  }
}
