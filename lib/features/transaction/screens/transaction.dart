import 'package:flutter/material.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Transaksi',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Color(0xFF5E5695),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            buildMenuItem(
              context,
              icon: Icons.monetization_on_rounded,
              title: 'Jenis Transaksi',
              routeName: '/transactionType',
            ),
            buildMenuItem(
              context,
              icon: Icons.savings,
              title: 'Bunga',
              routeName: '/bungaList',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, {required IconData icon, required String title, required String routeName}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          routeName,
        );
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xFF5E5695),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}