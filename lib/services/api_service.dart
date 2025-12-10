import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/libro.dart';
import '../models/autor.dart';
import '../models/editorial.dart';

class ApiService {
  static const String baseUrl =
      'https://multiplataforma-finalgrupal.onrender.com/api';

  // Timeout más largo para servicios como Render que pueden estar "dormidos"
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Headers comunes para todas las requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Método auxiliar para hacer requests con manejo de errores
  static Future<http.Response> _makeRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    print('🔄 Haciendo request a: $uri');

    http.Response response;

    try {
      switch (method) {
        case 'GET':
          response = await http
              .get(uri, headers: headers)
              .timeout(timeoutDuration);
          break;
        case 'POST':
          response = await http
              .post(uri, headers: headers, body: json.encode(body))
              .timeout(timeoutDuration);
          break;
        case 'PUT':
          response = await http
              .put(uri, headers: headers, body: json.encode(body))
              .timeout(timeoutDuration);
          break;
        case 'DELETE':
          response = await http
              .delete(uri, headers: headers)
              .timeout(timeoutDuration);
          break;
        default:
          throw Exception('Método HTTP no soportado: $method');
      }

      print('✅ Response recibido: ${response.statusCode}');
      return response;
    } catch (e) {
      print('❌ Error en request: $e');
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Timeout: La API está tardando mucho en responder. Puede estar inicializándose.',
        );
      }
      throw Exception('Error de conexión: $e');
    }
  }

  // Libros
  static Future<List<Libro>> getLibros() async {
    try {
      final response = await _makeRequest('/libros');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((libro) => Libro.fromJson(libro))
              .toList();
        }
      }

      throw Exception('Error al cargar libros: ${response.statusCode}');
    } catch (e) {
      print('❌ Error en getLibros: $e');
      // Devolver lista vacía en caso de error para que la app no crashee
      return [];
    }
  }

  static Future<Libro> getLibro(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/libros/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Libro.fromJson(data['data']);
        }
      }
      throw Exception('Error al cargar el libro');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Libro> createLibro(Libro libro) async {
    try {
      print('📤 Enviando datos de libro: ${json.encode(libro.toJson())}');

      // Intentar hasta 2 veces en caso de error 500 del servidor
      for (int attempt = 1; attempt <= 2; attempt++) {
        print('🔄 Intento $attempt de creación de libro');

        final response = await _makeRequest(
          '/libros',
          method: 'POST',
          body: libro.toJson(),
        );

        print('📥 Response status: ${response.statusCode}');
        print('📥 Response body: ${response.body}');

        if (response.statusCode == 201 || response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success'] == true && data['data'] != null) {
            return Libro.fromJson(data['data']);
          }
        }

        // Si es error 500 y no es el último intento, esperar y reintentar
        if (response.statusCode == 500 && attempt < 2) {
          print('⚠️ Error 500 del servidor, reintentando en 2 segundos...');
          await Future.delayed(Duration(seconds: 2));
          continue;
        }

        // Para otros errores o último intento, lanzar excepción
        if (response.statusCode == 500) {
          throw Exception(
            'Error interno del servidor (500). El backend tiene un problema temporal. Intente nuevamente en unos minutos.',
          );
        }

        throw Exception(
          'Error al crear el libro: ${response.statusCode} - ${response.body}',
        );
      }

      // Fallback (esto nunca debería ejecutarse)
      throw Exception('Error inesperado en la creación del libro');
    } catch (e) {
      print('❌ Error en createLibro: $e');
      rethrow;
    }
  }

  static Future<Libro> updateLibro(String id, Libro libro) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/libros/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(libro.toJson()),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Libro.fromJson(data['data']);
        }
      }
      throw Exception('Error al actualizar el libro');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<bool> deleteLibro(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/libros/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      throw Exception('Error al eliminar el libro');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Autores
  static Future<List<Autor>> getAutores() async {
    try {
      final response = await _makeRequest('/autores');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((autor) => Autor.fromJson(autor))
              .toList();
        }
      }

      print('❌ Error al cargar autores: ${response.statusCode}');
      return []; // Devolver lista vacía en lugar de excepción
    } catch (e) {
      print('❌ Error en getAutores: $e');
      // Devolver lista vacía en caso de error para que la app no crashee
      return [];
    }
  }

  static Future<Autor> getAutor(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/autores/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Autor.fromJson(data['data']);
        }
      }
      throw Exception('Error al cargar el autor');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Autor> createAutor(Autor autor) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/autores'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(autor.toJson()),
      );
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Autor.fromJson(data['data']);
        }
      }
      throw Exception('Error al crear el autor');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Autor> updateAutor(String id, Autor autor) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/autores/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(autor.toJson()),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Autor.fromJson(data['data']);
        }
      }
      throw Exception('Error al actualizar el autor');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<bool> deleteAutor(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/autores/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      throw Exception('Error al eliminar el autor');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Editoriales
  static Future<List<Editorial>> getEditoriales() async {
    try {
      final response = await _makeRequest('/editoriales');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('🏢 Raw editoriales response: $data');

        if (data['success'] == true && data['data'] != null) {
          final editoriales = (data['data'] as List).map((editorial) {
            print('🏢 Processing editorial: $editorial');
            return Editorial.fromJson(editorial);
          }).toList();

          print('🏢 Parsed ${editoriales.length} editoriales');
          return editoriales;
        }
      }

      print('❌ Error al cargar editoriales: ${response.statusCode}');
      return []; // Devolver lista vacía en lugar de excepción
    } catch (e) {
      print('❌ Error en getEditoriales: $e');
      // Devolver lista vacía en caso de error para que la app no crashee
      return [];
    }
  }

  static Future<Editorial> getEditorial(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/editoriales/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Editorial.fromJson(data['data']);
        }
      }
      throw Exception('Error al cargar la editorial');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Editorial> createEditorial(Editorial editorial) async {
    try {
      print(
        '📤 Enviando datos de editorial: ${json.encode(editorial.toJson())}',
      );

      final response = await _makeRequest(
        '/editoriales',
        method: 'POST',
        body: editorial.toJson(),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Editorial.fromJson(data['data']);
        }
      }

      throw Exception(
        'Error al crear la editorial: ${response.statusCode} - ${response.body}',
      );
    } catch (e) {
      print('❌ Error en createEditorial: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Editorial> updateEditorial(
    String id,
    Editorial editorial,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/editoriales/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(editorial.toJson()),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Editorial.fromJson(data['data']);
        }
      }
      throw Exception('Error al actualizar la editorial');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<bool> deleteEditorial(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/editoriales/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      throw Exception('Error al eliminar la editorial');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método de testing para verificar conectividad
  static Future<bool> testConnection() async {
    try {
      final response = await _makeRequest('/libros');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Test de conexión falló: $e');
      return false;
    }
  }
}
