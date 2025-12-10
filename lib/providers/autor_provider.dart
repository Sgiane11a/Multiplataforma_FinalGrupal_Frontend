import 'package:flutter/material.dart';
import '../models/autor.dart';
import '../services/api_service.dart';

class AutorProvider with ChangeNotifier {
  List<Autor> _autores = [];
  bool _isLoading = false;
  String _error = '';
  DateTime? _lastLoadTime;

  // Caché válido por 5 minutos
  static const Duration cacheValidDuration = Duration(minutes: 5);

  List<Autor> get autores => _autores;
  bool get isLoading => _isLoading;
  String get error => _error;

  bool get _isCacheValid {
    if (_lastLoadTime == null || _autores.isEmpty) return false;
    return DateTime.now().difference(_lastLoadTime!) < cacheValidDuration;
  }

  Future<void> loadAutores({bool forceRefresh = false}) async {
    // Si el caché es válido y no se fuerza refresh, no hacer nada
    if (_isCacheValid && !forceRefresh) {
      print('📦 Usando autores desde caché');
      return;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      print('🔄 Cargando autores desde API');
      _autores = await ApiService.getAutores();
      _lastLoadTime = DateTime.now();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createAutor(Autor autor) async {
    try {
      final nuevoAutor = await ApiService.createAutor(autor);
      _autores.add(nuevoAutor);
      _lastLoadTime = DateTime.now(); // Actualizar tiempo de caché
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAutor(String id, Autor autor) async {
    try {
      final autorActualizado = await ApiService.updateAutor(id, autor);
      final index = _autores.indexWhere((a) => a.id == id);
      if (index != -1) {
        _autores[index] = autorActualizado;
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

  Future<bool> deleteAutor(String id) async {
    try {
      final success = await ApiService.deleteAutor(id);
      if (success) {
        _autores.removeWhere((autor) => autor.id == id);
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
