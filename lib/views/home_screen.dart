import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/data_controller.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Colores basados en la tabla proporcionada
    const primaryColor = Color(0xFF007BFF); // Azul eléctrico - Navegación, botones principales
    const secondaryColor = Color(0xFF00E676); // Verde neón - Botones secundarios, acentos
    const successColor = Color(0xFFFFD700); // Dorado - Trofeos, recompensas
    const backgroundColor = Color(0xFF0A0A0A); // Negro profundo - Fondo general
    const textColor = Color(0xFFFFFFFF); // Blanco - Texto principal
    const secondaryTextColor = Color(0xFFB0BEC5); // Gris claro - Etiquetas, subtítulos

    return ChangeNotifierProvider(
      create: (_) => DataController()..fetchData(), // Carga datos al iniciar
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('GymBrot', style: TextStyle(color: textColor)),
          actions: [
            IconButton(
              icon: Icon(Icons.menu, color: textColor),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: primaryColor),
                child: Text(
                  'Menú',
                  style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: successColor), // Dorado para gamificación
                title: Text('Inicio', style: TextStyle(color: secondaryTextColor)),
                onTap: () {
                  Navigator.pop(context); // Cierra el Drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.fitness_center, color: successColor),
                title: Text('Entrenamientos', style: TextStyle(color: secondaryTextColor)),
                onTap: () {
                  Navigator.pop(context);
                  // Lógica para navegar a Entrenamientos
                },
              ),
              ListTile(
                leading: Icon(Icons.restaurant, color: successColor),
                title: Text('Nutrición', style: TextStyle(color: secondaryTextColor)),
                onTap: () {
                  Navigator.pop(context);
                  // Lógica para navegar a Nutrición
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: successColor),
                title: Text('Configuración', style: TextStyle(color: secondaryTextColor)),
                onTap: () {
                  Navigator.pop(context);
                  // Lógica para navegar a Configuración
                },
              ),
            ],
          ),
        ),
        body: Container(
          color: backgroundColor, // Fondo negro profundo
          child: Column(
            children: [
              Expanded(
                child: Consumer<DataController>(
                  builder: (context, controller, child) {
                    if (controller.errorMessage != null) {
                      return Center(
                        child: Text(
                          controller.errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    }
                    if (controller.data.isEmpty) {
                      return Center(child: CircularProgressIndicator(color: primaryColor));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount: controller.data.length,
                      itemBuilder: (context, index) {
                        final item = controller.data[index];
                        return Card(
                          elevation: 4.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: secondaryTextColor), // Borde gris claro
                          ),
                          child: ListTile(
                            leading: Icon(Icons.circle, color: successColor, size: 10), // Dorado para gamificación
                            title: Text(item.title, style: TextStyle(color: textColor, fontSize: 18)),
                            subtitle: Text(item.description, style: TextStyle(color: secondaryTextColor)),
                            trailing: Icon(Icons.emoji_events, color: successColor), // Ícono de trofeo corregido
                            onTap: () {
                              // Lógica al tocar un item (por ejemplo, navegar a detalles)
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}