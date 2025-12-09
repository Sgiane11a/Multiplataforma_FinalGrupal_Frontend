class Libro {
  final String id;
  final String titulo;
  final String autorId;
  final String editorialId;
  final int anoPublicacion;
  final String isbn;
  final int paginas;
  final String genero;
  final String descripcion;
  final double precio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? autorNombre;
  final String? editorialNombre;

  Libro({
    required this.id,
    required this.titulo,
    required this.autorId,
    required this.editorialId,
    required this.anoPublicacion,
    required this.isbn,
    required this.paginas,
    required this.genero,
    required this.descripcion,
    required this.precio,
    required this.createdAt,
    required this.updatedAt,
    this.autorNombre,
    this.editorialNombre,
  });

  factory Libro.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing libro desde JSON:');
    print('  - Raw JSON: $json');

    // Manejar autor - puede ser ID string o objeto poblado
    String autorId = '';
    String? autorNombre;
    if (json['autor'] != null) {
      print(
        '  - Autor raw: ${json['autor']} (tipo: ${json['autor'].runtimeType})',
      );
      if (json['autor'] is String) {
        autorId = json['autor'];
      } else if (json['autor'] is Map) {
        autorId = json['autor']['_id'] ?? json['autor']['id'] ?? '';
        autorNombre =
            json['autor']['nombre'] != null && json['autor']['apellido'] != null
            ? '${json['autor']['nombre']} ${json['autor']['apellido']}'
            : null;
      }
    }
    print('  - Autor ID final: "$autorId"');

    // Manejar editorial - puede ser ID string o objeto poblado
    String editorialId = '';
    String? editorialNombre;
    if (json['editorial'] != null) {
      print(
        '  - Editorial raw: ${json['editorial']} (tipo: ${json['editorial'].runtimeType})',
      );
      if (json['editorial'] is String) {
        editorialId = json['editorial'];
      } else if (json['editorial'] is Map) {
        editorialId = json['editorial']['_id'] ?? json['editorial']['id'] ?? '';
        editorialNombre = json['editorial']['nombre'];
      }
    }
    print('  - Editorial ID final: "$editorialId"');

    return Libro(
      id: json['id'] ?? json['_id'] ?? '',
      titulo: json['titulo'] ?? '',
      autorId: autorId,
      editorialId: editorialId,
      anoPublicacion: json['fechaPublicacion'] ?? json['anoPublicacion'] ?? 0,
      isbn: json['isbn'] ?? '',
      paginas: json['numeroPaginas'] ?? json['paginas'] ?? 0,
      genero: json['genero'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: (json['precio'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      autorNombre: autorNombre ?? json['autorNombre'],
      editorialNombre: editorialNombre ?? json['editorialNombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'autor': autorId,
      'editorial': editorialId,
      'fechaPublicacion': anoPublicacion,
      'isbn': isbn,
      'numeroPaginas': paginas,
      'genero': genero,
      'descripcion': descripcion,
      'precio': precio,
    };
  }
}
