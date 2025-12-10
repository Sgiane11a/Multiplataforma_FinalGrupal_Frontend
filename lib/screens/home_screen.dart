import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/libro_provider.dart';
import '../providers/autor_provider.dart';
import '../providers/editorial_provider.dart';
import 'libros_screen.dart';
import 'autores_screen.dart';
import 'editoriales_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const LibrosScreen(),
    const AutoresScreen(),
    const EditorialesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Biblioteca Digital',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              // Forzar refresh de todos los datos
              context.read<LibroProvider>().loadLibros(forceRefresh: true);
              context.read<AutorProvider>().loadAutores(forceRefresh: true);
              context.read<EditorialProvider>().loadEditoriales(
                forceRefresh: true,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Actualizando datos...'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color(0xFF2E7D32),
                ),
              );
            },
            tooltip: 'Actualizar datos',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1F8E9), Color(0xFFE8F5E8)],
          ),
        ),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2E7D32),
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              activeIcon: Icon(Icons.book, size: 28),
              label: 'Libros',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person, size: 28),
              label: 'Autores',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              activeIcon: Icon(Icons.business, size: 28),
              label: 'Editoriales',
            ),
          ],
        ),
      ),
    );
  }
}
