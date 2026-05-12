import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'presentation/providers/recording_provider.dart';
import 'presentation/providers/session_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecordingProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
      ],
      child: const WellnessApp(),
    ),
  );
}
