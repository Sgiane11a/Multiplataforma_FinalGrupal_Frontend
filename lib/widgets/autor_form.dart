import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/autor.dart';
import '../providers/autor_provider.dart';
import '../constants/app_colors.dart';

class AutorForm extends StatefulWidget {
  final Autor? autor;

  const AutorForm({super.key, this.autor});

  @override
  State<AutorForm> createState() => _AutorFormState();
}

class _AutorFormState extends State<AutorForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _nacionalidadController = TextEditingController();
  final _biografiaController = TextEditingController();
  DateTime? _fechaNacimiento;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.autor != null) {
      _nombreController.text = widget.autor!.nombre;
      _apellidoController.text = widget.autor!.apellido;
      _nacionalidadController.text = widget.autor!.nacionalidad;
      _biografiaController.text = widget.autor!.biografia;
      _fechaNacimiento = widget.autor!.fechaNacimiento;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.autor == null ? 'Nuevo Autor' : 'Editar Autor'),
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
              controller: _apellidoController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Ingrese el apellido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nacionalidadController,
              decoration: const InputDecoration(
                labelText: 'Nacionalidad',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Ingrese la nacionalidad' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _fechaNacimiento ?? DateTime(1950),
                  firstDate: DateTime(1800),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _fechaNacimiento = date;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _fechaNacimiento != null
                      ? DateFormat('dd/MM/yyyy').format(_fechaNacimiento!)
                      : 'Seleccionar fecha',
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _biografiaController,
              decoration: const InputDecoration(
                labelText: 'Biografía',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) =>
                  value?.isEmpty == true ? 'Ingrese la biografía' : null,
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
                  : Text(widget.autor == null ? 'Crear' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate() || _fechaNacimiento == null) {
      return;
    }

    setState(() => _isLoading = true);

    final autor = Autor(
      id: widget.autor?.id ?? '',
      nombre: _nombreController.text,
      apellido: _apellidoController.text,
      fechaNacimiento: _fechaNacimiento!,
      nacionalidad: _nacionalidadController.text,
      biografia: _biografiaController.text,
      nombreCompleto: '${_nombreController.text} ${_apellidoController.text}',
      createdAt: widget.autor?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = context.read<AutorProvider>();
    bool success;

    if (widget.autor == null) {
      success = await provider.createAutor(autor);
    } else {
      success = await provider.updateAutor(widget.autor!.id, autor);
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
