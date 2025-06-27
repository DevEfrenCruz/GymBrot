import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/home_screen.dart';
import 'views/routine_screen.dart';
import 'controllers/data_controller.dart';
import 'controllers/routine_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataController()),
        ChangeNotifierProvider(create: (_) => RoutineController()), // Añadido
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
          scaffoldBackgroundColor: const Color(0xFFEAE8E8),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Color(0xFF555555)),
          ),
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/routines': (context) => const RoutineScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}