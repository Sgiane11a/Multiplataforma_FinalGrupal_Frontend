# Ejemplos de Uso - Biblioteca Digital Frontend

## Funcionalidades Implementadas

### 1. Crear Editorial

**Pasos:**
1. Abrir la aplicación en el navegador
2. Ir a la sección "Editoriales" 
3. Presionar el botón "+" (flotante)
4. Completar el formulario con:
   - **Nombre**: Ejemplo: "Penguin Random House"
   - **Dirección**: Ejemplo: "1745 Broadway, New York" 
   - **Teléfono**: Ejemplo: "+1-212-782-9000"
   - **Email**: Ejemplo: "contacto@penguinrandomhouse.com"
   - **Ciudad**: Ejemplo: "New York" ⚠️ **Campo obligatorio**

**Resultado esperado:**
- ✅ Mensaje de éxito: "Editorial creada exitosamente"
- ✅ La editorial aparece en la lista

### 2. Crear Libro

**Prerequisitos:**
- Al menos un autor debe existir en el sistema
- Al menos una editorial debe existir en el sistema

**Pasos:**
1. Ir a la sección "Libros"
2. Presionar el botón "+" (flotante)  
3. Completar el formulario con:
   - **Título**: Ejemplo: "Cien Años de Soledad"
   - **Autor**: Seleccionar de la lista desplegable
   - **Editorial**: Seleccionar de la lista desplegable
   - **Año de Publicación**: Ejemplo: "1967"
   - **ISBN**: Ejemplo: "978-84-376-0494-7"
   - **Número de Páginas**: Ejemplo: "471"
   - **Precio**: Ejemplo: "25.99"
   - **Género**: Seleccionar de: Ficción, No ficción, Fantasía, Ciencia ficción, Romance, Misterio, Biografía, Historia, Autoayuda, Religión, Infantil, Juvenil, Técnico, Académico, Poesía
   - **Descripción**: Ejemplo: "Novela del escritor colombiano Gabriel García Márquez"

**Resultado esperado:**
- ✅ Mensaje de éxito: "Libro creado exitosamente"  
- ✅ El libro aparece en la lista con toda la información

## Géneros Válidos para Libros

Los géneros disponibles son:
- Ficción
- No ficción  
- Fantasía
- Ciencia ficción
- Romance
- Misterio
- Biografía
- Historia
- Autoayuda
- Religión
- Infantil
- Juvenil
- Técnico
- Académico
- Poesía

## Validaciones Implementadas

### Editorial:
- ✅ Todos los campos son obligatorios
- ✅ Email debe tener formato válido
- ✅ Teléfono debe tener formato válido

### Libro:
- ✅ Título, autor, editorial, año, ISBN, páginas, precio, género y descripción son obligatorios
- ✅ Año debe estar entre 1000 y el año actual
- ✅ Páginas debe ser un número positivo
- ✅ Precio debe ser un número positivo con decimales
- ✅ ISBN debe tener el formato correcto

## Ejemplo de Datos para Pruebas

### Editorial de Prueba:
```
Nombre: Editorial Planeta
Dirección: Av. Diagonal 662-664, Barcelona
Teléfono: +34-93-496-7000
Email: info@planeta.es
Ciudad: Barcelona
```

### Libro de Prueba:
```
Título: Don Quijote de la Mancha
Autor: (Seleccionar Miguel de Cervantes si existe)
Editorial: (Seleccionar la creada anteriormente)
Año de Publicación: 1605
ISBN: 978-84-376-0001-1
Páginas: 863
Precio: 29.95
Género: Ficción
Descripción: Obra maestra de la literatura española que narra las aventuras de Alonso Quijano.
```

## Troubleshooting

### Error: "El precio es obligatorio"
- ✅ **Solución**: Asegurarse de completar el campo precio con un número válido

### Error: "La ciudad es obligatoria" (Editorial)  
- ✅ **Solución**: El campo ciudad fue agregado como obligatorio, completar con cualquier ciudad

### Error: "`Realismo Mágico` is not a valid enum value"
- ✅ **Solución**: Usar solo los géneros de la lista válida proporcionada

### Error: "Seleccione un autor/editorial"
- ✅ **Solución**: Crear al menos un autor y una editorial antes de crear libros

## Estado de la Implementación

- ✅ **Editoriales CRUD**: Completamente funcional
- ✅ **Libros CRUD**: Formulario corregido y validaciones implementadas
- ✅ **Autores CRUD**: Funcional (implementado previamente)
- ✅ **Validación de API**: Campos corregidos según respuestas del servidor
- ✅ **Interfaz responsive**: Material Design 3 con tema verde personalizado