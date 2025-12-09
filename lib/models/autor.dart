class Autor {
  final String id;
  final String nombre;
  final String apellido;
  final DateTime fechaNacimiento;
  final String nacionalidad;
  final String biografia;
  final String nombreCompleto;
  final DateTime createdAt;
  final DateTime updatedAt;

  Autor({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.nacionalidad,
    required this.biografia,
    required this.nombreCompleto,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      id: json['id'] ?? json['_id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
      nacionalidad: json['nacionalidad'],
      biografia: json['biografia'],
      nombreCompleto: json['nombreCompleto'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'nacionalidad': nacionalidad,
      'biografia': biografia,
    };
  }
}
