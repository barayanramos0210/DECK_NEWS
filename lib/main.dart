import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'claude_service.dart';
import 'results_page.dart';
import 'processing_page.dart';
import 'firebase_service.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseService().signInAnonymously();

  runApp(const DeckNewsApp());
}

class DeckNewsApp extends StatelessWidget {
  const DeckNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deck News',
      debugShowCheckedModeBanner: false,
      theme: DeckNewsTheme.lightTheme,
      initialRoute: '/splash',
      routes: AppRouter.routes,
    );
  }
}
