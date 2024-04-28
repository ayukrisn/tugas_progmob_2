import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomorIndukController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _tglLahirController = TextEditingController();
  TextEditingController _noTeleponController = TextEditingController();

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  DateTime? _tglLahir;

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: _tglLahir ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (_picked != null) {
      setState(() {
        _tglLahir = _picked;
        _tglLahirController.text =
            "${_picked.year}-${_picked.month}-${_picked.day}";
      });
    }
  }

  void goAddUser() async {
    try {
      print('_nomorIndukController.text: ${_nomorIndukController.text}');

      final _response = await _dio.post(
        '${_apiUrl}/anggota',
        data: {
          'nomor_induk': _nomorIndukController.text,
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'tgl_lahir': _tglLahirController.text,
          'telepon': _noTeleponController.text,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_storage.read('token')}',
          },
        ),
      );
      print(_response.data);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Anggota berhasil ditambahkan!"),
              content: Text('Yeay!'),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
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
                    Navigator.pushNamed(
                      context,
                      '/anggota',
                    );
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
        title: Text('Tambah Anggota',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF5E5695),
                )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          const SizedBox(height: 10),
          Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _nomorIndukController,
                      validator: (_nomorIndukController) {
                        if (_nomorIndukController == null ||
                            _nomorIndukController.isEmpty) {
                          return 'Tolong masukkan nomor induk.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Induk',
                        hintText: 'Masukkan nomor induk',
                        prefixIcon:
                            Icon(Icons.perm_identity, color: Color(0xFF5E5695)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _namaController,
                      validator: (_namaController) {
                        if (_namaController == null ||
                            _namaController.isEmpty) {
                          return 'Tolong masukkan nama.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                        hintText: 'Masukkan nama',
                        prefixIcon: Icon(Icons.face, color: Color(0xFF5E5695)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _alamatController,
                      validator: (_alamatController) {
                        if (_alamatController == null ||
                            _alamatController.isEmpty) {
                          return 'Tolong masukkan alamat.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Alamat',
                        hintText: 'Masukkan alamat',
                        prefixIcon: Icon(Icons.house, color: Color(0xFF5E5695)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tglLahirController,
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Lahir',
                        hintText: 'Masukkan tanggal lahir',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectDate();
                      },
                      validator: (value) {
                        if (_tglLahir == null) {
                          return 'Tolong masukkan tanggal lahir';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noTeleponController,
                      validator: (_noTeleponController) {
                        if (_noTeleponController == null ||
                            _noTeleponController.isEmpty) {
                          return 'Tolong masukkan nomor telepon.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Telepon',
                        hintText: 'Masukkan nomor telepon',
                        prefixIcon: Icon(Icons.phone, color: Color(0xFF5E5695)),
                      ),
                    ),
                    const SizedBox(height: 70),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState?.save();
                                  goAddUser();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF857BC9),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 10)),
                              child: Text('Tambah Anggota',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.white))),
                        ),
                      ],
                    ),
                  ]))
        ]),
      ),
    );
  }
}
