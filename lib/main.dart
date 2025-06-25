import 'package:flutter/material.dart';
import 'package:gym_brot/providers/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/login.dart';
import 'views/register.dart';
import 'views/onboarding.dart';
import 'providers/user.provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted =
      prefs.getBool('onboardingCompleted') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(onboardingCompleted: onboardingCompleted),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool onboardingCompleted;

  MyApp({required this.onboardingCompleted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: onboardingCompleted ? '/login' : '/onboarding',
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
