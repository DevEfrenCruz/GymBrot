import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/auth_models.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  UserDto? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  UserDto? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  bool get hasCompletedOnboarding =>
      _currentUser?.hasCompletedOnboarding ?? false;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _setLoading(true);
    try {
      final user = await ApiService.instance.getProfile();
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        _errorMessage = null;
      } else {
        _isAuthenticated = false;
        _currentUser = null;
      }
    } catch (e) {
      _isAuthenticated = false;
      _currentUser = null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<bool> register(RegisterRequest request) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await ApiService.instance.register(request);
      if (success) {
        _setError(null);
        return true;
      } else {
        _setError('Error en el registro. Verifica tus datos.');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(LoginRequest request,
      {void Function(String?)? onError}) async {
    _setLoading(true);
    _setError(null);

    try {
      final token = await ApiService.instance.login(request);
      print('[AuthProvider] Token recibido: $token');
      if (token != null) {
        // Obtener el perfil del usuario después del login
        final user = await ApiService.instance.getProfile();
        print('[AuthProvider] Usuario recibido: $user');
        if (user != null) {
          _currentUser = user;
          _isAuthenticated = true;
          _setError(null);
          print('[AuthProvider] Login exitoso, usuario autenticado');
          notifyListeners();
          return true;
        } else {
          _setError('Error obteniendo perfil de usuario (¿token válido?)');
          print(
              '[AuthProvider] Error: No se pudo obtener el perfil del usuario');
          if (onError != null) onError(_errorMessage);
          notifyListeners();
          return false;
        }
      } else {
        _setError('Credenciales inválidas');
        print('[AuthProvider] Error: Credenciales inválidas');
        if (onError != null) onError(_errorMessage);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      print('[AuthProvider] Error de conexión: $e');
      if (onError != null) onError(_errorMessage);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(UserDto user) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await ApiService.instance.updateProfile(user);
      if (success) {
        _currentUser = user;
        _setError(null);
        return true;
      } else {
        _setError('Error actualizando perfil');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> changePassword(ChangePasswordRequest request) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await ApiService.instance.changePassword(request);
      if (success) {
        _setError(null);
        return true;
      } else {
        _setError('Error cambiando contraseña');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> forgotPassword(ForgotPasswordRequest request) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await ApiService.instance.forgotPassword(request);
      if (success) {
        _setError(null);
        return true;
      } else {
        _setError('Error enviando email de recuperación');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      await ApiService.instance.logout();
    } catch (e) {
      print('Error en logout: $e');
    } finally {
      _currentUser = null;
      _isAuthenticated = false;
      _setError(null);
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> refreshUser() async {
    if (_isAuthenticated) {
      try {
        final user = await ApiService.instance.getProfile();
        if (user != null) {
          _currentUser = user;
          notifyListeners();
        }
      } catch (e) {
        print('Error refrescando usuario: $e');
      }
    }
  }

  void clearError() {
    _setError(null);
  }

  Future<bool> completeProfile(CompleteProfileRequest request) async {
    _setLoading(true);
    _setError(null);
    try {
      final success = await ApiService.instance.completeProfile(request);
      if (success) {
        // Refrescar el usuario para obtener el perfil completo
        await refreshUser();
        _setError(null);
        return true;
      } else {
        _setError('Error completando perfil');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
