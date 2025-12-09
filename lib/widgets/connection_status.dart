import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../constants/app_colors.dart';

class ConnectionStatus extends StatefulWidget {
  const ConnectionStatus({super.key});

  @override
  State<ConnectionStatus> createState() => _ConnectionStatusState();
}

class _ConnectionStatusState extends State<ConnectionStatus> {
  bool _isConnected = false;
  bool _isLoading = true;
  String _status = 'Verificando conexión...';

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Verificando conexión con API...';
    });

    try {
      final isConnected = await ApiService.testConnection();
      setState(() {
        _isConnected = isConnected;
        _isLoading = false;
        _status = isConnected
            ? 'Conectado a la API ✅'
            : 'Sin conexión a la API ❌';
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _isLoading = false;
        _status = 'Error de conexión: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isConnected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isConnected ? AppColors.primary : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (_isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Icon(
              _isConnected ? Icons.wifi : Icons.wifi_off,
              color: _isConnected ? AppColors.primary : Colors.orange,
              size: 16,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _status,
              style: TextStyle(
                color: _isConnected ? AppColors.primary : Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: _checkConnection,
            icon: const Icon(Icons.refresh, size: 16),
            tooltip: 'Verificar conexión',
          ),
        ],
      ),
    );
  }
}
