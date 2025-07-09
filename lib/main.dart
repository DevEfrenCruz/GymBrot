import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/home_screen.dart';
import 'views/routine_screen.dart';
import 'views/login.dart';
import 'views/register.dart';
import 'views/onboarding.dart';
import 'providers/auth_provider.dart';
import 'providers/routine_provider.dart';
import 'providers/progress_provider.dart';
import 'controllers/data_controller.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted =
      prefs.getBool('onboardingCompleted') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RoutineProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => DataController()),
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
      scaffoldMessengerKey: rootScaffoldMessengerKey,
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF007BFF),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007BFF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: const AuthWrapper(),
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => const MainScreen(),
        '/routines': (context) => const RoutineScreen(),
        '/achievements': (context) => AchievementsScreen(),
        '/challenges': (context) => ChallengesScreen(),
        '/rewards': (context) => RewardsScreen(),
        '/profile': (context) => ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authProvider.isAuthenticated) {
          if (!authProvider.hasCompletedOnboarding) {
            // Mostrar formulario de onboarding si falta completar
            final email = authProvider.currentUser?.email ?? '';
            return OnboardingFormScreen(email: email);
          }
          return const MainScreen();
        }

        return LoginScreen();
      },
    );
  }
}

// Pantalla principal con navegación inferior
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
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Rutinas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF007BFF),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Pantallas placeholder para logros, desafíos, recompensas y perfil
class AchievementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logros')),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, _) {
          final achievements = progressProvider.achievements;
          if (progressProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (achievements.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text('No tienes logros aún.',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: achievements.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, i) {
              final a = achievements[i];
              return ListTile(
                leading: a.achievement?.badgeImage != null
                    ? Image.network(a.achievement!.badgeImage!, height: 40)
                    : Icon(Icons.emoji_events, color: Colors.amber, size: 36),
                title: Text(a.achievement?.name ?? 'Logro',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(a.achievement?.description ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.green, size: 20),
                    SizedBox(width: 4),
                    Text('+${a.achievement?.xpReward ?? 0} XP',
                        style: TextStyle(color: Colors.green)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChallengesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Desafíos')),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, _) {
          final challenges = progressProvider.myChallenges;
          if (progressProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (challenges.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flag, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text('No tienes desafíos activos.',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: challenges.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, i) {
              final c = challenges[i];
              return ListTile(
                leading: Icon(Icons.flag, color: Colors.blue, size: 32),
                title: Text(c.challenge?.name ?? 'Desafío',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(c.challenge?.description ?? ''),
                trailing: Text('${c.progress}/${c.challenge?.goalValue ?? 0}',
                    style: TextStyle(color: Colors.blue)),
              );
            },
          );
        },
      ),
    );
  }
}

class RewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recompensas')),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, _) {
          final rewards = progressProvider.myRewards;
          if (progressProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (rewards.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.card_giftcard, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text('No has canjeado recompensas.',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: rewards.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, i) {
              final r = rewards[i];
              return ListTile(
                leading: r.reward?.imageUrl != null
                    ? Image.network(r.reward!.imageUrl!, height: 40)
                    : Icon(Icons.card_giftcard, color: Colors.purple, size: 36),
                title: Text(r.reward?.name ?? 'Recompensa',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(r.reward?.description ?? ''),
                trailing:
                    Text(r.status, style: TextStyle(color: Colors.purple)),
              );
            },
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;
          if (user == null) {
            return Center(child: Text('No hay datos de usuario.'));
          }
          return ListView(
            padding: EdgeInsets.all(24),
            children: [
              if (user.avatarUrl != null)
                Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl!),
                    radius: 40,
                  ),
                ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text('Nombre'),
                subtitle:
                    Text('${user.firstName ?? ''} ${user.lastName ?? ''}'),
              ),
              ListTile(
                leading: Icon(Icons.account_circle, color: Colors.blue),
                title: Text('Apodo'),
                subtitle: Text(user.nickname ?? ''),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text('Email'),
                subtitle: Text(user.email),
              ),
              ListTile(
                leading: Icon(Icons.transgender, color: Colors.blue),
                title: Text('Género'),
                subtitle: Text(user.gender ?? ''),
              ),
              ListTile(
                leading: Icon(Icons.monitor_weight, color: Colors.blue),
                title: Text('Peso'),
                subtitle: Text('${user.weight?.toStringAsFixed(1) ?? ''} kg'),
              ),
              ListTile(
                leading: Icon(Icons.height, color: Colors.blue),
                title: Text('Altura'),
                subtitle: Text('${user.height?.toStringAsFixed(1) ?? ''} cm'),
              ),
              ListTile(
                leading: Icon(Icons.flag, color: Colors.blue),
                title: Text('Objetivo'),
                subtitle: Text(user.fitnessGoal ?? ''),
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.blue),
                title: Text('Nivel'),
                subtitle: Text(user.experienceLevel ?? ''),
              ),
              ListTile(
                leading: Icon(Icons.emoji_events, color: Colors.amber),
                title: Text('XP'),
                subtitle: Text('${user.currentXp}'),
              ),
              ListTile(
                leading: Icon(Icons.verified, color: Colors.green),
                title: Text('Nivel actual'),
                subtitle: Text(user.currentLevel.name),
              ),
              ListTile(
                leading: Icon(Icons.emoji_events, color: Colors.amber),
                title: Text('Logros'),
                subtitle: Text('${user.totalAchievements ?? 0}'),
              ),
              ListTile(
                leading: Icon(Icons.fitness_center, color: Colors.purple),
                title: Text('Rutinas completadas'),
                subtitle: Text('${user.totalRoutinesCompleted ?? 0}'),
              ),
              ListTile(
                leading: Icon(Icons.local_fire_department, color: Colors.red),
                title: Text('Racha actual'),
                subtitle: Text('${user.currentStreak ?? 0}'),
              ),
            ],
          );
        },
      ),
    );
  }
}
