import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:flutter_application_1/view/loginRegister_view/loading.dart';
import 'package:flutter_application_1/view/loginRegister_view/startPage.dart';
import 'package:flutter_application_1/view/loginRegister_view/login.dart';
import 'package:flutter_application_1/view/loginRegister_view/register.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope( // Wrap your app with ProviderScope
      child: MaterialApp(
        initialRoute: '/loading',
        routes: {
          '/loading': (context) => const LoadingView(),
          '/start': (context) => const StartPageView(),
          '/login': (context) => const LoginView(),
          '/register': (context) => const RegisterView(),
        },
      ),
    );
  }
  
}
