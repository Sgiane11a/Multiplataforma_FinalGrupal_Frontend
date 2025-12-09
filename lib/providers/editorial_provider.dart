import 'package:flutter/material.dart';
import '../models/editorial.dart';
import '../services/api_service.dart';

class EditorialProvider with ChangeNotifier {
  List<Editorial> _editoriales = [];
  bool _isLoading = false;
  String _error = '';

  List<Editorial> get editoriales => _editoriales;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadEditoriales() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _editoriales = await ApiService.getEditoriales();
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
