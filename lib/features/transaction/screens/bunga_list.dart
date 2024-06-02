import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class BungaList extends StatefulWidget {
  const BungaList({super.key});

  @override
  State<BungaList> createState() => _BungaListState();
}

class _BungaListState extends State<BungaList> {
  BungaData? bungaData;
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    getBungaData();
  }

  Future<void> getBungaData() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      Map<String, dynamic> responseData = _response.data;
      setState(() {
        bungaData = BungaData.fromJson(responseData['data']);
      });
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          'Bunga',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Color(0xFF5E5695),
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: bungaData == null
            ? Center(child: CircularProgressIndicator())
            : bungaData!.isEmpty()
                ? Center(
                    child: Text(
                      "No bunga yet",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      if (bungaData!.activeBunga != null)
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              'Active Bunga',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              'Persen: ${bungaData!.activeBunga!.persen}%',
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: Text(
                              'ID: ${bungaData!.activeBunga!.id}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      Divider(),
                      Text(
                        'Inactive Bunga',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5E5695),
                                ),
                      ),
                      if (bungaData!.inactiveBunga.isNotEmpty)
                        ...bungaData!.inactiveBunga
                            .map((bunga) => Card(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 3,
                                  child: ListTile(
                                    title: Text(
                                      'Persen: ${bunga.persen}%',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    trailing: Text(
                                      'ID: ${bunga.id}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ))
                            .toList(),
                    ],
                  ),
      ),
    );
  }
}

class Bunga {
  final int id;
  final double persen;
  final int isaktif;

  Bunga({
    required this.id,
    required this.persen,
    required this.isaktif,
  });

  factory Bunga.fromJson(Map<String, dynamic> json) {
    return Bunga(
      id: json['id'],
      persen: json['persen'],
      isaktif: json['isaktif'],
    );
  }
}

class BungaData {
  final Bunga? activeBunga;
  final List<Bunga> inactiveBunga;

  BungaData({this.activeBunga, required this.inactiveBunga});

  factory BungaData.fromJson(Map<String, dynamic> json) {
    final settingbungas = json['settingbungas'] as List<dynamic>;
    final activeBunga = json['activebunga'] != null
        ? Bunga.fromJson(json['activebunga'])
        : null;
    final inactiveBunga = settingbungas
        .map((data) => Bunga.fromJson(data as Map<String, dynamic>))
        .where((bunga) => bunga.isaktif == 0)
        .toList();

    return BungaData(
      activeBunga: activeBunga,
      inactiveBunga: inactiveBunga,
    );
  }

  bool isEmpty() {
    return activeBunga == null && inactiveBunga.isEmpty;
  }
}
