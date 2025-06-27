import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/routine_controller.dart';
import '../models/routine_model.dart';

// Simulación de imágenes (puedes reemplazar con rutas reales de una BD)
class ExerciseImage {
  static const Map<String, String> imagePaths = {
    'Ejercicio de Pierna': 'assets/images/leg_exercise.png',
    'Ejercicio de Brazo': 'assets/images/arm_exercise.png',
    'Ejercicio de Espalda': 'assets/images/back_exercise.png',
    'Ejercicio de Core': 'assets/images/core_exercise.png',
  };
}

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({Key? key}) : super(key: key);

  static const primaryColor = Color(0xFF007BFF);
  static const successColor = Color(0xFF04CE4B);
  static const textColor = Colors.white;
  static const backgroundColor = Color(0xFFEAE8E8);
  static const primaryTextColor = Colors.black;
  static const secondaryTextColor = Color(0xFF555555);

  void _showSubExercisesDialog(BuildContext context, RoutineModel routine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(routine.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: routine.subExercises.map((sub) {
            return ListTile(
              leading: Icon(
                sub.isCompleted ? Icons.check_circle : Icons.circle,
                color: sub.isCompleted ? successColor : Colors.grey,
              ),
              title: Text(sub.name),
              subtitle: Text(
                  'Completado: ${routine.subExercises.where((se) => se.isCompleted).length}/${routine.subExercises.length}'),
              trailing: IconButton(
                icon: Icon(Icons.info, color: primaryColor),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('${sub.name} - Detalles'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              sub.imagePath,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              sub.explanation,
                              style: TextStyle(color: secondaryTextColor),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              onTap: () {
                Provider.of<RoutineController>(context, listen: false)
                    .toggleCompletion(routine, sub);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showExerciseDetails(BuildContext context, RoutineModel routine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(routine.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                ExerciseImage.imagePaths[routine.name] ??
                    'assets/images/placeholder.png',
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                'Descripción Detallada: ${routine.description}',
                style: TextStyle(color: secondaryTextColor),
              ),
              const SizedBox(height: 10),
              Text(
                'Instrucciones: Realiza cada repetición con control, manteniendo una postura correcta. Descansa 60 segundos entre series.',
                style: TextStyle(color: secondaryTextColor),
              ),
              if (routine.duration != null)
                Text('Duración Total: ${routine.duration} minutos',
                    style: TextStyle(color: secondaryTextColor)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

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
        child: Consumer<RoutineController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    controller.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              );
            }
            final List<RoutineModel> routines = controller.routines;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'MODO: ${controller.selectedLevel}',
                    style: TextStyle(fontSize: 18, color: primaryTextColor),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
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
                      ...routines.map((routine) {
                        final progress = routine.subExercises
                                .where((se) => se.isCompleted)
                                .length /
                            routine.subExercises.length;
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: secondaryTextColor),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.circle,
                              color: routine.isCompleted
                                  ? successColor
                                  : Colors.grey,
                              size: 10,
                            ),
                            title: Text(routine.name,
                                style: TextStyle(
                                    color: primaryTextColor, fontSize: 18)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(routine.description,
                                    style:
                                        TextStyle(color: secondaryTextColor)),
                                if (routine.duration != null)
                                  Text('Duración: ${routine.duration} min',
                                      style: TextStyle(
                                          color: secondaryTextColor,
                                          fontSize: 12)),
                                LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey[300],
                                  color: successColor,
                                ),
                              ],
                            ),
                            trailing: routine.order < 4
                                ? Icon(Icons.emoji_events, color: successColor)
                                : null,
                            onTap: () =>
                                _showSubExercisesDialog(context, routine),
                            onLongPress: () => _showExerciseDetails(
                                context, routine), // Nueva acción
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logoGymBrot.png', // Asegúrate de que el nombre coincida con pubspec.yaml
                height: 50,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              const Text(
                'GYMBROT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                'Panel de inicio',
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
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
