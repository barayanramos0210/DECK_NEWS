import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/login_page.dart';
import 'pages/processing_page.dart';
import 'pages/results_page.dart';
import 'pages/category_detail_page.dart';
import 'pages/chat_page.dart';
import 'pages/reflection_page.dart';
import 'pages/history_page.dart';
import 'pages/splash_page.dart';
import 'analysis_model.dart';

class AppRouter {
  static Map<String, WidgetBuilder> get routes {
    return {
      '/splash': (context) => const SplashPage(),
      '/login': (context) => const LoginPage(),
      '/': (context) => const HomePage(),
      '/processing': (context) => ProcessingPage(onFinished: () {}),
      '/results': (context) {
        final args = ModalRoute.of(context)!.settings.arguments;
        if (args is AnalysisResult) {
          return ResultsPage(result: args);
        }
        return const Scaffold(body: Center(child: Text("Error: No hay datos de análisis")));
      },
      '/category-detail': (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        if (args == null) return const Scaffold(body: Center(child: Text("Error de datos")));
        return CategoryDetailPage(
          category: args['category'],
          hallazgos: args['hallazgos'],
        );
      },
      '/chat': (context) {
        final args = ModalRoute.of(context)!.settings.arguments;
        if (args is AnalysisResult) {
          return ChatPage(result: args);
        }
        return const Scaffold(body: Center(child: Text("Error: No hay datos de análisis")));
      },
      '/reflection': (context) => const ReflectionPage(),
      '/history': (context) => const HistoryPage(),
      '/about': (context) => const AboutPage(),
    };
  }
}
