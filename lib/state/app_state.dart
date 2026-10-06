import 'package:flutter/foundation.dart';
import '../models/project.dart';
import '../models/note.dart';
import '../models/tag.dart';

class AppState extends ChangeNotifier {
  final List<Project> _projects = [];
  final List<Note> _notes = [];
  final List<Tag> _tags = [];

  // Estado de búsqueda y filtros
  String _searchQuery = '';
  String? _filterProjectId;
  List<Tag> _filterTags = [];
  bool _filterMatchAll = false; // true = todas, false = al menos una

  // Estado de navegación
  String? _currentProjectId;
  String? _currentNoteId;

  // Getters
  List<Project> get projects => List.unmodifiable(_projects);
  List<Note> get notes => List.unmodifiable(_notes);
  List<Tag> get tags => List.unmodifiable(_tags);
  String get searchQuery => _searchQuery;
  String? get filterProjectId => _filterProjectId;
  List<Tag> get filterTags => List.unmodifiable(_filterTags);
  bool get filterMatchAll => _filterMatchAll;
  String? get currentProjectId => _currentProjectId;
  String? get currentNoteId => _currentNoteId;

  AppState() {
    _loadSampleData();
  }

  void _loadSampleData() {
    // Crear etiquetas (8)
    final tagNLP = Tag(id: 'tag1', name: 'NLP', colorValue: 0xFF9C27B0);
    final tagTransformers = Tag(id: 'tag2', name: 'Transformers', colorValue: 0xFF2196F3);
    final tagRNN = Tag(id: 'tag3', name: 'RNN', colorValue: 0xFF4CAF50);
    final tagDeepLearning = Tag(id: 'tag4', name: 'Deep Learning', colorValue: 0xFFFF9800);
    final tagAttention = Tag(id: 'tag5', name: 'Attention', colorValue: 0xFFF44336);
    final tagGenomica = Tag(id: 'tag6', name: 'Genómica', colorValue: 0xFF009688);
    final tagComputerVision = Tag(id: 'tag7', name: 'Computer Vision', colorValue: 0xFFE91E63);
    final tagDataMining = Tag(id: 'tag8', name: 'Data Mining', colorValue: 0xFF3F51B5);

    _tags.addAll([tagNLP, tagTransformers, tagRNN, tagDeepLearning, tagAttention, tagGenomica, tagComputerVision, tagDataMining]);

    // Crear proyectos (3)
    final project1 = Project(
      id: 'proj1',
      name: 'Investigación IA',
      description: 'Análisis de modelos de lenguaje natural',
      createdAt: DateTime(2026, 9, 15),
      modifiedAt: DateTime(2026, 10, 2),
    );
    final project2 = Project(
      id: 'proj2',
      name: 'Redes Neuronales',
      description: 'Estudio de arquitecturas profundas',
      createdAt: DateTime(2026, 9, 10),
      modifiedAt: DateTime(2026, 10, 1),
    );
    final project3 = Project(
      id: 'proj3',
      name: 'Bioinformática',
      description: 'Análisis genómico computacional',
      createdAt: DateTime(2026, 9, 5),
      modifiedAt: DateTime(2026, 9, 30),
    );

    _projects.addAll([project1, project2, project3]);

    // Crear notas (15 total, 5 por proyecto)
    final now = DateTime.now();

    // Notas del proyecto 1 (Investigación IA) - 5 notas
    _notes.addAll([
      Note(
        id: 'note1',
        projectId: 'proj1',
        title: 'Introducción a BERT',
        description: 'BERT (Bidirectional Encoder Representations from Transformers) es un modelo de lenguaje desarrollado por Google en 2018. A diferencia de los modelos anteriores que procesaban el texto de izquierda a derecha o de derecha a izquierda, BERT utiliza un mecanismo de atención bidireccional que le permite capturar el contexto completo de una palabra en función de todas las palabras que la rodean.\n\nEl modelo se entrena en dos fases: pre-entrenamiento y ajuste fino. Durante el pre-entrenamiento, BERT aprende representaciones del lenguaje utilizando dos tareas: Masked Language Modeling (MLM) y Next Sentence Prediction (NSP).\n\nEn la tarea de MLM, se enmascara aleatoriamente el 15% de los tokens en la entrada y el modelo debe predecir cuáles son esos tokens basándose en el contexto. Esto obliga al modelo a aprender representaciones bidireccionales profundas.\n\nLa arquitectura de BERT se basa en el encoder del Transformer, con múltiples capas de auto-atención y redes feed-forward. BERT-Base tiene 12 capas, 768 dimensiones ocultas y 12 cabezas de atención, mientras que BERT-Large tiene 24 capas, 1024 dimensiones y 16 cabezas.\n\nEl impacto de BERT en el campo del NLP ha sido enorme, estableciendo nuevos estándares en múltiples tareas como clasificación de texto, respuesta a preguntas y análisis de sentimientos.',
        createdAt: DateTime(2026, 9, 28),
        modifiedAt: DateTime(2026, 10, 2),
        tags: [tagNLP, tagTransformers],
      ),
      Note(
        id: 'note2',
        projectId: 'proj1',
        title: 'Attention Is All You Need',
        description: 'El paper "Attention Is All You Need" (2017) presentó la arquitectura Transformer, que revolucionó el procesamiento del lenguaje natural.\n\nLa arquitectura Transformer se basa completamente en mecanismos de atención, evitando las estructuras recurrentes y convolucionales tradicionales. Esto permite una paralelización masiva durante el entrenamiento.\n\nLos componentes principales son: Multi-Head Attention, Position-wise Feed-Forward Networks, Positional Encoding y Layer Normalization.\n\nEl mecanismo de atención calcula la relevancia de cada palabra en la secuencia para cada otra palabra, permitiendo capturar dependencias de largo alcance.',
        createdAt: DateTime(2026, 9, 25),
        modifiedAt: DateTime(2026, 10, 1),
        tags: [tagAttention, tagTransformers],
      ),
      Note(
        id: 'note3',
        projectId: 'proj1',
        title: 'Redes Neuronales Recurrentes',
        description: 'Las RNN son fundamentales para el procesamiento de secuencias. A diferencia de las redes feed-forward, las RNN mantienen un estado oculto que captura información de pasos anteriores.\n\nSin embargo, las RNN sufren del problema del gradiente evanescente, lo que dificulta el aprendizaje de dependencias de largo plazo. Las variantes LSTM y GRU resuelven parcialmente este problema.\n\nLas LSTM (Long Short-Term Memory) introducen celdas de memoria y puertas que controlan el flujo de información, permitiendo recordar información por períodos largos.',
        createdAt: DateTime(2026, 9, 20),
        modifiedAt: DateTime(2026, 9, 30),
        tags: [tagRNN],
      ),
      Note(
        id: 'note4',
        projectId: 'proj1',
        title: 'Deep Learning Fundamentals',
        description: 'Los fundamentos del aprendizaje profundo incluyen redes neuronales multicapa, funciones de activación, algoritmos de optimización y técnicas de regularización.\n\nLas funciones de activación más comunes son ReLU, Sigmoid y Tanh. El algoritmo de optimización más utilizado es Adam, que combina momentum y tasas de aprendizaje adaptativas.\n\nLa regularización incluye técnicas como Dropout, Batch Normalization y Weight Decay para prevenir el sobreajuste.',
        createdAt: DateTime(2026, 9, 18),
        modifiedAt: DateTime(2026, 9, 28),
        tags: [tagDeepLearning],
      ),
      Note(
        id: 'note5',
        projectId: 'proj1',
        title: 'Computer Vision con CNNs',
        description: 'Las Redes Neuronales Convolucionales (CNNs) son la arquitectura dominante en visión por computadora. Utilizan capas convolucionales que detectan patrones locales como bordes, texturas y formas.\n\nLas arquitecturas más famosas incluyen LeNet, AlexNet, VGG, ResNet y EfficientNet. Cada una introdujo innovaciones como conexiones residuales y bloques de atención.',
        createdAt: DateTime(2026, 9, 15),
        modifiedAt: DateTime(2026, 9, 25),
        tags: [tagComputerVision, tagDeepLearning],
      ),
    ]);

    // Notas del proyecto 2 (Redes Neuronales) - 5 notas
    _notes.addAll([
      Note(
        id: 'note6',
        projectId: 'proj2',
        title: 'Perceptrón y Redes Básicas',
        description: 'El perceptrón es la unidad fundamental de las redes neuronales. Fue propuesto por Frank Rosenblatt en 1958.\n\nUn perceptrón toma múltiples entradas, las pesas, las suma y aplica una función de activación para producir una salida. El aprendizaje ajusta los pesos para minimizar el error.\n\nEl perceptrón solo puede resolver problemas linealmente separables. Para problemas más complejos, se necesitan múltiples capas.',
        createdAt: DateTime(2026, 9, 12),
        modifiedAt: DateTime(2026, 9, 28),
        tags: [tagDeepLearning],
      ),
      Note(
        id: 'note7',
        projectId: 'proj2',
        title: 'Backpropagation',
        description: 'El algoritmo de retropropagación (backpropagation) es el método fundamental para entrenar redes neuronales multicapa.\n\nFunciona calculando el gradiente de la función de pérdida con respecto a cada peso utilizando la regla de la cadena. El gradiente se propaga desde la salida hacia la entrada, capa por capa.\n\nEl aprendizaje consiste en ajustar los pesos en dirección opuesta al gradiente para minimizar la pérdida.',
        createdAt: DateTime(2026, 9, 10),
        modifiedAt: DateTime(2026, 9, 25),
        tags: [tagDeepLearning],
      ),
      Note(
        id: 'note8',
        projectId: 'proj2',
        title: 'LSTM y GRU',
        description: 'Las LSTM (Long Short-Term Memory) y GRU (Gated Recurrent Units) son variantes de RNN diseñadas para manejar dependencias de largo plazo.\n\nLas LSTM tienen tres puertas: de entrada, de olvido y de salida. Estas puertas controlan qué información se almacena, se descarta y se output.\n\nLas GRU son una simplificación con dos puertas: de actualización y de reset. Son más rápidas de entrenar y a menudo igualan el rendimiento de las LSTM.',
        createdAt: DateTime(2026, 9, 8),
        modifiedAt: DateTime(2026, 9, 22),
        tags: [tagRNN],
      ),
      Note(
        id: 'note9',
        projectId: 'proj2',
        title: 'Data Mining Techniques',
        description: 'El data mining (minería de datos) es el proceso de descubrir patrones en grandes conjuntos de datos.\n\nLas técnicas principales incluyen clasificación, clustering, regresión y reglas de asociación.\n\nLos algoritmos más comunes son K-Means, DBSCAN, Random Forest y Apriori.',
        createdAt: DateTime(2026, 9, 5),
        modifiedAt: DateTime(2026, 9, 20),
        tags: [tagDataMining],
      ),
      Note(
        id: 'note10',
        projectId: 'proj2',
        title: 'Transformers en Visión',
        description: 'Los Transformers no se limitan al NLP. Vision Transformers (ViT) aplican la arquitectura Transformer a imágenes.\n\nLa imagen se divide en patches, que se tratan como tokens. El mecanismo de atención captura relaciones globales entre todas las partes de la imagen.\n\nViT ha alcanzado resultados state-of-the-art en clasificación de imágenes, superando a las CNNs en algunos benchmarks.',
        createdAt: DateTime(2026, 9, 3),
        modifiedAt: DateTime(2026, 9, 18),
        tags: [tagTransformers, tagComputerVision],
      ),
    ]);

    // Notas del proyecto 3 (Bioinformática) - 5 notas
    _notes.addAll([
      Note(
        id: 'note11',
        projectId: 'proj3',
        title: 'Secuenciación Genómica',
        description: 'La secuenciación genómica permite leer el código completo de un organismo. Las tecnologías modernas pueden secuenciar un genoma humano completo en días.\n\nLas tecnologías principales son: Sanger (primera generación), Illumina (segunda generación) y Oxford Nanopore/PacBio (tercera generación).\n\nCada tecnología tiene ventajas y desventajas en términos de longitud de lectura, precisión y costo.',
        createdAt: DateTime(2026, 9, 28),
        modifiedAt: DateTime(2026, 10, 1),
        tags: [tagGenomica],
      ),
      Note(
        id: 'note12',
        projectId: 'proj3',
        title: 'Alineación de Secuencias',
        description: 'La alineación de secuencias es fundamental en bioinformática para comparar secuencias de ADN, ARN o proteínas.\n\nLos algoritmos principales son Needleman-Wunsch (global) y Smith-Waterman (local). Ambos utilizan programación dinámica.\n\nBLAST es una herramienta heurística rápida para buscar similitudes en bases de datos grandes.',
        createdAt: DateTime(2026, 9, 25),
        modifiedAt: DateTime(2026, 9, 30),
        tags: [tagGenomica],
      ),
      Note(
        id: 'note13',
        projectId: 'proj3',
        title: 'Machine Learning en Bioinformática',
        description: 'El machine learning tiene aplicaciones crecientes en bioinformática: predicción de estructuras proteicas, análisis de expresión génica y descubrimiento de fármacos.\n\nLas redes neuronales profundas han demostrado ser especialmente efectivas para predecir la estructura 3D de proteínas, como lo demostró AlphaFold.',
        createdAt: DateTime(2026, 9, 22),
        modifiedAt: DateTime(2026, 9, 28),
        tags: [tagGenomica, tagDeepLearning],
      ),
      Note(
        id: 'note14',
        projectId: 'proj3',
        title: 'Análisis de Datos Ómicos',
        description: 'Los datos ómicos (genómica, transcriptómica, proteómica, metabolómica) requieren herramientas especializadas para su análisis.\n\nEl análisis de datos de secuenciación de nueva generación (NGS) involucra control de calidad, alineación, cuantificación y análisis diferencial.\n\nHerramientas comunes incluyen BWA, STAR, DESeq2 y edgeR.',
        createdAt: DateTime(2026, 9, 20),
        modifiedAt: DateTime(2026, 9, 25),
        tags: [tagGenomica, tagDataMining],
      ),
      Note(
        id: 'note15',
        projectId: 'proj3',
        title: 'Notas sin etiquetas',
        description: 'Esta nota no tiene etiquetas asignadas para cumplir con el requisito de al menos una nota sin etiquetas en los datos de prueba.',
        createdAt: DateTime(2026, 9, 18),
        modifiedAt: DateTime(2026, 9, 18),
        tags: [],
      ),
    ]);
  }

  // ==================== PROYECTOS ====================

  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void addProject(String name, String description) {
    final project = Project(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    );
    _projects.add(project);
    notifyListeners();
  }

  void updateProject(String id, String name, String description) {
    final project = getProjectById(id);
    if (project != null) {
      project.name = name;
      project.description = description;
      project.modifiedAt = DateTime.now();
      notifyListeners();
    }
  }

  void deleteProject(String id) {
    // Eliminar notas del proyecto
    _notes.removeWhere((n) => n.projectId == id);
    // Eliminar proyecto
    _projects.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  int getNoteCountForProject(String projectId) {
    return _notes.where((n) => n.projectId == projectId).length;
  }

  // ==================== NOTAS ====================

  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Note> getNotesForProject(String projectId) {
    return _notes.where((n) => n.projectId == projectId).toList();
  }

  void addNote(String projectId, String title, String description, List<Tag> tags) {
    final note = Note(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      projectId: projectId,
      title: title,
      description: description,
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
      tags: tags,
    );
    _notes.add(note);
    // Actualizar fecha de modificación del proyecto
    final project = getProjectById(projectId);
    if (project != null) {
      project.modifiedAt = DateTime.now();
    }
    notifyListeners();
  }

  void updateNote(String id, String title, String description, List<Tag> tags) {
    final note = getNoteById(id);
    if (note != null) {
      note.title = title;
      note.description = description;
      note.tags = tags;
      note.modifiedAt = DateTime.now();
      // Actualizar fecha de modificación del proyecto
      final project = getProjectById(note.projectId);
      if (project != null) {
        project.modifiedAt = DateTime.now();
      }
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  // ==================== ETIQUETAS ====================

  Tag? getTagById(String id) {
    try {
      return _tags.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Tag? findTagByName(String name) {
    String normalized = name.toLowerCase().trim();
    final Map<String, String> accentMap = {
      'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u',
      'à': 'a', 'è': 'e', 'ì': 'i', 'ò': 'o', 'ù': 'u',
      'ä': 'a', 'ë': 'e', 'ï': 'i', 'ö': 'o', 'ü': 'u',
      'â': 'a', 'ê': 'e', 'î': 'i', 'ô': 'o', 'û': 'u',
      'ã': 'a', 'ñ': 'n', 'õ': 'o',
    };
    accentMap.forEach((accent, replacement) {
      normalized = normalized.replaceAll(accent, replacement);
    });

    for (final tag in _tags) {
      if (tag.normalizedName == normalized) {
        return tag;
      }
    }
    return null;
  }

  List<Tag> searchTags(String query) {
    if (query.isEmpty) return List.from(_tags);
    String normalizedQuery = query.toLowerCase().trim();
    final Map<String, String> accentMap = {
      'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u',
      'à': 'a', 'è': 'e', 'ì': 'i', 'ò': 'o', 'ù': 'u',
      'ä': 'a', 'ë': 'e', 'ï': 'i', 'ö': 'o', 'ü': 'u',
      'â': 'a', 'ê': 'e', 'î': 'i', 'ô': 'o', 'û': 'u',
      'ã': 'a', 'ñ': 'n', 'õ': 'o',
    };
    accentMap.forEach((accent, replacement) {
      normalizedQuery = normalizedQuery.replaceAll(accent, replacement);
    });

    return _tags.where((tag) => tag.normalizedName.contains(normalizedQuery)).toList();
  }

  void addTag(String name, int colorValue) {
    final tag = Tag(
      id: 'tag_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      colorValue: colorValue,
    );
    _tags.add(tag);
    notifyListeners();
  }

  void updateTag(String id, String newName) {
    final tag = getTagById(id);
    if (tag != null) {
      tag.name = newName;
      notifyListeners();
    }
  }

  void deleteTag(String id) {
    _tags.removeWhere((t) => t.id == id);
    // Quitar la etiqueta de todas las notas
    for (final note in _notes) {
      note.tags.removeWhere((t) => t.id == id);
    }
    notifyListeners();
  }

  int getNoteCountForTag(String tagId) {
    return _notes.where((n) => n.tags.any((t) => t.id == tagId)).length;
  }

  List<Note> getNotesForTag(String tagId) {
    return _notes.where((n) => n.tags.any((t) => t.id == tagId)).toList();
  }

  List<Note> getNotesForTags(List<Tag> tags, {bool matchAll = false}) {
    if (tags.isEmpty) return List.from(_notes);
    if (matchAll) {
      // Notas que tienen TODAS las etiquetas
      return _notes.where((n) => tags.every((t) => n.tags.any((nt) => nt.id == t.id))).toList();
    } else {
      // Notas que tienen AL MENOS UNA etiqueta
      return _notes.where((n) => tags.any((t) => n.tags.any((nt) => nt.id == t.id))).toList();
    }
  }

  // ==================== BÚSQUEDA ====================

  List<Note> searchNotes(String query, {String? projectId, List<Tag>? tags, bool matchAll = false}) {
    List<Note> results = List.from(_notes);

    // Filtrar por texto
    if (query.isNotEmpty) {
      String normalizedQuery = query.toLowerCase();
      results = results.where((n) =>
        n.title.toLowerCase().contains(normalizedQuery) ||
        n.description.toLowerCase().contains(normalizedQuery)
      ).toList();
    }

    // Filtrar por proyecto
    if (projectId != null) {
      results = results.where((n) => n.projectId == projectId).toList();
    }

    // Filtrar por etiquetas
    if (tags != null && tags.isNotEmpty) {
      if (matchAll) {
        results = results.where((n) => tags.every((t) => n.tags.any((nt) => nt.id == t.id))).toList();
      } else {
        results = results.where((n) => tags.any((t) => n.tags.any((nt) => nt.id == t.id))).toList();
      }
    }

    return results;
  }

  // ==================== NAVEGACIÓN ====================

  void setCurrentProject(String? projectId) {
    _currentProjectId = projectId;
    notifyListeners();
  }

  void setCurrentNote(String? noteId) {
    _currentNoteId = noteId;
    notifyListeners();
  }

  // ==================== FILTROS ====================

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterProject(String? projectId) {
    _filterProjectId = projectId;
    notifyListeners();
  }

  void setFilterTags(List<Tag> tags) {
    _filterTags = tags;
    notifyListeners();
  }

  void setFilterMatchAll(bool matchAll) {
    _filterMatchAll = matchAll;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterProjectId = null;
    _filterTags = [];
    _filterMatchAll = false;
    notifyListeners();
  }
}
