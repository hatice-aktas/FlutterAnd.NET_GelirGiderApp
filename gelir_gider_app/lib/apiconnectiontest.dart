import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  _ApiTestPageState createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  String _statusMessage = "Henüz kontrol edilmedi.";

  Future<void> checkApiAccess() async {
    String apiUrl =
        'https://localhost:7185/api/Login/test'; // .NET Core API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          _statusMessage = "API'ye erişim başarılı!";
        });
      } else {
        setState(() {
          _statusMessage = "API erişim başarısız: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "API erişim hatası: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Erişim Testi')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_statusMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkApiAccess,
              child: const Text('API Erişimini Kontrol Et'),
            ),
          ],
        ),
      ),
    );
  }
}
