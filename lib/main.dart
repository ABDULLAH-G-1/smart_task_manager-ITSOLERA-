import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart'; // Provider import
import 'models/task.dart';
import 'providers/task_provider.dart'; // TaskProvider import
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskProvider())],
      child: const SmartTaskManager(),
    ),
  );
}

class SmartTaskManager extends StatelessWidget {
  const SmartTaskManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Task Manager',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
