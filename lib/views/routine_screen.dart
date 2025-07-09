import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/routine_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/progress_provider.dart';
import '../models/routine_models.dart';

// Simulación de imágenes (puedes reemplazar con rutas reales de una BD)
class ExerciseImage {
  static const Map<String, String> imagePaths = {
    'Ejercicio de Pierna': 'assets/images/leg_exercise.png',
    'Ejercicio de Brazo': 'assets/images/arm_exercise.png',
    'Ejercicio de Espalda': 'assets/images/back_exercise.png',
    'Ejercicio de Core': 'assets/images/core_exercise.png',
  };
}

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({Key? key}) : super(key: key);

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  static const primaryColor = Color(0xFF007BFF);
  static const successColor = Color(0xFF04CE4B);
  static const textColor = Colors.white;
  static const backgroundColor = Color(0xFFEAE8E8);
  static const primaryTextColor = Colors.black;
  static const secondaryTextColor = Color(0xFF555555);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routineProvider =
          Provider.of<RoutineProvider>(context, listen: false);
      final progressProvider =
          Provider.of<ProgressProvider>(context, listen: false);
      routineProvider.loadRoutines();
      routineProvider.loadMyRoutines();
      progressProvider.loadCurrentXp();
      progressProvider.loadWeeklyStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutinas',
            style: TextStyle(
                color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
      ),
      drawer: _buildDrawer(context),
      body: Container(
        color: backgroundColor,
        child: Consumer3<RoutineProvider, AuthProvider, ProgressProvider>(
          builder: (context, routineProvider, authProvider, progressProvider,
              child) {
            if (routineProvider.isLoading || progressProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (routineProvider.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    routineProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              );
            }
            final availableRoutines = routineProvider.routines;
            print('Rutinas a mostrar: \\${availableRoutines.length}');
            final myRoutines = routineProvider.myRoutines;
            final inProgress =
                myRoutines.where((r) => r.completedAt == null).toList();
            final completed =
                myRoutines.where((r) => r.completedAt != null).toList();
            final user = authProvider.currentUser;
            final xpTotal = progressProvider.currentXp;
            final xpWeek = progressProvider.getWeeklyXpEarned();
            final level = user?.currentLevel;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Nivel, badge y XP
                if (user != null && level != null) ...[
                  Row(
                    children: [
                      if (level.badgeImage != null)
                        Image.network(level.badgeImage!,
                            height: 40,
                            width: 40,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.emoji_events, size: 40)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nivel: ${level.name}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('XP: $xpTotal',
                              style: const TextStyle(fontSize: 14)),
                          Text('XP esta semana: $xpWeek',
                              style: const TextStyle(
                                  fontSize: 12, color: secondaryTextColor)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
                const Text('Rutinas disponibles',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor)),
                const SizedBox(height: 8),
                ...availableRoutines.map((routine) => Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(routine.title ?? 'Rutina',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor)),
                        subtitle: Text(routine.description ?? '',
                            style: const TextStyle(color: secondaryTextColor)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () => _showRoutineDetailDialog(
                            context, routine, user?.userId),
                      ),
                    )),
                const SizedBox(height: 24),
                if (inProgress.isNotEmpty) ...[
                  const Text('En progreso',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor)),
                  const SizedBox(height: 8),
                  ...inProgress.map((userRoutine) => Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(userRoutine.routineTitle ?? 'Rutina',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Inicio: ${_formatDate(userRoutine.startedAt)}',
                                  style: const TextStyle(fontSize: 12)),
                              _buildProgressBar(userRoutine),
                            ],
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () =>
                              _showUserRoutineDialog(context, userRoutine),
                        ),
                      )),
                  const SizedBox(height: 24),
                ],
                if (completed.isNotEmpty) ...[
                  const Text('Completadas',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor)),
                  const SizedBox(height: 8),
                  ...completed.map((userRoutine) => Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(userRoutine.routineTitle ?? 'Rutina',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Inicio: ${_formatDate(userRoutine.startedAt)}',
                                  style: const TextStyle(fontSize: 12)),
                              if (userRoutine.completedAt != null)
                                Text(
                                    'Finalizada: ${_formatDate(userRoutine.completedAt)}',
                                    style: const TextStyle(fontSize: 12)),
                              if (userRoutine.xpEarned != null)
                                Text('XP ganado: ${userRoutine.xpEarned}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.green)),
                            ],
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () =>
                              _showUserRoutineDialog(context, userRoutine),
                        ),
                      )),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildProgressBar(UserRoutineDto userRoutine) {
    final total = userRoutine.steps.length;
    final done = userRoutine.steps.where((s) => s.isDone).length;
    final percent = total == 0 ? 0.0 : done / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: percent,
          backgroundColor: Colors.grey[300],
          color: successColor,
        ),
        const SizedBox(height: 4),
        Text('${(percent * 100).toStringAsFixed(0)}% completado',
            style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showRoutineDetailDialog(
      BuildContext context, RoutineDto routine, int? userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(routine.title ?? 'Rutina'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(routine.description ?? '',
                  style: const TextStyle(color: secondaryTextColor)),
              const SizedBox(height: 12),
              Text('Nivel: ${routine.level?.name ?? 'N/A'}'),
              Text('Duración: ${routine.durationMin ?? 0} min'),
              const SizedBox(height: 12),
              const Text('Ejercicios:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...routine.exercises.map((ex) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: ex.mediaUrl != null
                        ? Image.network(ex.mediaUrl!,
                            height: 32,
                            width: 32,
                            errorBuilder: (_, __, ___) => Icon(_muscleGroupIcon(
                                ex.primaryMuscle ?? MuscleGroup.fullBody)))
                        : Icon(
                            _muscleGroupIcon(
                                ex.primaryMuscle ?? MuscleGroup.fullBody),
                            size: 28),
                    title: Text(ex.exerciseName ?? ''),
                    subtitle: Text(
                        'Sets: \\${ex.sets ?? '-'}, Reps: \\${ex.reps ?? '-'}'),
                    onTap: () => _showExerciseDetailDialog(context, ex),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: userId == null
                ? null
                : () async {
                    final routineProvider =
                        Provider.of<RoutineProvider>(context, listen: false);
                    final userRoutine = await routineProvider.startRoutine(
                        routine.routineId ?? 0, userId);
                    Navigator.pop(context);
                    if (userRoutine != null) {
                      await routineProvider
                          .loadMyRoutine(userRoutine.userRoutineId ?? 0);
                      final refreshed = routineProvider.currentUserRoutine;
                      if (refreshed != null) {
                        _showUserRoutineDialog(context, refreshed);
                      }
                    }
                  },
            child: const Text('Iniciar rutina'),
          ),
        ],
      ),
    );
  }

  void _showExerciseDetailDialog(BuildContext context, RoutineExerciseDto ex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ex.exerciseName ?? 'Ejercicio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grupo muscular: \\${ex.primaryMuscle?.name ?? '-'}'),
            Text('Sets: \\${ex.sets ?? '-'}, Reps: \\${ex.reps ?? '-'}'),
            if (ex.mediaUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.network(ex.mediaUrl!,
                    height: 120,
                    errorBuilder: (_, __, ___) => Icon(
                        _muscleGroupIcon(
                            ex.primaryMuscle ?? MuscleGroup.fullBody),
                        size: 80)),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(
                    _muscleGroupIcon(ex.primaryMuscle ?? MuscleGroup.fullBody),
                    size: 80),
              ),
          ],
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

  void _showUserRoutineDialog(
      BuildContext context, UserRoutineDto userRoutine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(userRoutine.routineTitle ?? 'Rutina'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userRoutine.completedAt != null) ...[
                const Text('¡Rutina completada!',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
                if (userRoutine.xpEarned != null)
                  Text('XP ganado: ${userRoutine.xpEarned}',
                      style: const TextStyle(color: Colors.green)),
                Text('Inicio: ${_formatDate(userRoutine.startedAt)}'),
                Text('Finalizada: ${_formatDate(userRoutine.completedAt)}'),
              ],
              if (userRoutine.completedAt == null) ...[
                Builder(
                  builder: (context) {
                    print('Pasos de la rutina: \\${userRoutine.steps.length}');
                    print(
                        'Pasos: \\${userRoutine.steps.map((s) => s.isDone).toList()}');
                    return const SizedBox.shrink();
                  },
                ),
                const Text('Progreso de la rutina:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildProgressBar(userRoutine),
                ...userRoutine.steps.map((step) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        step.isDone
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: step.isDone ? successColor : Colors.grey,
                      ),
                      title: Text(step.exerciseName ?? ''),
                      subtitle: Text(
                          'Sets: ${step.actualSets ?? '-'}, Reps: ${step.actualReps ?? '-'}'),
                      trailing: step.isDone
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () async {
                                final routineProvider =
                                    Provider.of<RoutineProvider>(context,
                                        listen: false);
                                final success =
                                    await routineProvider.completeStep(
                                  CompleteStepRequest(
                                    stepId: step.stepId ?? 0,
                                    actualSets: step.actualSets ?? 0,
                                    actualReps: step.actualReps ?? 0,
                                    actualDurationSeconds:
                                        step.actualDurationSeconds ?? 0,
                                    notes: step.notes,
                                  ),
                                );
                                if (success) {
                                  await routineProvider.loadMyRoutine(
                                      userRoutine.userRoutineId ?? 0);
                                  final refreshed =
                                      routineProvider.currentUserRoutine;
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('¡Paso completado!'),
                                        backgroundColor: Colors.green),
                                  );
                                  if (refreshed != null) {
                                    _showUserRoutineDialog(context, refreshed);
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            routineProvider.errorMessage ??
                                                'Error completando paso'),
                                        backgroundColor: Colors.red),
                                  );
                                }
                              },
                            ),
                    )),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: userRoutine.steps.every((s) => s.isDone)
                      ? () async {
                          final routineProvider = Provider.of<RoutineProvider>(
                              context,
                              listen: false);
                          final success = await routineProvider
                              .completeRoutine(userRoutine.userRoutineId ?? 0);
                          if (success) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('¡Rutina completada!'),
                                  backgroundColor: Colors.green),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(routineProvider.errorMessage ??
                                      'Error completando rutina'),
                                  backgroundColor: Colors.red),
                            );
                          }
                        }
                      : null,
                  child: const Text('Completar rutina'),
                ),
              ],
              if (userRoutine.completedAt != null) const SizedBox(height: 12),
              if (userRoutine.completedAt != null)
                const Text('¡Felicidades por completar la rutina!',
                    style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          if (userRoutine.completedAt == null)
            TextButton(
              onPressed: () async {
                final routineProvider =
                    Provider.of<RoutineProvider>(context, listen: false);
                await routineProvider
                    .loadMyRoutine(userRoutine.userRoutineId ?? 0);
                final refreshed = routineProvider.currentUserRoutine;
                Navigator.pop(context);
                if (refreshed != null) {
                  _showUserRoutineDialog(context, refreshed);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rutina recargada desde el servidor'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(routineProvider.errorMessage ??
                          'Error recargando rutina'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Recargar'),
            ),
        ],
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
                  'assets/logoGymBrot.png',
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
            Navigator.pushNamed(context, '/home');
          }),
          _buildDrawerItem(Icons.fitness_center, 'Mis Rutinas', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/routines');
          }),
          _buildDrawerItem(Icons.emoji_events, 'Logros', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/achievements');
          }),
          _buildDrawerItem(Icons.flag, 'Desafíos', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/challenges');
          }),
          _buildDrawerItem(Icons.card_giftcard, 'Recompensas', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/rewards');
          }),
          _buildDrawerItem(Icons.person, 'Perfil', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/profile');
          }),
          const Divider(),
          _buildDrawerItem(Icons.logout, 'Cerrar Sesión', () async {
            Navigator.pop(context);
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            await authProvider.logout();
          }),
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

  IconData _muscleGroupIcon(MuscleGroup group) {
    switch (group) {
      case MuscleGroup.pecho:
        return Icons.fitness_center;
      case MuscleGroup.espalda:
        return Icons.accessibility_new;
      case MuscleGroup.hombros:
        return Icons.pan_tool_alt;
      case MuscleGroup.brazos:
        return Icons.sports_mma;
      case MuscleGroup.piernas:
        return Icons.directions_run;
      case MuscleGroup.abdominales:
        return Icons.sports_gymnastics;
      case MuscleGroup.cardio:
        return Icons.favorite;
      case MuscleGroup.flexibilidad:
        return Icons.self_improvement;
      case MuscleGroup.fullBody:
        return Icons.all_inclusive;
      default:
        return Icons.fitness_center;
    }
  }
}
