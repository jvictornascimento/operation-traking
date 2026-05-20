import 'package:flutter/material.dart';

class ObrasPage extends StatelessWidget {
  const ObrasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Obras')),
      body: const Center(
        child: Text('Cadastro e acompanhamento de obras'),
      ),
    );
  }
}
