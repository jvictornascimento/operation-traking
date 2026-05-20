import 'package:flutter/material.dart';

class EmpresasPage extends StatelessWidget {
  const EmpresasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Empresas')),
      body: const Center(
        child: Text('Cadastro de empresas'),
      ),
    );
  }
}
