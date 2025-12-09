import 'package:flutter/material.dart';
import '../models/autor.dart';
import '../services/api_service.dart';

class AutorProvider with ChangeNotifier {
  List<Autor> _autores = [];
  bool _isLoading = false;
  String _error = '';

  List<Autor> get autores => _autores;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadAutores() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _autores = await ApiService.getAutores();
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
