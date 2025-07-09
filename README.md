# GymBrot - Tu Entrenador Personal

GymBrot es una aplicación móvil desarrollada en Flutter que te ayuda a mantener un estilo de vida saludable a través de rutinas de ejercicio personalizadas, seguimiento de progreso, sistema de logros y gamificación.

## Características Principales

### 🏋️ Gestión de Rutinas

- Rutinas pre-diseñadas para diferentes niveles (Principiante, Intermedio, Avanzado)
- Seguimiento paso a paso de ejercicios
- Ejercicios organizados por grupos musculares
- Progreso detallado de cada rutina

### 🎯 Sistema de Gamificación

- **Sistema de XP**: Gana puntos de experiencia completando rutinas y desafíos
- **Niveles**: Sube de nivel según tu XP acumulado
- **Logros**: Desbloquea insignias por hitos específicos
- **Desafíos Semanales**: Participa en retos periódicos
- **Recompensas**: Canjea XP por recompensas virtuales y físicas

### 📊 Seguimiento de Progreso

- Estadísticas diarias de calorías (consumidas vs quemadas)
- Control de pasos diarios
- Gráficas semanales de progreso
- Historial de rutinas completadas

### 🤖 Entrenador IA Básico

- Ajuste automático de volumen de entrenamiento
- Sugerencias de descanso basadas en el progreso
- Cálculo automático de calorías y XP

## Configuración del Proyecto

### Prerrequisitos

- Flutter SDK (versión 3.6.0 o superior)
- Dart SDK
- Android Studio / VS Code
- Backend API de GymBrot ejecutándose en `http://localhost:5004`

### Instalación

1. **Clonar el repositorio**

   ```bash
   git clone <url-del-repositorio>
   cd GymBrot
   ```

2. **Instalar dependencias**

   ```bash
   flutter pub get
   ```

3. **Configurar la API**

   - Asegúrate de que el backend esté ejecutándose en `http://localhost:5004`
   - Si necesitas cambiar la URL de la API, modifica `lib/services/api_service.dart`

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## Estructura del Proyecto

```
lib/
├── models/                 # Modelos de datos
│   ├── auth_models.dart    # Modelos para autenticación
│   ├── user_model.dart     # Modelo de usuario
│   ├── routine_models.dart # Modelos de rutinas y ejercicios
│   └── progress_models.dart # Modelos de progreso y estadísticas
├── providers/              # Providers de estado
│   ├── auth_provider.dart  # Manejo de autenticación
│   ├── routine_provider.dart # Manejo de rutinas
│   └── progress_provider.dart # Manejo de progreso
├── services/               # Servicios
│   └── api_service.dart    # Servicio de comunicación con la API
├── views/                  # Pantallas de la aplicación
│   ├── home_screen.dart    # Pantalla principal
│   ├── login.dart          # Pantalla de login
│   ├── register.dart       # Pantalla de registro
│   ├── routine_screen.dart # Pantalla de rutinas
│   └── onboarding.dart     # Pantalla de bienvenida
└── main.dart               # Punto de entrada de la aplicación
```

## API Endpoints Utilizados

### Autenticación

- `POST /api/Auth/register` - Registro de usuario
- `POST /api/Auth/login` - Inicio de sesión
- `GET /api/Auth/profile` - Obtener perfil del usuario
- `PUT /api/Auth/profile` - Actualizar perfil

### Rutinas

- `GET /api/Routines` - Obtener todas las rutinas
- `GET /api/Routines/{id}` - Obtener rutina específica
- `POST /api/Routines/start` - Iniciar rutina
- `POST /api/Routines/complete/{userRoutineId}` - Completar rutina
- `POST /api/Routines/steps/{stepId}/complete` - Completar paso de rutina

### Progreso

- `GET /api/Progress/xp/current` - XP actual
- `GET /api/Progress/xp/history` - Historial de XP
- `GET /api/Progress/achievements` - Logros del usuario
- `GET /api/Progress/challenges/my` - Desafíos del usuario
- `GET /api/Progress/stats/daily/{date}` - Estadísticas diarias
- `PUT /api/Progress/stats/daily` - Actualizar estadísticas

## Flujo de Usuario

1. **Registro/Login**: El usuario se registra o inicia sesión
2. **Pantalla Principal**: Muestra resumen de progreso, estadísticas y desafíos activos
3. **Rutinas**: El usuario puede ver, iniciar y completar rutinas de ejercicio
4. **Progreso**: Seguimiento automático de XP, logros y estadísticas
5. **Gamificación**: Sistema de recompensas y desafíos para mantener la motivación

## Características Técnicas

### Estado de la Aplicación

- **Provider Pattern**: Gestión de estado usando Provider
- **Separación de Responsabilidades**: Providers específicos para cada dominio
- **Persistencia**: Tokens de autenticación guardados en SharedPreferences

### Comunicación con API

- **HTTP Client**: Uso de package `http` para comunicación REST
- **Manejo de Errores**: Gestión centralizada de errores de red
- **Autenticación**: Tokens JWT para autenticación

### UI/UX

- **Material Design**: Interfaz siguiendo las guías de Material Design
- **Responsive**: Adaptable a diferentes tamaños de pantalla
- **Gráficas**: Visualización de datos usando `fl_chart`

## Desarrollo

### Agregar Nuevas Funcionalidades

1. **Crear modelos** en `lib/models/`
2. **Implementar endpoints** en `lib/services/api_service.dart`
3. **Crear provider** en `lib/providers/` si es necesario
4. **Desarrollar UI** en `lib/views/`

### Testing

```bash
# Ejecutar tests unitarios
flutter test

# Ejecutar tests de widgets
flutter test test/widget_test.dart
```

## Despliegue

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## Contacto

- **Desarrollador**: [Tu Nombre]
- **Email**: [tu-email@ejemplo.com]
- **Proyecto**: [https://github.com/tu-usuario/GymBrot](https://github.com/tu-usuario/GymBrot)

---

**Nota**: Esta aplicación requiere que el backend de GymBrot esté ejecutándose para funcionar correctamente. Asegúrate de tener el backend configurado y ejecutándose antes de usar la aplicación móvil.
