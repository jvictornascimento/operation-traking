import 'package:flutter/material.dart';

import '../../../core/widgets/app_back_button.dart';

class FiscalizacoesPage extends StatelessWidget {
  const FiscalizacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Fiscalizacoes'),
      ),
      body: const Center(
        child: Text('Vistorias diarias por servico'),
      ),
    );
  }
}
