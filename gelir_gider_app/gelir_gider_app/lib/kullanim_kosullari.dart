import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanım Koşulları'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Burada kullanım koşulları ile ilgili uzun bir metin olacak...',
        ),
      ),
    );
  }
}
