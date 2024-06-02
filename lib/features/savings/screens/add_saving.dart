import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class AddSaving extends StatefulWidget {
  const AddSaving({super.key});

  @override
  State<AddSaving> createState() => _AddSavingState();
}

class _AddSavingState extends State<AddSaving> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _transactionNominalController = TextEditingController();

  List<Map<String, dynamic>> _transactionTypes = [];
  int? id;
  int? _selectedTransactionID;

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    fetchTransactionTypes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.settings.arguments != null) {
      id = ModalRoute.of(context)?.settings.arguments as int;
    }
  }

  Future<void> fetchTransactionTypes() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/jenistransaksi',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      if (responseData['success']) {
        setState(() {
          _transactionTypes = List<Map<String, dynamic>>.from(
              responseData['data']['jenistransaksi']);
        });
      }
    } catch (e) {
      print('Error fetching transaction types: $e');
    }
  }

  Future<void> addSaving() async {
    try {
      final _response = await _dio.post(
        '$_apiUrl/tabungan',
        data: {
          'anggota_id': id,
          'trx_id': _selectedTransactionID,
          'trx_nominal': int.parse(_transactionNominalController.text)
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
                  title: Text("Transaksi berhasil ditambahkan!"),
                  content: Text('Yeay!'),
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
                  title: Text(responseData['message']),
                  content: Text('Wait...'),
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
          title: Text('Lakukan Transaksi',
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
                          value: _selectedTransactionID,
                          onChanged: (value) {
                            setState(() {
                              _selectedTransactionID = value;
                            });
                          },
                          items: _transactionTypes.map((transaction) {
                            return DropdownMenuItem<int>(
                              value: transaction['id'],
                              child: Text(transaction['trx_name']),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Pilih Jenis Transaksi',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value == null
                              ? 'Silakan pilih jenis transaksi'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _transactionNominalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Nominal Transaksi',
                            prefixIcon: Icon(Icons.monetization_on_rounded,
                                color: Color(0xFF5E5695)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Silakan masukkan nominal transaksi';
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
                                      addSaving();
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
                                  child: Text('Lakukan Transaksi',
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
