# ReNotes - Notas de Investigación

Aplicación Flutter para Android que permite organizar trabajo de investigación en proyectos, escribir notas largas y clasificarlas con etiquetas personalizadas.

## Características

- **6 pantallas**: Proyectos, Notas del proyecto, Editor de nota, Detalle de nota, Etiquetas y Buscar
- **Navegación**: BottomNavigationBar con 3 destinos principales
- **Datos en memoria**: Sin servidor ni base de datos
- **Gestión dinámica de etiquetas**: Crear, renombrar, eliminar y reutilizar
- **Autocompletado de etiquetas**: Con coincidencia insensible a mayúsculas y acentos
- **Búsqueda global**: Por título o contenido con filtros por proyecto y etiquetas
- **Datos de prueba**: 3 proyectos, 15 notas y 8 etiquetas precargadas

## Requisitos

- Flutter SDK ^3.0.0
- Dart SDK ^3.0.0
- Android SDK

## Instalación

1. Clonar el repositorio:
```bash
git clone https://github.com/tu-usuario/renotes-flutter.git
cd renotes-flutter
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Ejecutar en emulador o dispositivo:
```bash
flutter run
```

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada y navegación principal
├── models/
│   ├── project.dart          # Modelo de proyecto
│   ├── note.dart             # Modelo de nota
│   └── tag.dart              # Modelo de etiqueta
├── state/
│   └── app_state.dart        # Estado global con ChangeNotifier
└── screens/
    ├── projects_screen.dart      # RF1: Lista de proyectos
    ├── project_notes_screen.dart # RF2: Notas de un proyecto
    ├── note_editor_screen.dart   # RF3: Editor de nota
    ├── note_detail_screen.dart   # RF4: Detalle de nota
    ├── tags_screen.dart          # RF5: Gestión de etiquetas
    └── search_screen.dart        # RF6: Búsqueda global
```

## Datos de Precarga

La aplicación incluye datos de prueba que cumplen con los requisitos:
- 3 proyectos de investigación
- 15 notas (5 por proyecto)
- 8 etiquetas
- Notas con más de 600 caracteres
- 1 nota sin etiquetas
- 1 etiqueta sin notas

## Criterios de Aceptación

- [x] La app inicia sin errores en Android
- [x] No hay overflow visible en las pantallas principales
- [x] Se puede crear, editar y eliminar proyectos, notas y etiquetas
- [x] El autocompletado sugiere etiquetas existentes
- [x] No se pueden crear etiquetas duplicadas
- [x] La búsqueda y los filtros devuelven resultados correctos
- [x] Se usa un solo método de navegación (Navigator.push)
- [x] No se usan manejadores de estado externos al SDK

## Autor

Ing. Roilán Rodríguez Castillo

## Asignatura

Programación para Dispositivos Móviles
