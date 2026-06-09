import 'package:flutter/material.dart';

import '../../../core/widgets/app_back_button.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Relatorios'),
      ),
      body: const Center(
        child: Text('Geracao de PDFs locais'),
      ),
    );
  }
}
