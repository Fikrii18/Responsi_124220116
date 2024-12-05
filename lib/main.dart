import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nitendo/lama/models/boxes.dart';
import 'package:nitendo/lama/models/todo.dart';
import 'package:nitendo/lama/views/list.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(todoAdapter());
  await Hive.openBox<todo>(HiveBoxes.todo);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title : 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimeListScreen()
    );
  }
}


