import 'package:flutter/material.dart';
import 'package:gym_brot/controllers/routine_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/home_screen.dart';
import 'views/routine_screen.dart';
import 'views/login.dart';
import 'views/register.dart';
import 'views/onboarding.dart';
import 'providers/user.provider.dart';
import 'controllers/data_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted =
      prefs.getBool('onboardingCompleted') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DataController()),
        ChangeNotifierProvider(create: (_) => RoutineController()),
      ],
      child: MyApp(onboardingCompleted: onboardingCompleted),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool onboardingCompleted;

  const MyApp({required this.onboardingCompleted, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: onboardingCompleted ? '/login' : '/onboarding',
      routes: {
        '/': (context) {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.autoLogin();

          if (!onboardingCompleted) return OnboardingScreen();
          if (userProvider.isLoggedIn) return HomeScreen();
          return LoginScreen();
        },
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/routines': (context) => RoutineScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Nueva pantalla principal que combina HomeScreen y RoutineScreen
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas a mostrar
  final List<Widget> _screens = [
    const HomeScreen(),
    const RoutineScreen(),
  ];

  // Función para cambiar entre pantallas
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Muestra la pantalla seleccionada
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Routines',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF007BFF),
        onTap: _onItemTapped,
      ),
    );
  }
}
