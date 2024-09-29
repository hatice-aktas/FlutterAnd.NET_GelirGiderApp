import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelir_gider_app/login_page.dart';
import 'package:http/http.dart' as http;

class EmailRegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.length <= 3) {
      return newValue;
    }

    // Format to 0 505 574 98 32
    String formatted = '0 (' +
        text.substring(1, 4) +
        ') ' +
        text.substring(4, 7) +
        ' ' +
        text.substring(7, 9) +
        ' ' +
        text.substring(9, 11);
    return TextEditingValue(
      text: formatted,
      selection: newValue.selection.copyWith(
        baseOffset: formatted.length,
        extentOffset: formatted.length,
      ),
    );
  }
}

class _RegisterPageState extends State<EmailRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                // Görsel eklemesi
                Container(
                  width: 150, // login sayfasıyla orantılı
                  child: Image.asset(
                    'assets/login_image.png', // kayıt sayfasındaki görsel
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20),

                // Kullanıcı Adı TextField
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kullanıcı adı zorunludur';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // E-posta TextField
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email zorunludur';
                    }
                    String pattern =
                        r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return 'Geçerli bir email giriniz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Telefon Numarası TextField
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Telefon Numarası'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                    PhoneInputFormatter()
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Telefon numarası zorunludur';
                    }
                    if (value.length != 17) {
                      return 'Telefon numarası 17 haneli olmalıdır';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Şifre TextField
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre zorunludur';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Şifre Doğrulama TextField
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Şifre Doğrulama',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre doğrulama zorunludur';
                    }
                    if (value != _passwordController.text) {
                      return 'Şifreler eşleşmiyor';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Kullanım Koşulları ve Gizlilik Politikası
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Kayıt olarak, '),
                    InkWell(
                      onTap: () {
                        // Kullanım Koşulları sayfasına yönlendir
                        Navigator.pushNamed(context, '/kullanim_kosullari');
                      },
                      child: Text(
                        'Kullanım Koşulları',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    Text(' ve '),
                    InkWell(
                      onTap: () {
                        // Gizlilik Politikası sayfasına yönlendir
                        Navigator.pushNamed(context, '/gizlilik_sozlesmesi');
                      },
                      child: Text(
                        'Gizlilik Politikası',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    Text('\'nı kabul etmiş olursunuz.'),
                  ],
                ),
                SizedBox(height: 20),

                // Kaydet Butonu
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      var url = Uri.parse(
                          'http://yourapi.com/register'); // API endpoint
                      var response = await http.post(url, body: {
                        'username': _usernameController.text,
                        'email': _emailController.text,
                        'password': _passwordController.text,
                      });

                      if (response.statusCode == 200) {
                        // Başarılı kayıt sonrası yapılacaklar
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } else {
                        // Hata durumu
                        print('Kayıt başarısız oldu');
                      }
                    }
                  },
                  child: Text('Kaydet'),
                ),
                SizedBox(height: 10),

                // Zaten Kayıtlı mısınız? Giriş Yap butonu
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Zaten kayıtlı mısınız? '),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Giriş Yap',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
