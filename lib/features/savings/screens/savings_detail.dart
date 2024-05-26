import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class SavingDetail extends StatefulWidget {
  const SavingDetail({super.key});

  @override
  State<SavingDetail> createState() => _SavingDetailState();
}

class _SavingDetailState extends State<SavingDetail> {
  late final int id;
  late final String nama;
  late final int saldo;
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  List<Map<String, dynamic>> _transactions = [];
  Map<int, String> _transactionTypes = {};

  bool _isInitialized = false; // Flag to check initialization

  @override
  void initState() {
    super.initState();
    getTransactionTypes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized && ModalRoute.of(context)?.settings.arguments != null) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      id = arguments['id'] as int;
      nama = arguments['nama'];
      saldo = arguments['saldo'];
      getDetail();
      _isInitialized = true;
    }
  }

  Future<void> getDetail() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/tabungan/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      if (responseData['success']) {
        setState(() {
          _transactions =
              List<Map<String, dynamic>>.from(responseData['data']['tabungan']);
        });
      }
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

  Future<void> getTransactionTypes() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/jenistransaksi',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      print(responseData);
      if (responseData['success']) {
        setState(() {
          _transactionTypes = {
            for (var item in responseData['data']['jenistransaksi'])
              item['id']: item['trx_name']
          };
        });
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
      child: Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          title: Text('Detail Tabungan',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Color(0xFF5E5695),
                  )),
          actions: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(26, 94, 86, 149),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/savings/tambah',
                      arguments: id);
                },
                icon: Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 16),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(26, 94, 86, 149),
              ),
              child: IconButton(
                onPressed: () {
                  getDetail();
                },
                icon: Icon(
                  Icons.refresh,
                  size: 32,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        body: _transactions.isEmpty
            ? Center(child: Text('No transactions to show'))
            : ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  final transactionType =
                      _transactionTypes[transaction['trx_id']] ?? 'Unknown';
                  return ListTile(
                    title: Text(transaction['trx_nominal'].toString()),
                    subtitle: Text(transactionType),
                    trailing: Text(transaction['trx_tanggal']),
                  );
                },
              ),
      ),
    );
  }
}
