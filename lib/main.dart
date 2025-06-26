import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/home_screen.dart';
import 'controllers/data_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool onboardingCompleted;

    MyApp({required this.onboardingCompleted});

    @override
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataController()),
      ],
      child: MaterialApp(
        title: 'GymBrot',
        theme: ThemeData(
          primarySwatch: const MaterialColor(
            0xFF007BFF,
            <int, Color>{
              50: Color(0xFFE3F2FD),
              100: Color(0xFFBBDEFB),
              200: Color(0xFF90CAF9),
              300: Color(0xFF64B5F6),
              400: Color(0xFF42A5F5),
              500: Color(0xFF007BFF),
              600: Color(0xFF1976D2),
              700: Color(0xFF1565C0),
              800: Color(0xFF0D47A1),
              900: Color(0xFF0D47A1),
            },
          ),
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(color: Color(0xFFFFFFFF)),
            bodyMedium: TextStyle(color: Color(0xFFB0BEC5)),
          ),
        ),
        home: HomeScreen(),
              initialRoute: onboardingCompleted ? '/login' : '/onboarding',
        debugShowCheckedModeBanner: false,
        routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
      ),
  }
}