import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/autor_provider.dart';
import '../models/autor.dart';
import '../constants/app_colors.dart';
import '../widgets/autor_form.dart';

class AutoresScreen extends StatefulWidget {
  const AutoresScreen({super.key});

  @override
  State<AutoresScreen> createState() => _AutoresScreenState();
}

class _AutoresScreenState extends State<AutoresScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AutorProvider>().loadAutores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AutorProvider>(
        builder: (context, autorProvider, child) {
          if (autorProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            );
          }

          if (autorProvider.error.isNotEmpty) {
            return Center(child: Text('Error: ${autorProvider.error}'));
          }

          if (autorProvider.autores.isEmpty) {
            return const Center(child: Text('No hay autores registrados'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: autorProvider.autores.length,
            itemBuilder: (context, index) {
              final autor = autorProvider.autores[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF2E7D32),
                    child: Text(
                      autor.nombre[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(autor.nombreCompleto),
                  subtitle: Text('${autor.nacionalidad}\n${autor.biografia}'),
                  isThreeLine: true,
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () => _abrirFormulario(autor: autor),
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => _confirmarEliminar(autor),
                        child: const Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Eliminar'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _abrirFormulario({Autor? autor}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AutorForm(autor: autor)),
    );
  }

  void _confirmarEliminar(Autor autor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar a ${autor.nombreCompleto}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AutorProvider>().deleteAutor(autor.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
