import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Container(
            color: Colors.blue,
            child: Center(
                child: Text('Bienvenido',
                    style: TextStyle(fontSize: 24, color: Colors.white))),
          ),
          Container(
            color: Colors.green,
            child: Center(
                child: Text('Explora la app',
                    style: TextStyle(fontSize: 24, color: Colors.white))),
          ),
          Container(
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¡Comienza ahora!',
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('Empezar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
