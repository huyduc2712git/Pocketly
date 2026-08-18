import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'app/config/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Environment Config
  AppConfig.initialize(env: EnvConfig.dev);

  runApp(
    const ProviderScope(
      child: FinlyApp(),
    ),
  );
}
