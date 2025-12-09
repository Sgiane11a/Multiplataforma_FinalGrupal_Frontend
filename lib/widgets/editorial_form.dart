import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/editorial.dart';
import '../providers/editorial_provider.dart';
import '../constants/app_colors.dart';

class EditorialForm extends StatefulWidget {
  final Editorial? editorial;

  const EditorialForm({super.key, this.editorial});

  @override
  State<EditorialForm> createState() => _EditorialFormState();
}

class _EditorialFormState extends State<EditorialForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _paisController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _anoFundacionController = TextEditingController();
  final _direccionController = TextEditingController();
  final _contactoController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.editorial != null) {
      print('📝 Inicializando formulario editorial con datos:');
      print('  - ID: ${widget.editorial!.id}');
      print('  - Nombre: "${widget.editorial!.nombre}"');
      print('  - País: "${widget.editorial!.pais}"');
      print('  - Ciudad: "${widget.editorial!.ciudad}"');
      print('  - Año: ${widget.editorial!.anoFundacion}');
      print('  - Dirección: "${widget.editorial!.direccion}"');
      print('  - Contacto: "${widget.editorial!.contacto}"');

      _nombreController.text = widget.editorial!.nombre;
      _paisController.text = widget.editorial!.pais;
      _ciudadController.text = widget.editorial!.ciudad;
      _anoFundacionController.text = widget.editorial!.anoFundacion.toString();
      _direccionController.text = widget.editorial!.direccion;
      _contactoController.text = widget.editorial!.contacto;

      print('📝 Controllers después de asignar:');
      print('  - Dirección controller: "${_direccionController.text}"');
      print('  - Contacto controller: "${_contactoController.text}"');
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _paisController.dispose();
    _ciudadController.dispose();
    _anoFundacionController.dispose();
    _direccionController.dispose();
    _contactoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editorial == null ? 'Nueva Editorial' : 'Editar Editorial',
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Ingrese el nombre' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _paisController,
              decoration: const InputDecoration(
                labelText: 'País',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Ingrese el país' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ciudadController,
              decoration: const InputDecoration(
                labelText: 'Ciudad *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Ingrese la ciudad' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _anoFundacionController,
              decoration: const InputDecoration(
                labelText: 'Año de Fundación',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty == true) return 'Ingrese el año';
                if (int.tryParse(value!) == null) {
                  return 'Ingrese un año válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _direccionController,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Ingrese la dirección' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactoController,
              decoration: const InputDecoration(
                labelText: 'Contacto',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Ingrese el contacto' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _guardar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(widget.editorial == null ? 'Crear' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final editorial = Editorial(
      id: widget.editorial?.id ?? '',
      nombre: _nombreController.text,
      pais: _paisController.text,
      ciudad: _ciudadController.text,
      anoFundacion: int.parse(_anoFundacionController.text),
      direccion: _direccionController.text,
      contacto: _contactoController.text,
      createdAt: widget.editorial?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = context.read<EditorialProvider>();
    bool success;

    if (widget.editorial == null) {
      success = await provider.createEditorial(editorial);
    } else {
      success = await provider.updateEditorial(widget.editorial!.id, editorial);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Éxito' : 'Error: ${provider.error}'),
          backgroundColor: success ? AppColors.primary : Colors.red,
        ),
      );
    }
  }
}
