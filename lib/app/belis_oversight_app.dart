import 'package:flutter/material.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/app_loading.dart';

class BelisOversightApp extends StatelessWidget {
  const BelisOversightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'belis-oversight',
      theme: AppTheme.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return AppStartupSplash(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
