import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/libro_provider.dart';
import 'providers/autor_provider.dart';
import 'providers/editorial_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LibroProvider()),
        ChangeNotifierProvider(create: (_) => AutorProvider()),
        ChangeNotifierProvider(create: (_) => EditorialProvider()),
      ],
      child: MaterialApp(
        title: 'Biblioteca Digital',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(0xFF2E7D32),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          cardTheme: const CardThemeData(
            elevation: 4,
            margin: EdgeInsets.all(8),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
