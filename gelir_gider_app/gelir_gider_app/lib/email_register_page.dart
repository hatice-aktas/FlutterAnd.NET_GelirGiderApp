import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelir_gider_app/gizlilik_sozlesmesi.dart';
import 'package:gelir_gider_app/kullanim_kosullari.dart';
import 'package:gelir_gider_app/login_page.dart';
import 'package:http/http.dart' as http;

class EmailRegisterPage extends StatefulWidget {
  const EmailRegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<EmailRegisterPage> {
  String _statusMessage = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isHoveringGirisYap = false;
  bool _isHoveringTerms = false;
  bool _isHoveringPrivacy = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    _isHoveringGirisYap = false;
    _isHoveringTerms = false;
    _isHoveringPrivacy = false;
  }

  // Telefon numarası validasyonu

  String formatPhoneNumber(String number) {
    number =
        number.replaceAll(RegExp(r'\D'), ''); // Harfleri ve işaretleri kaldır

    if (number.isEmpty) {
      return '';
    }

    if (!number.startsWith('0')) {
      return '0'; // Başta 0 yoksa hata
    }

    if (number.length > 1) {
      number =
          '${number.substring(0, 1)} ${number.substring(1)}'; // İlk "0" ve boşluk
    }
    if (number.length > 5) {
      number =
          '${number.substring(0, 5)} ${number.substring(5)}'; // İlk 3 rakamdan sonra boşluk
    }
    if (number.length > 9) {
      number =
          '${number.substring(0, 9)} ${number.substring(9)}'; // Sonraki 3 rakamdan sonra boşluk
    }
    if (number.length > 12) {
      number =
          '${number.substring(0, 12)} ${number.substring(12)}'; // Son 2 rakamdan sonra boşluk
    }
    if (number.length > 15) {
      number = number.substring(0, 15); // Maksimum 11 rakam, fazla girilmesin
    }
    return number;
  }

  // Email format validasyonu
  String? _validateEmail(String? value) {
    final emailRegExp = RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value == null || value.isEmpty) {
      return 'Email zorunlu';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Geçersiz email formatı';
    }
    return null;
  }

  // Formu kaydet
  void _register() async {
    setState(() {
      _statusMessage = "1";
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        _statusMessage = "2";
      });
      var url =
          Uri.parse('https://localhost:7185/api/User/register'); // API endpoint
      String phoneNumber =
          _phoneController.text.replaceAll(' ', ''); // Boşlukları kaldır
      if (phoneNumber.length != 11) {
        print('Geçersiz telefon numarası!');
        return; // Hatalı formatta kaydetme işlemi yapılmasın
      }
      // Diğer form verilerini kaydet
      print('Kaydedilecek Telefon Numarası: $phoneNumber');
      try {
        var response = await http.post(url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              'username': _usernameController.text,
              'email': _emailController.text,
              'phone': _phoneController.text,
              'password': _passwordController.text,
            }));

        if (response.statusCode == 200) {
          // Başarılı kayıt sonrası yapılacaklar
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          print('Kayıt başarılı');
          setState(() {
            _statusMessage = "başarılı: ${response.statusCode}";
          });
        } else {
          // Hata durumu
          print('Kayıt başarısız oldu');
          setState(() {
            _statusMessage = "başarısız: ${response.statusCode}";
          });
        }
      } catch (e) {
        setState(() {
          _statusMessage = "API erişim hatası: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Görsel ekleyelim (Login sayfasındaki gibi boyutlanmış)
              Image.asset(
                'assets/login_image.png',
                width: 100,
                height: 100,
              ),
              SizedBox(
                width: 750,
                child: TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kullanıcı adı zorunlu';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(
                width: 750,
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: _validateEmail,
                ),
              ),

              SizedBox(
                width: 750,
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (value.length != 15) {
                        return 'Telefon numarası 11 haneli olmalıdır';
                      }
                    }

                    return null;
                  },
                  onChanged: (value) {
                    String formatted = formatPhoneNumber(value);
                    _phoneController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: formatted.length),
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    labelText: 'Telefon',
                    errorText: _phoneController.text.isNotEmpty &&
                            !_phoneController.text.startsWith('0')
                        ? 'Telefon numarası 0 ile başlamalıdır'
                        : null, // Format hatası
                  ),
                ),
              ),

              SizedBox(
                width: 750,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre zorunlu';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 750,
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Şifreyi Doğrula',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre doğrulama zorunlu';
                    } else if (value != _passwordController.text) {
                      return 'Şifreler eşleşmiyor';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Kayıt olarak, '),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TermsConditionsPage()),
                        );
                      },
                      child: Text(
                        'Kullanım Koşulları',
                        style: TextStyle(
                            fontSize: 16,
                            decoration: _isHoveringTerms
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            color: Colors.blue),
                      ),
                      onHover: (hovering) {
                        setState(() {
                          _isHoveringTerms = hovering;
                        });
                      },
                    ),
                  ),
                  const Text(' ve '),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicyPage()),
                        );
                      },
                      child: Text(
                        'Gizlilik Politikası',
                        style: TextStyle(
                            fontSize: 16,
                            decoration: _isHoveringPrivacy
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            color: Colors.blue),
                      ),
                      onHover: (hovering) {
                        setState(() {
                          _isHoveringPrivacy = hovering;
                        });
                      },
                    ),
                  ),
                  const Text('nı kabul etmiş olursunuz.'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(750, 50)),
                child: Text('Kaydet'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Zaten kayıtlı mısınız? '),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Giriş Yap',
                        style: TextStyle(
                            fontSize: 16,
                            decoration: _isHoveringGirisYap
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            color: Colors.blue),
                      ),
                      onHover: (hovering) {
                        setState(() {
                          _isHoveringGirisYap = hovering;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(_statusMessage),
            ],
          ),
        ),
      ),
    );
  }
}
