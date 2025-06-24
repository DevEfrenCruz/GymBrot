import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/home_screen.dart'; // Ruta corregida a lib/views/home_screen.dart
import 'controllers/data_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataController()..fetchData()), // Carga datos al iniciar
      ],
      child: MaterialApp(
        title: 'GymBrot',
        theme: ThemeData(
          primarySwatch: const MaterialColor(
            0xFF007BFF, // Azul eléctrico como color primario
            <int, Color>{
              50: Color(0xFFE3F2FD),
              100: Color(0xFFBBDEFB),
              200: Color(0xFF90CAF9),
              300: Color(0xFF64B5F6),
              400: Color(0xFF42A5F5),
              500: Color(0xFF007BFF), // Valor base
              600: Color(0xFF1976D2),
              700: Color(0xFF1565C0),
              800: Color(0xFF0D47A1),
              900: Color(0xFF0D47A1),
            },
          ),
          scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Negro profundo como fondo
          textTheme: const TextTheme(
            headlineSmall: TextStyle(color: Color(0xFFFFFFFF)), // Reemplaza headline6
            bodyMedium: TextStyle(color: Color(0xFFB0BEC5)), // Reemplaza bodyText1
          ),
        ),
        home: HomeScreen(), // Solo muestra HomeScreen
        debugShowCheckedModeBanner: false, // Oculta la bandera de debug
      ),
    );
  }
}