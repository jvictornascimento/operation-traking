import 'dart:async';

import 'package:flutter/material.dart';

class AppLoadingSpec {
  const AppLoadingSpec._();

  static const gifWidth = 160.0;
  static const gifHeight = 160.0;
  static const maxSplashDuration = Duration(milliseconds: 2500);
  static const initialSplashDuration = Duration(milliseconds: 900);
}

class AppStartupSplash extends StatefulWidget {
  const AppStartupSplash({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AppStartupSplash> createState() => _AppStartupSplashState();
}

class _AppStartupSplashState extends State<AppStartupSplash> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppLoadingSpec.initialSplashDuration, () {
      if (mounted) {
        setState(() => _visible = false);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_visible,
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: const Duration(milliseconds: 220),
              child: const AppLoadingPage(),
            ),
          ),
        ),
      ],
    );
  }
}

class AppLoadingPage extends StatelessWidget {
  const AppLoadingPage({
    super.key,
    this.message = 'Carregando',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.surface,
      child: Center(
        child: Semantics(
          label: message,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: AppLoadingSpec.gifWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.engineering_outlined,
                    size: 72,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: AppLoadingSpec.gifWidth,
                child: LinearProgressIndicator(
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppInlineLoading extends StatelessWidget {
  const AppInlineLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: LinearProgressIndicator(minHeight: 3),
    );
  }
}
