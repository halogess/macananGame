import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macanan_game/app.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const App());
  });
}

