import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../services/api_service.dart';

class LibroProvider with ChangeNotifier {
  List<Libro> _libros = [];
  bool _isLoading = false;
  String _error = '';
  DateTime? _lastLoadTime;

  // Caché válido por 5 minutos
  static const Duration cacheValidDuration = Duration(minutes: 5);

  List<Libro> get libros => _libros;
  bool get isLoading => _isLoading;
  String get error => _error;

  bool get _isCacheValid {
    if (_lastLoadTime == null || _libros.isEmpty) return false;
    return DateTime.now().difference(_lastLoadTime!) < cacheValidDuration;
  }

  Future<void> loadLibros({bool forceRefresh = false}) async {
    // Si el caché es válido y no se fuerza refresh, no hacer nada
    if (_isCacheValid && !forceRefresh) {
      print('📦 Usando libros desde caché');
      return;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      print('🔄 Cargando libros desde API');
      _libros = await ApiService.getLibros();
      _lastLoadTime = DateTime.now();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createLibro(Libro libro) async {
    try {
      final nuevoLibro = await ApiService.createLibro(libro);
      _libros.add(nuevoLibro);
      _lastLoadTime = DateTime.now(); // Actualizar tiempo de caché
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLibro(String id, Libro libro) async {
    try {
      final libroActualizado = await ApiService.updateLibro(id, libro);
      final index = _libros.indexWhere((l) => l.id == id);
      if (index != -1) {
        _libros[index] = libroActualizado;
        _lastLoadTime = DateTime.now(); // Actualizar tiempo de caché
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteLibro(String id) async {
    try {
      final success = await ApiService.deleteLibro(id);
      if (success) {
        _libros.removeWhere((libro) => libro.id == id);
        _lastLoadTime = DateTime.now(); // Actualizar tiempo de caché
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}
