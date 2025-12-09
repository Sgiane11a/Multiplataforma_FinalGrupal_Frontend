import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../services/api_service.dart';

class LibroProvider with ChangeNotifier {
  List<Libro> _libros = [];
  bool _isLoading = false;
  String _error = '';

  List<Libro> get libros => _libros;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadLibros() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _libros = await ApiService.getLibros();
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
