import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/libro.dart';
import '../providers/libro_provider.dart';
import '../providers/autor_provider.dart';
import '../providers/editorial_provider.dart';
import '../constants/app_colors.dart';

class LibroForm extends StatefulWidget {
  final Libro? libro;

  const LibroForm({super.key, this.libro});

  @override
  State<LibroForm> createState() => _LibroFormState();
}

class _LibroFormState extends State<LibroForm> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _isbnController = TextEditingController();
  final _paginasController = TextEditingController();
  final _anoPublicacionController = TextEditingController();
  final _precioController = TextEditingController();
  final _descripcionController = TextEditingController();

  String? _selectedAutorId;
  String? _selectedEditorialId;
  String? _selectedGenero;
  bool _isLoading = false;

  // Lista de géneros válidos según la API
  final List<String> _generos = [
    'Ficción',
    'No ficción',
    'Fantasía',
    'Ciencia ficción',
    'Romance',
    'Misterio',
    'Biografía',
    'Historia',
    'Autoayuda',
    'Religión',
    'Infantil',
    'Juvenil',
    'Técnico',
    'Académico',
    'Poesía',
  ];

  @override
  void initState() {
    super.initState();
    // Programar la carga de datos para después del build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() async {
    if (!mounted) return;
    final autorProvider = Provider.of<AutorProvider>(context, listen: false);
    final editorialProvider = Provider.of<EditorialProvider>(
      context,
      listen: false,
    );
    await autorProvider.loadAutores();
    await editorialProvider.loadEditoriales();

    print('📋 Autores disponibles:');
    for (var autor in autorProvider.autores) {
      print('  - ${autor.id}: ${autor.nombre} ${autor.apellido}');
    }

    print('📋 Editoriales disponibles:');
    for (var editorial in editorialProvider.editoriales) {
      print('  - ${editorial.id}: ${editorial.nombre}');
    }

    // Inicializar con los datos del libro DESPUÉS de cargar las listas
    // Y dar un pequeño delay para asegurar que todo esté listo
    if (widget.libro != null) {
      await Future.delayed(Duration(milliseconds: 100));
      if (mounted) {
        _initializeWithLibro();
      }
    }
  }

  void _initializeWithLibro() {
    final libro = widget.libro!;
    _tituloController.text = libro.titulo;
    _isbnController.text = libro.isbn;
    _paginasController.text = libro.paginas.toString();
    _anoPublicacionController.text = libro.anoPublicacion.toString();
    _precioController.text = libro.precio.toString();
    _descripcionController.text = libro.descripcion;

    // Asegurar que los IDs se configuran correctamente
    setState(() {
      _selectedAutorId = libro.autorId.isNotEmpty ? libro.autorId : null;
      _selectedEditorialId = libro.editorialId.isNotEmpty
          ? libro.editorialId
          : null;
      _selectedGenero = libro.genero.isNotEmpty ? libro.genero : null;
    });

    print('🔍 Inicializando libro con:');
    print('  - Autor ID: "${libro.autorId}"');
    print('  - Editorial ID: "${libro.editorialId}"');
    print('  - Género: "${libro.genero}"');

    print('✅ Estado actualizado:');
    print('  - _selectedAutorId: "$_selectedAutorId"');
    print('  - _selectedEditorialId: "$_selectedEditorialId"');
    print('  - _selectedGenero: "$_selectedGenero"');
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _isbnController.dispose();
    _paginasController.dispose();
    _anoPublicacionController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarLibro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final libro = Libro(
        id: widget.libro?.id ?? '',
        titulo: _tituloController.text.trim(),
        autorId: _selectedAutorId!,
        editorialId: _selectedEditorialId!,
        anoPublicacion: int.parse(_anoPublicacionController.text),
        isbn: _isbnController.text.trim(),
        paginas: int.parse(_paginasController.text),
        genero: _selectedGenero!,
        descripcion: _descripcionController.text.trim(),
        precio: double.parse(_precioController.text),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (widget.libro == null) {
        success = await Provider.of<LibroProvider>(
          context,
          listen: false,
        ).createLibro(libro);
      } else {
        success = await Provider.of<LibroProvider>(
          context,
          listen: false,
        ).updateLibro(widget.libro!.id, libro);
      }

      if (success && mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.libro == null
                  ? 'Libro creado exitosamente'
                  : 'Libro actualizado exitosamente',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      } else if (mounted) {
        // Si no fue exitoso, obtener el error del provider
        final libroProvider = Provider.of<LibroProvider>(
          context,
          listen: false,
        );
        String errorMessage = libroProvider.error.isNotEmpty
            ? libroProvider.error
            : 'Error desconocido al ${widget.libro == null ? 'crear' : 'actualizar'} el libro';

        // Personalizar mensajes para errores específicos
        if (errorMessage.contains('Error interno del servidor')) {
          errorMessage =
              '⚠️ El servidor está experimentando problemas temporales. Por favor, intente nuevamente en unos minutos.';
        } else if (errorMessage.contains('500')) {
          errorMessage =
              '🔧 Problema técnico en el servidor. Intente más tarde o contacte al administrador.';
        } else if (errorMessage.contains('400')) {
          errorMessage =
              '📝 Hay un error en los datos enviados. Verifique todos los campos.';
        } else if (errorMessage.contains('Timeout')) {
          errorMessage =
              '⏱️ La conexión está tardando mucho. Verifique su conexión a internet.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red[700],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Cerrar',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.libro == null ? 'Nuevo Libro' : 'Editar Libro'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título *',
                  prefixIcon: Icon(Icons.book),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Consumer<AutorProvider>(
                builder: (context, autorProvider, child) {
                  if (autorProvider.isLoading) {
                    return const CircularProgressIndicator();
                  }

                  // Validar que el valor seleccionado esté en la lista
                  final autorIds = autorProvider.autores
                      .map((a) => a.id)
                      .toList();

                  // Buscar el valor correcto más robustamente
                  String? selectedAutor;
                  if (_selectedAutorId != null &&
                      _selectedAutorId!.isNotEmpty) {
                    // Buscar coincidencia exacta primero
                    if (autorIds.contains(_selectedAutorId)) {
                      selectedAutor = _selectedAutorId;
                    } else {
                      // Buscar por coincidencia parcial (por si hay diferencias en formato)
                      for (var id in autorIds) {
                        if (id.endsWith(_selectedAutorId!) ||
                            _selectedAutorId!.endsWith(id)) {
                          selectedAutor = id;
                          // Actualizar el valor seleccionado con el ID correcto
                          _selectedAutorId = id;
                          break;
                        }
                      }
                    }
                  }

                  print('🔍 Debug Autor:');
                  print('  - _selectedAutorId: "$_selectedAutorId"');
                  print('  - autorIds disponibles: $autorIds');
                  print('  - selectedAutor final: "$selectedAutor"');
                  print(
                    '  - ¿Está en la lista? ${autorIds.contains(_selectedAutorId)}',
                  );

                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Autor *',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    value: selectedAutor,
                    items: autorProvider.autores.map((autor) {
                      return DropdownMenuItem(
                        value: autor.id,
                        child: Text('${autor.nombre} ${autor.apellido}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAutorId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleccione un autor';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              Consumer<EditorialProvider>(
                builder: (context, editorialProvider, child) {
                  if (editorialProvider.isLoading) {
                    return const CircularProgressIndicator();
                  }

                  // Validar que el valor seleccionado esté en la lista
                  final editorialIds = editorialProvider.editoriales
                      .map((e) => e.id)
                      .toList();

                  // Buscar el valor correcto más robustamente
                  String? selectedEditorial;
                  if (_selectedEditorialId != null &&
                      _selectedEditorialId!.isNotEmpty) {
                    // Buscar coincidencia exacta primero
                    if (editorialIds.contains(_selectedEditorialId)) {
                      selectedEditorial = _selectedEditorialId;
                    } else {
                      // Buscar por coincidencia parcial (por si hay diferencias en formato)
                      for (var id in editorialIds) {
                        if (id.endsWith(_selectedEditorialId!) ||
                            _selectedEditorialId!.endsWith(id)) {
                          selectedEditorial = id;
                          // Actualizar el valor seleccionado con el ID correcto
                          _selectedEditorialId = id;
                          break;
                        }
                      }
                    }
                  }

                  print('🔍 Debug Editorial:');
                  print('  - _selectedEditorialId: "$_selectedEditorialId"');
                  print('  - editorialIds disponibles: $editorialIds');
                  print('  - selectedEditorial final: "$selectedEditorial"');
                  print(
                    '  - ¿Está en la lista? ${editorialIds.contains(_selectedEditorialId)}',
                  );

                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Editorial *',
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(),
                    ),
                    value: selectedEditorial,
                    items: editorialProvider.editoriales.map((editorial) {
                      return DropdownMenuItem(
                        value: editorial.id,
                        child: Text(editorial.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEditorialId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleccione una editorial';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _anoPublicacionController,
                decoration: const InputDecoration(
                  labelText: 'Año de Publicación *',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El año de publicación es obligatorio';
                  }
                  final ano = int.tryParse(value);
                  if (ano == null || ano < 1000 || ano > DateTime.now().year) {
                    return 'Ingrese un año válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(
                  labelText: 'ISBN *',
                  prefixIcon: Icon(Icons.code),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El ISBN es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _paginasController,
                decoration: const InputDecoration(
                  labelText: 'Número de Páginas *',
                  prefixIcon: Icon(Icons.pages),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El número de páginas es obligatorio';
                  }
                  final paginas = int.tryParse(value);
                  if (paginas == null || paginas <= 0) {
                    return 'Ingrese un número válido de páginas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(
                  labelText: 'Precio *',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El precio es obligatorio';
                  }
                  final precio = double.tryParse(value);
                  if (precio == null || precio <= 0) {
                    return 'Ingrese un precio válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Género *',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                value: _selectedGenero,
                items: _generos.map((genero) {
                  return DropdownMenuItem(value: genero, child: Text(genero));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGenero = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seleccione un género';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción *',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _guardarLibro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
