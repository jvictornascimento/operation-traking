import 'package:flutter/material.dart';

class ContratantesPage extends StatelessWidget {
  const ContratantesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contratantes')),
      body: const Center(
        child: Text('Cadastro de contratantes'),
      ),
    );
  }
}
