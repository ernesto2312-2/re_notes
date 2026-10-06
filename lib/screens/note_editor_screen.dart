import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../models/note.dart';
import '../models/tag.dart';

class NoteEditorScreen extends StatefulWidget {
  final AppState appState;
  final String? projectId;
  final String? noteId;

  const NoteEditorScreen({
    super.key,
    required this.appState,
    this.projectId,
    this.noteId,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Tag> _selectedTags = [];
  bool _hasChanges = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.noteId != null;

    if (_isEditing) {
      final note = widget.appState.getNoteById(widget.noteId!);
      if (note != null) {
        _titleController.text = note.title;
        _descriptionController.text = note.description;
        _selectedTags = List.from(note.tags);
      }
    }

    _titleController.addListener(_onChanged);
    _descriptionController.addListener(_onChanged);
  }

  void _onChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showDiscardDialog();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Editar Nota' : 'Nueva Nota'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campo de título
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título *',
                    hintText: 'Título de la nota',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El título es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de descripción
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Escribe aquí tu nota...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 10,
                  minLines: 5,
                ),
                const SizedBox(height: 16),

                // Campo de etiquetas con autocompletado
                _buildTagAutocomplete(),

                // Chips de etiquetas seleccionadas
                if (_selectedTags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Etiquetas asignadas:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _selectedTags.map((tag) {
                      return Chip(
                        label: Text(tag.name),
                        backgroundColor: Color(tag.colorValue).withOpacity(0.2),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            _selectedTags.removeWhere((t) => t.id == tag.id);
                            _hasChanges = true;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 24),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          if (_hasChanges) {
                            final shouldPop = await _showDiscardDialog();
                            if (shouldPop && context.mounted) {
                              Navigator.pop(context);
                            }
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _saveNote,
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagAutocomplete() {
    return Autocomplete<Tag>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Tag>.empty();
        }
        return widget.appState.searchTags(textEditingValue.text)
            .where((tag) => !_selectedTags.any((t) => t.id == tag.id));
      },
      displayStringForOption: (Tag tag) => tag.name,
      onSelected: (Tag tag) {
        setState(() {
          if (!_selectedTags.any((t) => t.id == tag.id)) {
            _selectedTags.add(tag);
            _hasChanges = true;
          }
          _tagController.clear();
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Etiquetas',
            hintText: 'Escribe una etiqueta...',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.label),
          ),
          onFieldSubmitted: (value) {
            _addTagFromInput(value);
          },
        );
      },
    );
  }

  void _addTagFromInput(String value) {
    if (value.trim().isEmpty) return;

    final existingTag = widget.appState.findTagByName(value);
    if (existingTag != null) {
      setState(() {
        if (!_selectedTags.any((t) => t.id == existingTag.id)) {
          _selectedTags.add(existingTag);
          _hasChanges = true;
        }
        _tagController.clear();
      });
    } else {
      // Crear nueva etiqueta
      final colors = [
        0xFF9C27B0, 0xFF2196F3, 0xFF4CAF50, 0xFFFF9800,
        0xFFF44336, 0xFF009688, 0xFFE91E63, 0xFF3F51B5,
      ];
      final newTag = Tag(
        id: 'tag_${DateTime.now().millisecondsSinceEpoch}',
        name: value.trim(),
        colorValue: colors[widget.appState.tags.length % colors.length],
      );
      widget.appState.addTag(newTag.name, newTag.colorValue);
      setState(() {
        _selectedTags.add(newTag);
        _hasChanges = true;
        _tagController.clear();
      });
    }
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (_isEditing) {
      widget.appState.updateNote(
        widget.noteId!,
        title,
        description,
        _selectedTags,
      );
    } else {
      widget.appState.addNote(
        widget.projectId!,
        title,
        description,
        _selectedTags,
      );
    }

    Navigator.pop(context);
  }

  Future<bool> _showDiscardDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambios sin guardar'),
        content: const Text('Tienes cambios sin guardar. ¿Deseas descartarlos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí, descartar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
