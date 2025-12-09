import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/editorial_provider.dart';
import '../models/editorial.dart';
import '../constants/app_colors.dart';
import '../widgets/editorial_form.dart';

class EditorialesScreen extends StatefulWidget {
  const EditorialesScreen({super.key});

  @override
  State<EditorialesScreen> createState() => _EditorialesScreenState();
}

class _EditorialesScreenState extends State<EditorialesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditorialProvider>().loadEditoriales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EditorialProvider>(
        builder: (context, editorialProvider, child) {
          if (editorialProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            );
          }

          if (editorialProvider.error.isNotEmpty) {
            return Center(child: Text('Error: ${editorialProvider.error}'));
          }

          if (editorialProvider.editoriales.isEmpty) {
            return const Center(child: Text('No hay editoriales registradas'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: editorialProvider.editoriales.length,
            itemBuilder: (context, index) {
              final editorial = editorialProvider.editoriales[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF2E7D32),
                    child: Icon(Icons.business, color: Colors.white),
                  ),
                  title: Text(editorial.nombre),
                  subtitle: Text(
                    '${editorial.ciudad}, ${editorial.pais} (${editorial.anoFundacion})\n${editorial.direccion}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () => _abrirFormulario(editorial: editorial),
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => _confirmarEliminar(editorial),
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

  void _abrirFormulario({Editorial? editorial}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorialForm(editorial: editorial),
      ),
    );
  }

  void _confirmarEliminar(Editorial editorial) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar ${editorial.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<EditorialProvider>().deleteEditorial(editorial.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
