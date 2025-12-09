# frontend

A new Flutter project.

## Getting Started

# 📚 Biblioteca Digital - Frontend

Una aplicación Flutter moderna y elegante para gestionar una biblioteca digital, que consume la API de [multiplataforma-finalgrupal.onrender.com](https://multiplataforma-finalgrupal.onrender.com/).

## ✨ Características

### 🎨 Diseño Moderno
- **Interfaz limpia y minimalista** con esquema de colores verde natura
- **Gradientes suaves** y sombras para una experiencia visual atractiva
- **Iconografía consistente** usando Material Design Icons
- **Responsive design** que se adapta a diferentes tamaños de pantalla

### 📖 Funcionalidades Principales

#### 📚 Gestión de Libros
- **Visualización en tarjetas** con información detallada
- **Vista de detalles** con modal emergente
- **Formularios de creación y edición** (en desarrollo)
- **Grid layout responsivo** para mejor visualización

#### 👨‍🏫 Gestión de Autores
- **Lista de autores** con información biografica
- **Visualización de nacionalidad** y datos personales
- **Avatares personalizados** con iniciales

#### 🏢 Gestión de Editoriales
- **Lista de editoriales** con información corporativa
- **Datos de contacto** y ubicación geográfica

### 🔌 Integración con API
- **Consumo completo de la API REST** de biblioteca
- **Manejo de estados de carga** y errores
- **Actualización en tiempo real** de datos
- **Manejo de errores de red** con mensajes informativos

## 🏗️ Arquitectura

### 📁 Estructura del Proyecto
```
lib/
├── main.dart                    # Punto de entrada principal
├── models/                      # Modelos de datos
│   ├── autor.dart
│   ├── libro.dart
│   └── editorial.dart
├── providers/                   # Gestión de estado con Provider
│   ├── autor_provider.dart
│   ├── libro_provider.dart
│   └── editorial_provider.dart
├── services/                    # Servicios de API
│   └── api_service.dart
├── screens/                     # Pantallas principales
│   ├── home_screen.dart
│   ├── libros_screen.dart
│   ├── autores_screen.dart
│   └── editoriales_screen.dart
├── widgets/                     # Componentes reutilizables
│   ├── libro_card.dart
│   └── libro_form.dart
└── utils/                       # Utilidades y constantes
    └── app_colors.dart
```

### 🎯 Patrones Utilizados
- **Provider Pattern** para gestión de estado
- **Repository Pattern** para abstracción de datos
- **Model-View-Provider (MVP)** como arquitectura base
- **Atomic Design** para componentes reutilizables

## 🚀 Tecnologías

### 📱 Framework y Lenguajes
- **Flutter 3.24+** - Framework de desarrollo multiplataforma
- **Dart** - Lenguaje de programación optimizado para UI

### 📦 Dependencias Principales
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.2.0              # Cliente HTTP para API calls
  provider: ^6.1.1          # Gestión de estado reactivo  
  intl: ^0.19.0             # Formateo de fechas y localización
```

### 🎨 Diseño y UI
- **Material Design 3** como sistema de diseño base
- **Custom Color Scheme** con verde como color primario
- **Gradientes lineales** para efectos visuales
- **Typography scale** consistente

## 📊 API Integration

### 🌐 Endpoints Consumidos
La aplicación consume los siguientes endpoints de la API:

#### 📚 Libros (`/api/libros`)
- `GET /` - Obtener todos los libros
- `POST /` - Crear nuevo libro
- `GET /:id` - Obtener libro específico
- `PUT /:id` - Actualizar libro
- `DELETE /:id` - Eliminar libro

#### 👨‍🏫 Autores (`/api/autores`)
- `GET /` - Obtener todos los autores
- `POST /` - Crear nuevo autor
- `GET /:id` - Obtener autor específico
- `PUT /:id` - Actualizar autor
- `DELETE /:id` - Eliminar autor

#### 🏢 Editoriales (`/api/editoriales`)
- `GET /` - Obtener todas las editoriales
- `POST /` - Crear nueva editorial
- `GET /:id` - Obtener editorial específica
- `PUT /:id` - Actualizar editorial
- `DELETE /:id` - Eliminar editorial

### 🔄 Manejo de Estados
- **Loading States** con indicadores personalizados
- **Error Handling** con mensajes informativos
- **Empty States** con ilustraciones y acciones sugeridas
- **Refresh Capability** con pull-to-refresh

## 🎨 Diseño Visual

### 🎨 Paleta de Colores
```dart
// Colores principales
Primary Green: #2E7D32
Light Green: #4CAF50
Background Light: #F1F8E9
Background Lighter: #E8F5E8

// Colores de texto
Text Primary: #2E7D32
Text Secondary: #757575
Text Light: #9E9E9E

// Estados
Success: #4CAF50
Warning: #FF9800
Error: #E53935
```

### 📐 Espaciado y Layout
- **Grid System** con 2 columnas para libros
- **Padding consistente** de 16px
- **Border radius** de 12px para elementos redondeados
- **Elevation** sutil para profundidad visual

## 🚀 Cómo Ejecutar

### 📋 Prerrequisitos
- Flutter SDK 3.24 o superior
- Dart 3.0 o superior
- Chrome, Edge o dispositivo móvil para testing

### 🔧 Instalación
1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd frontend
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Verificar configuración**
   ```bash
   flutter doctor
   ```

4. **Ejecutar la aplicación**
   ```bash
   # Para web (Chrome)
   flutter run -d chrome
   
   # Para dispositivo móvil
   flutter run
   
   # Para Windows
   flutter run -d windows
   ```

## 🎯 Características Implementadas

### ✅ Completadas
- [x] Estructura base del proyecto Flutter
- [x] Integración con API REST
- [x] Modelos de datos para Libros, Autores y Editoriales
- [x] Providers para gestión de estado
- [x] Pantalla principal con navegación por tabs
- [x] Vista de libros con grid de tarjetas
- [x] Vista de autores con lista
- [x] Vista de editoriales
- [x] Diseño responsive y atractivo
- [x] Manejo de estados de carga y error
- [x] Paleta de colores personalizada

### 🚧 En Desarrollo
- [ ] Formularios completos de CRUD
- [ ] Validación de formularios
- [ ] Búsqueda y filtros
- [ ] Paginación de resultados
- [ ] Modo offline
- [ ] Autenticación de usuarios

### 💡 Futuras Mejoras
- [ ] Animaciones y micro-interacciones
- [ ] Modo oscuro
- [ ] Sincronización offline
- [ ] Notificaciones push
- [ ] Exportación de datos
- [ ] Estadísticas y analytics

## 🤝 Contribución

Para contribuir al proyecto:

1. Fork el repositorio
2. Crea una rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

---

**Desarrollado con ❤️ usando Flutter**
