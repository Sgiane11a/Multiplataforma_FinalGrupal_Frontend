import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🔄 Probando conexión con la API...');

  try {
    // Test de conectividad básica
    final response = await http
        .get(
          Uri.parse(
            'https://multiplataforma-finalgrupal.onrender.com/api/libros',
          ),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(Duration(seconds: 10));

    print('✅ Respuesta de la API recibida');
    print('📊 Status Code: ${response.statusCode}');
    print('📝 Headers: ${response.headers}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Datos decodificados exitosamente');
      print('📚 Respuesta: $data');

      if (data['success'] == true) {
        print('🎉 API funcionando correctamente!');
        print('📖 Libros encontrados: ${data['data']?.length ?? 0}');
      } else {
        print('⚠️  API responde pero success = false');
      }
    } else {
      print('❌ Error HTTP: ${response.statusCode}');
      print('📝 Body: ${response.body}');
    }
  } catch (e) {
    print('❌ Error de conexión: $e');
    print('🔧 Verifica tu conexión a internet y la URL de la API');
  }
}
