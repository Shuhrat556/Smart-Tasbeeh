import 'package:flutter/widgets.dart';
import 'package:smart_tasbeeh/app.dart';
import 'package:smart_tasbeeh/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const SmartTasbeehRoot());
}
