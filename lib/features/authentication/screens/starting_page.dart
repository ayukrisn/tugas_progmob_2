import 'package:flutter/material.dart';

class StartingPage extends StatelessWidget {
  const StartingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 56),
                Image.asset(
                  'assets/images/logo2.png',
                  height: 25,
                ),
                const SizedBox(height: 48),
                Image.asset(
                  'assets/images/image1.png',
                  width: 250,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        "Bingung cari tempat simpan pinjam yang terpercaya?",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Color(0xFF5E5695),
                            ),
                      ),
                      const SizedBox(height: 32),
                      const Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Tidak perlu pusing lagi! ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                height: 1.5,
                              ),
                            ),
                            TextSpan(
                              text: 'BorrowMo',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF5E5695),
                                  fontWeight: FontWeight.bold,
                                  height: 1.5),
                            ),
                            TextSpan(
                              text:
                                  ' menyediakan layanan simpan pinjam yang transparan dan dapat diandalkan, sehingga kamu bisa fokus pada kebutuhan finansialmu tanpa khawatir.',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF857BC9),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        child: Text('Mulai Sekarang',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Punya akun? ',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5E5695),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
