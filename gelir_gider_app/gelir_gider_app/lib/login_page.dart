import 'package:flutter/material.dart';
import 'package:gelir_gider_app/email_register_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false; // Şifre görünürlüğünü kontrol eden değişken

  void login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    var url = Uri.parse('https://localhost:7185/api/Login'); // API adresi

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        // Giriş başarılı, ana sayfaya yönlendir
        Navigator.pushNamed(context, '/home');
      } else {
        // Hata mesajı göster

        print("başarısız: ${response.statusCode}");
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('Hata'),
            content: Text('Kullanıcı adı veya şifre hatalı'),
          ),
        );
      }
    } else {
      // API'den gelen hata
      print('Failed to login: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/login_image.png',
                    height: 150), // Üstteki görsel
                const SizedBox(height: 30),
                SizedBox(
                  width: 750, // Genişliği 75 olarak ayarladık
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: 750, // Genişliği 75 olarak ayarladık
                  child: TextField(
                    controller: passwordController,
                    obscureText:
                        !_isPasswordVisible, // Şifreyi gizleme/gösterme
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    enableInteractiveSelection: false, // Kopyalama engellendi
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 60.0), // Sağ tarafa boşluk ekler
                    child: TextButton(
                      onPressed: () {
                        // Şifremi Unuttum tıklaması, yeni bir sayfaya yönlendirilecek
                      },
                      child: const Text('Şifremi Unuttum?'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent, // Soft mavi renk
                    minimumSize: const Size(750, 50), // Buton genişliği
                  ),
                  child:
                      Text('Giriş Yap', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),

                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('veya'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmailRegisterPage()),
                    );
                  },
                  icon: const Icon(Icons.mail_outline),
                  label: Text('Email ile Kayıt Ol',
                      style: TextStyle(color: Colors.grey.shade700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200, // Soft gri renk
                    minimumSize: const Size(750, 50),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () {
                    // Gmail ile devam etme fonksiyonu
                  },
                  icon: const Icon(Icons.mail_outline),
                  label: Text('Gmail ile Devam Et',
                      style: TextStyle(color: Colors.grey.shade700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200, // Soft gri renk
                    minimumSize: const Size(750, 50),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    // Kaydolmadan Devam Et
                  },
                  child: const Text('Kaydolmadan Devam Et'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp());
}
