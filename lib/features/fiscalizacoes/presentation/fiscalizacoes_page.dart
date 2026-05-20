import 'package:flutter/material.dart';

class FiscalizacoesPage extends StatelessWidget {
  const FiscalizacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fiscalizacoes')),
      body: const Center(
        child: Text('Vistorias diarias por servico'),
      ),
    );
  }
}
