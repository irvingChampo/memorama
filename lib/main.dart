import 'package:flutter/material.dart';
import 'package:memorama/myapp.dart';
import 'package:memorama/provider/memo_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // MultiProvider es útil si en el futuro agregas más providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}