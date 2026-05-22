import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    debugPrint(details.toString());
  };
  final storage = SecureStorageService();
  await storage.init();
  runApp(App(storage: storage));
}
