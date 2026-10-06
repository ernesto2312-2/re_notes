class Tag {
  final String id;
  String name;
  final int colorValue;

  Tag({
    required this.id,
    required this.name,
    required this.colorValue,
  });

  /// Normaliza el nombre para comparación (sin acentos, minúsculas, sin espacios)
  String get normalizedName {
    String normalized = name.toLowerCase().trim();
    // Eliminar acentos
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
    return normalized;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag && runtimeType == other.runtimeType && normalizedName == other.normalizedName;

  @override
  int get hashCode => normalizedName.hashCode;
}
