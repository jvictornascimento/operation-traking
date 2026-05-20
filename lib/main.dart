import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/operation_tracking_app.dart';

void main() {
  runApp(const ProviderScope(child: OperationTrackingApp()));
}
