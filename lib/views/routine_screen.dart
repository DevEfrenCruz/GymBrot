import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/data_controller.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({Key? key}) : super(key: key);

  // Paleta de colores (reutiliza la de HomeScreen)
  static const primaryColor = Color(0xFF007BFF);
  static const successColor = Color(0xFF04CE4B);
  static const textColor = Colors.white;
  static const backgroundColor = Color(0xFFEAE8E8);
  static const primaryTextColor = Colors.black;
  static const secondaryTextColor = Color(0xFF555555);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Rutinas',
            style: TextStyle(
                color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: textColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Container(
        color: backgroundColor,
        child: Consumer<DataController>(
          builder: (context, controller, child) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Widget placeholder para "Mi Entrenador IA"
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mi Entrenador IA',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Próximamente: Entrenamiento personalizado con IA.',
                          style: TextStyle(color: secondaryTextColor),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Lista de ejercicios
                ...controller.data.map((item) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: secondaryTextColor),
                    ),
                    child: ListTile(
                      leading:
                          Icon(Icons.circle, color: successColor, size: 10),
                      title: Text(item.title,
                          style:
                              TextStyle(color: primaryTextColor, fontSize: 18)),
                      subtitle: Text(item.description,
                          style: TextStyle(color: secondaryTextColor)),
                      trailing: Icon(Icons.emoji_events, color: successColor),
                      onTap: () {
                        // Lógica al tocar un item (opcional por ahora)
                      },
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: primaryColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('GYMBROT',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
                Text('Panel de inicio',
                    style: TextStyle(
                        color: textColor.withOpacity(0.8), fontSize: 14)),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Inicio', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/home');
          }),
          _buildDrawerItem(Icons.fitness_center, 'Mis Rutinas', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/routines');
          }),
          _buildDrawerItem(Icons.restaurant, 'Nutrición', () {}),
          _buildDrawerItem(Icons.emoji_events, 'Desafíos', () {}),
          _buildDrawerItem(Icons.person, 'Perfil', () {}),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: successColor),
      title: Text(title, style: TextStyle(color: primaryTextColor)),
      onTap: onTap,
    );
  }
}
