import 'package:flutter/material.dart';
import '../models/editorial.dart';
import '../services/api_service.dart';

class EditorialProvider with ChangeNotifier {
  List<Editorial> _editoriales = [];
  bool _isLoading = false;
  String _error = '';
  DateTime? _lastLoadTime;

  // Caché válido por 5 minutos
  static const Duration cacheValidDuration = Duration(minutes: 5);

  List<Editorial> get editoriales => _editoriales;
  bool get isLoading => _isLoading;
  String get error => _error;

  bool get _isCacheValid {
    if (_lastLoadTime == null || _editoriales.isEmpty) return false;
    return DateTime.now().difference(_lastLoadTime!) < cacheValidDuration;
  }

  Future<void> loadEditoriales({bool forceRefresh = false}) async {
    // Si el caché es válido y no se fuerza refresh, no hacer nada
    if (_isCacheValid && !forceRefresh) {
      print('📦 Usando editoriales desde caché');
      return;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      print('🔄 Cargando editoriales desde API');
      _editoriales = await ApiService.getEditoriales();
      _lastLoadTime = DateTime.now();
      _error = ''; // Limpiar error si fue exitoso
    } catch (e) {
      _error = e.toString();
      debugPrint('Error en EditorialProvider: $_error');
      // Mantener lista vacía en caso de error
      _editoriales = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createEditorial(Editorial editorial) async {
    try {
      final nuevaEditorial = await ApiService.createEditorial(editorial);
      _editoriales.add(nuevaEditorial);
      _lastLoadTime = DateTime.now(); // Actualizar tiempo de caché
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEditorial(String id, Editorial editorial) async {
    try {
      final editorialActualizada = await ApiService.updateEditorial(
        id,
        editorial,
      );
      final index = _editoriales.indexWhere((e) => e.id == id);
      if (index != -1) {
        _editoriales[index] = editorialActualizada;
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

  Future<bool> deleteEditorial(String id) async {
    try {
      final success = await ApiService.deleteEditorial(id);
      if (success) {
        _editoriales.removeWhere((editorial) => editorial.id == id);
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
