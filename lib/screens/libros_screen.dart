import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/libro.dart';
import '../providers/libro_provider.dart';
import '../providers/autor_provider.dart';
import '../providers/editorial_provider.dart';
import '../widgets/libro_card.dart';
import '../widgets/libro_form.dart';

class LibrosScreen extends StatefulWidget {
  const LibrosScreen({super.key});

  @override
  State<LibrosScreen> createState() => _LibrosScreenState();
}

class _LibrosScreenState extends State<LibrosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibroProvider>().loadLibros();
      context.read<AutorProvider>().loadAutores();
      context.read<EditorialProvider>().loadEditoriales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LibroProvider>(
        builder: (context, libroProvider, child) {
          if (libroProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            );
          }

          if (libroProvider.error.isNotEmpty) {
            return Center(child: Text('Error: ${libroProvider.error}'));
          }

          if (libroProvider.libros.isEmpty) {
            return const Center(child: Text('No hay libros registrados'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: libroProvider.libros.length,
            itemBuilder: (context, index) {
              final libro = libroProvider.libros[index];
              return LibroCard(
                libro: libro,
                onEdit: () => _mostrarFormularioLibro(context, libro: libro),
                onDelete: () => _confirmarEliminacion(context, libro),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormularioLibro(context),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Libro'),
      ),
    );
  }

  void _mostrarFormularioLibro(BuildContext context, {Libro? libro}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: LibroForm(libro: libro),
      ),
    );
  }

  Future<void> _confirmarEliminacion(BuildContext context, Libro libro) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Está seguro que desea eliminar el libro "${libro.titulo}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final success = await context.read<LibroProvider>().deleteLibro(libro.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Libro eliminado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al eliminar el libro: ${context.read<LibroProvider>().error}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
