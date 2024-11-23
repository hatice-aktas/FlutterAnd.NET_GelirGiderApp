import 'package:flutter/material.dart';
import 'package:gelir_gider_app/email_register_page.dart';
import 'package:gelir_gider_app/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isPasswordVisible = false; // Şifre görünürlüğünü kontrol eden değişken

  Future<void> _googleLogin() async {
    try {
      // Kullanıcıyı Google ile giriş yapmaya zorla
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // Kullanıcı giriş yapmadan çıktı
        return;
      }

      // Google'dan kullanıcı bilgilerini al
      final String email = googleUser.email;
      final String fullName = googleUser.displayName ?? "Kullanıcı";

      // API'ye kayıt gönder
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5139/api/User/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": fullName,
          "email": email,
          "password": "", // Şifre olmayacak, Google ile kayıt
          "phone": "" // Telefon numarası yok
        }),
      );

      if (response.statusCode == 200) {
        // Kayıt başarılıysa anasayfaya yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Hata mesajı göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kayıt başarısız: ${response.body}")),
        );
      }
    } catch (error) {
      // Hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $error")),
      );
    }
  }

  void login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    var url = Uri.parse('http://10.0.2.2:5139/api/Login'); // API adresi

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmailRegisterPage()),
                        );
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
                  child: const Text('Giriş Yap',
                      style: TextStyle(color: Colors.white)),
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
                          builder: (context) => const EmailRegisterPage()),
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
                  onPressed: _googleLogin,
                  icon: Image.asset(
                    'assets/gmail_icon.png',
                    height: 24,
                    width: 24,
                  ),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
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
