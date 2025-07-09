import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/auth_models.dart';

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
                child: Text('Descubre tu rutina',
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

class OnboardingFormScreen extends StatefulWidget {
  final String email;
  OnboardingFormScreen({required this.email});

  @override
  _OnboardingFormScreenState createState() => _OnboardingFormScreenState();
}

class _OnboardingFormScreenState extends State<OnboardingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? firstName, lastName, nickname, gender, fitnessGoal, experienceLevel;
  DateTime? dateOfBirth;
  double? weight, height;
  bool _loading = false;
  String? _error;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> fitnessGoals = [
    'Lose Weight',
    'Build Muscle',
    'Stay Fit',
    'Improve Endurance',
  ];
  final List<String> experienceLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
      _error = null;
    });
    final req = CompleteProfileRequest(
      email: widget.email,
      firstName: firstName,
      lastName: lastName,
      nickname: nickname,
      dateOfBirth: dateOfBirth,
      gender: gender,
      weight: weight,
      height: height,
      fitnessGoal: fitnessGoal,
      experienceLevel: experienceLevel,
    );
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.completeProfile(req);
    setState(() {
      _loading = false;
    });
    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _error = auth.errorMessage ?? 'Error completando perfil';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completa tu perfil')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onSaved: (v) => firstName = v,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'El nombre es requerido'
                    : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellido'),
                onSaved: (v) => lastName = v,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'El apellido es requerido'
                    : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apodo'),
                onSaved: (v) => nickname = v,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'El apodo es requerido'
                    : null,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration:
                          InputDecoration(labelText: 'Fecha de nacimiento'),
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null)
                            setState(() => dateOfBirth = picked);
                        },
                        child: Text(dateOfBirth == null
                            ? 'Selecciona fecha'
                            : '${dateOfBirth!.toLocal()}'.split(' ')[0]),
                      ),
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Género'),
                items: genderOptions
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => gender = v),
                validator: (v) => v == null ? 'Selecciona un género' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => weight = double.tryParse(v ?? ''),
                validator: (v) {
                  final val = double.tryParse(v ?? '');
                  if (val == null || val <= 0) return 'Ingresa un peso válido';
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => height = double.tryParse(v ?? ''),
                validator: (v) {
                  final val = double.tryParse(v ?? '');
                  if (val == null || val <= 0)
                    return 'Ingresa una altura válida';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Objetivo'),
                items: fitnessGoals
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => fitnessGoal = v),
                validator: (v) => v == null ? 'Selecciona un objetivo' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Nivel de experiencia'),
                items: experienceLevels
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => experienceLevel = v),
                validator: (v) => v == null ? 'Selecciona un nivel' : null,
              ),
              SizedBox(height: 20),
              if (_error != null) ...[
                Text(_error!, style: TextStyle(color: Colors.red)),
                SizedBox(height: 10),
              ],
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text('Completar perfil'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
