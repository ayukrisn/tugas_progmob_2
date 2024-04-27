import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _passwordVisible = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void goRegister() async {
    try {
      final _response = await _dio.post(
        '${_apiUrl}/register',
        data: {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print(_response.data);
      final token = _response.data['data']['token'];
      final userData = _response.data['data'];
      _storage.write('token', token);
      _storage.write('userData', userData);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Register berhasil!"),
              content: Text('Ayo log in dengan akun barumu'),
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
      Navigator.pushReplacementNamed(
        context,
        '/login',
        arguments: userData,
      );
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
      backgroundColor: Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 32),
            Center(
              child: Image.asset(
                'assets/images/logo2.png',
                height: 30,
              ),
            ),
            const SizedBox(height: 48),
            Text("Salam kenal!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Color(0xFF5E5695),
                    )),
            const SizedBox(height: 8),
            const Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Mulai dengan memasukkan ',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  TextSpan(
                    text: 'nama, e-mail, dan password',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5E5695),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' di bawah, lalu kita akan segera memulai!',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    validator: (_nameController) {
                      if (_nameController == null || _nameController.isEmpty) {
                        return 'Tolong masukkan namamu.';
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
                    controller: _emailController,
                    validator: (_emailController) {
                      if (_emailController == null ||
                          _emailController.isEmpty) {
                        return 'Tolong masukkan email.';
                      }
                      if (!RegExp(r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b',
                              caseSensitive: false)
                          .hasMatch(_emailController)) {
                        return 'Tolong masukkan email yang valid';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Color(0xFF5E5695)),
                      labelText: 'E-mail',
                      hintText: 'Masukkan e-mail',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    validator: (_passwordController) {
                      if (_passwordController == null ||
                          _passwordController.isEmpty) {
                        return 'Tolong masukkan password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Masukkan password',
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF5E5695)),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFF5E5695),
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_passwordVisible,
                    validator: (_confirmPasswordController) {
                      if (_confirmPasswordController == null ||
                          _confirmPasswordController.isEmpty) {
                        return 'Tolong konfirmasi passwordmu.';
                      }
                      if (_confirmPasswordController !=
                          _passwordController.text) {
                        return "Password tidak cocok";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Masukkan ulang passwordmu',
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF5E5695)),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFF5E5695),
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Dengan melanjutkan, Anda setuju pada  ',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  'Ketentuan Kebijakan dan Peraturan Privasi kami.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5E5695),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _agreeToTerms,
                    onChanged: (newValue) {
                      setState(() {
                        _agreeToTerms = newValue ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 70),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  _agreeToTerms) {
                                _formKey.currentState?.save();
                                goRegister();
                              } else if (!_agreeToTerms) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Mohon untuk membaca dan menyetujui Ketentuan Kebijakan dan Peraturan Privasi kami.'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFF857BC9),
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            child: Text('Sign up',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.white))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sudah punya akun? ",
                        style:
                            Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/login',
                          );
                        },
                        child: Text(
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
          ],
        ),
      ),
    );
  }
}
