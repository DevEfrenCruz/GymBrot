import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/data_controller.dart';
import '../models/data_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

            final List<DataModel> data =
                controller.data; // Uso explícito del getter
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildWelcomeCard(data[0].userName),
                  const SizedBox(height: 20),
                  _buildProgressSection(data[0]),
                  const SizedBox(height: 20),
                  _buildWeeklyCaloriesCard(),
                  const SizedBox(height: 20),
                  _buildWeeklyStepsCard(),
                ],
              ),
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
                Image.asset(
                  'assets/logoGymBrot.png', // Asegúrate de que el nombre coincida con pubspec.yaml
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
            Text('¡Bienvenido de nuevo, ${userName ?? 'Usuario'}!',
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

  Widget _buildProgressSection(DataModel userData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 160, // Ancho reducido
            child: _buildProgressCard(
              'Calorías Hoy',
              '${userData.todayCalories ?? 0} / ${userData.dailyCalorieGoal ?? 2200} kcal',
              '+200 respecto ayer',
              Icons.local_fire_department,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 160, // Mismo ancho reducido
            child: _buildProgressCard(
              'Pasos Hoy',
              '${userData.todaySteps ?? 0} / ${userData.dailyStepGoal ?? 10000}',
              'Meta: ${userData.dailyStepGoal ?? 10000} pasos',
              Icons.directions_walk,
              Colors.blue,
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

  Widget _buildWeeklyCaloriesCard() {
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
                          return Text(days[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    // Línea de calorías CONSUMIDAS (azul)
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1500),
                        FlSpot(1, 1800),
                        FlSpot(2, 2200),
                        FlSpot(3, 2100),
                        FlSpot(4, 1900),
                        FlSpot(5, 2300),
                        FlSpot(6, 2000),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Línea de calorías QUEMADAS (verde) - Datos simulados
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1200),
                        FlSpot(1, 1600),
                        FlSpot(2, 1900),
                        FlSpot(3, 1700),
                        FlSpot(4, 2100),
                        FlSpot(5, 1800),
                        FlSpot(6, 1500),
                      ],
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

  Widget _buildWeeklyStepsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pasos Semanales'),
            const SizedBox(height: 8),
            const Text(
              'Tu control de pasos...',
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.all(8),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: 7000, color: Colors.blue, width: 20)
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: 8500, color: Colors.blue, width: 20)
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(toY: 9200, color: Colors.blue, width: 20)
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(toY: 6500, color: Colors.blue, width: 20)
                    ]),
                    BarChartGroupData(x: 4, barRods: [
                      BarChartRodData(toY: 7800, color: Colors.blue, width: 20)
                    ]),
                    BarChartGroupData(x: 5, barRods: [
                      BarChartRodData(toY: 9500, color: Colors.blue, width: 20)
                    ]),
                    BarChartGroupData(x: 6, barRods: [
                      BarChartRodData(toY: 6000, color: Colors.blue, width: 20)
                    ]),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(days[value.toInt()]),
                          );
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
}
