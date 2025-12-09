class Editorial {
  final String id;
  final String nombre;
  final String pais;
  final String ciudad;
  final int anoFundacion;
  final String direccion;
  final String contacto;
  final DateTime createdAt;
  final DateTime updatedAt;

  Editorial({
    required this.id,
    required this.nombre,
    required this.pais,
    required this.ciudad,
    required this.anoFundacion,
    required this.direccion,
    required this.contacto,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Editorial.fromJson(Map<String, dynamic> json) {
    print('🏢 Parsing editorial desde JSON:');
    print('  - Raw JSON: $json');
    print('  - Direccion: "${json['direccion']}"');
    print('  - Contacto: "${json['contacto']}"');

    return Editorial(
      id: json['id'] ?? json['_id'] ?? '',
      nombre: json['nombre'] ?? '',
      pais: json['pais'] ?? '',
      ciudad: json['ciudad'] ?? '',
      anoFundacion: json['anoFundacion'] ?? 0,
      direccion: json['direccion'] ?? '',
      contacto: json['contacto'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'pais': pais,
      'ciudad': ciudad,
      'anoFundacion': anoFundacion,
      'direccion': direccion,
      'contacto': contacto,
    };
  }
}
