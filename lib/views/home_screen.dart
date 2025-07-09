import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/auth_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/routine_provider.dart';
import '../models/progress_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final progressProvider =
        Provider.of<ProgressProvider>(context, listen: false);
    final routineProvider =
        Provider.of<RoutineProvider>(context, listen: false);

    await Future.wait([
      progressProvider.loadTodayStats(),
      progressProvider.loadWeeklyStats(),
      progressProvider.loadCurrentXp(),
      progressProvider.loadMyChallenges(),
      routineProvider.loadMyRoutines(),
    ]);
  }

  // Paleta de colores constante
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
        title: const Text('GYMBROT',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: textColor, fontSize: 20)),
        backgroundColor: primaryColor,
      ),
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Container(
          color: backgroundColor,
          child: Consumer3<AuthProvider, ProgressProvider, RoutineProvider>(
            builder: (context, authProvider, progressProvider, routineProvider,
                child) {
              if (progressProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (progressProvider.errorMessage != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          progressProvider.errorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final user = authProvider.currentUser;
              final todayStats = progressProvider.todayStats;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildWelcomeCard(user?.nickname?.isNotEmpty == true
                        ? user!.nickname!
                        : user?.email ?? 'Usuario'),
                    const SizedBox(height: 20),
                    _buildProgressSection(todayStats, progressProvider),
                    const SizedBox(height: 20),
                    _buildWeeklyCaloriesCard(progressProvider),
                    const SizedBox(height: 20),
                    _buildWeeklyStepsCard(progressProvider),
                    const SizedBox(height: 20),
                    _buildChallengesCard(progressProvider),
                    const SizedBox(height: 20),
                    _buildXpCard(progressProvider),
                  ],
                ),
              );
            },
          ),
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
                Image.asset(
                  'assets/logoGymBrot.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
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
      title: Text(title, style: const TextStyle(color: primaryTextColor)),
      onTap: onTap,
    );
  }

  Widget _buildWelcomeCard(String? userName) {
    return Card(
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
            Text('¡Bienvenido de nuevo, $userName!',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor)),
            const SizedBox(height: 8),
            const Text(
                'Aquí está tu resumen de progreso y los consejos de hoy.',
                style: TextStyle(color: secondaryTextColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(
      DailyStatDto? todayStats, ProgressProvider progressProvider) {
    final caloriesIn = todayStats?.caloriesIn ?? 0;
    final caloriesOut = todayStats?.caloriesOut ?? 0;
    final steps = todayStats?.steps ?? 0;
    final routinesCompleted = todayStats?.routinesCompleted ?? 0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: _buildProgressCard(
              'Calorías Consumidas',
              '$caloriesIn kcal',
              'Meta: 2200 kcal',
              Icons.local_fire_department,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 160,
            child: _buildProgressCard(
              'Calorías Quemadas',
              '$caloriesOut kcal',
              'Meta: 500 kcal',
              Icons.fitness_center,
              Colors.green,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 160,
            child: _buildProgressCard(
              'Pasos Hoy',
              '$steps',
              'Meta: 10000 pasos',
              Icons.directions_walk,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 160,
            child: _buildProgressCard(
              'Rutinas Completadas',
              '$routinesCompleted',
              'Meta: 1 rutina',
              Icons.check_circle,
              Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(String title, String value, String subtitle,
      IconData icon, Color iconColor) {
    return SizedBox(
      width: 180,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style:
                      const TextStyle(fontSize: 14, color: secondaryTextColor)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(value,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(subtitle,
                  style:
                      const TextStyle(fontSize: 12, color: secondaryTextColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyCaloriesCard(ProgressProvider progressProvider) {
    final weeklyStats = progressProvider.weeklyStats;
    final caloriesData = _prepareWeeklyCaloriesData(weeklyStats);

    return Card(
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
              'Resumen Semanal de Calorías',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Calorías consumidas vs. quemadas esta semana.',
              style: TextStyle(color: secondaryTextColor),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.all(8),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Lun',
                            'Mar',
                            'Mié',
                            'Jue',
                            'Vie',
                            'Sáb',
                            'Dom'
                          ];
                          if (value.toInt() >= 0 &&
                              value.toInt() < days.length) {
                            return Text(days[value.toInt()]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: caloriesData['consumed'] ?? [],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: caloriesData['burned'] ?? [],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue, 'Consumidas'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.green, 'Quemadas'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyStepsCard(ProgressProvider progressProvider) {
    final weeklyStats = progressProvider.weeklyStats;
    final stepsData = _prepareWeeklyStepsData(weeklyStats);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pasos Semanales',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu control de pasos diarios esta semana.',
              style: TextStyle(color: secondaryTextColor),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.all(8),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: stepsData,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];
                          if (value.toInt() >= 0 &&
                              value.toInt() < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(days[value.toInt()]),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengesCard(ProgressProvider progressProvider) {
    final activeChallenges = progressProvider.getActiveChallenges();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Desafíos Activos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            if (activeChallenges.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No tienes desafíos activos en este momento.',
                  style: TextStyle(color: secondaryTextColor),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...activeChallenges.map((challenge) =>
                  _buildChallengeItem(challenge, progressProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeItem(
      UserChallengeDto challenge, ProgressProvider progressProvider) {
    final challengeInfo = challenge.challenge;
    if (challengeInfo == null) return const SizedBox.shrink();

    final progress = progressProvider.getChallengeProgress(challenge);
    final percentage = (progress * 100).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            challengeInfo.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${challenge.progress} / ${challengeInfo.goalValue} ${challengeInfo.goalType}',
            style: const TextStyle(
              fontSize: 12,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(successColor),
          ),
          const SizedBox(height: 4),
          Text(
            '$percentage% completado',
            style: const TextStyle(
              fontSize: 12,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpCard(ProgressProvider progressProvider) {
    final currentXp = progressProvider.currentXp;
    final weeklyXp = progressProvider.getWeeklyXpEarned();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Experiencia (XP)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildXpStat('XP Total', currentXp.toString(), Icons.star),
                _buildXpStat(
                    'XP Esta Semana', weeklyXp.toString(), Icons.trending_up),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildXpStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: successColor, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: primaryTextColor)),
      ],
    );
  }

  Map<String, List<FlSpot>> _prepareWeeklyCaloriesData(
      List<DailyStatDto> weeklyStats) {
    final consumed = <FlSpot>[];
    final burned = <FlSpot>[];

    for (int i = 0; i < weeklyStats.length; i++) {
      consumed.add(FlSpot(i.toDouble(), weeklyStats[i].caloriesIn.toDouble()));
      burned.add(FlSpot(i.toDouble(), weeklyStats[i].caloriesOut.toDouble()));
    }

    return {
      'consumed': consumed,
      'burned': burned,
    };
  }

  List<BarChartGroupData> _prepareWeeklyStepsData(
      List<DailyStatDto> weeklyStats) {
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < weeklyStats.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: weeklyStats[i].steps.toDouble(),
              color: Colors.blue,
              width: 20,
            ),
          ],
        ),
      );
    }

    return barGroups;
  }
}
