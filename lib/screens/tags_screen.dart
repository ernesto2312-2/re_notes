import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../models/tag.dart';
import '../models/note.dart';
import 'note_detail_screen.dart';

class TagsScreen extends StatefulWidget {
  final AppState appState;
  final Tag? initialFilterTag;

  const TagsScreen({
    super.key,
    required this.appState,
    this.initialFilterTag,
  });

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  String _searchQuery = '';
  List<Tag> _selectedTags = [];
  bool _matchAll = false;
  bool _showGroupedNotes = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilterTag != null) {
      _selectedTags = [widget.initialFilterTag!];
      _showGroupedNotes = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etiquetas'),
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar etiquetas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Lista de etiquetas o notas agrupadas
          Expanded(
            child: ListenableBuilder(
              listenable: widget.appState,
              builder: (context, child) {
                if (_showGroupedNotes && _selectedTags.isNotEmpty) {
                  return _buildGroupedNotesView();
                }
                return _buildTagsListView();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTagDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTagsListView() {
    final tags = widget.appState.searchTags(_searchQuery);

    if (tags.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.label_off, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty ? 'Sin resultados' : 'No hay etiquetas',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No se encontraron etiquetas'
                  : 'Crea etiquetas para clasificar tus notas',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tags.length,
      itemBuilder: (context, index) {
        final tag = tags[index];
        final noteCount = widget.appState.getNoteCountForTag(tag.id);
        final isSelected = _selectedTags.any((t) => t.id == tag.id);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(tag.colorValue),
              radius: 12,
            ),
            title: Text(tag.name),
            subtitle: Text('$noteCount notas'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.removeWhere((t) => t.id == tag.id);
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditTagDialog(tag),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red,
                  onPressed: () => _showDeleteTagDialog(tag),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _selectedTags = [tag];
                _showGroupedNotes = true;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildGroupedNotesView() {
    final notes = widget.appState.getNotesForTags(_selectedTags, matchAll: _matchAll);

    return Column(
      children: [
        // Encabezado con botón volver
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _showGroupedNotes = false;
                    _selectedTags = [];
                  });
                },
              ),
              Expanded(
                child: Text(
                  'Notas con ${_selectedTags.map((t) => t.name).join(', ')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        // Filtro todas/al menos una
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('Todas'),
                selected: _matchAll,
                onSelected: (selected) {
                  setState(() {
                    _matchAll = true;
                  });
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Al menos una'),
                selected: !_matchAll,
                onSelected: (selected) {
                  setState(() {
                    _matchAll = false;
                  });
                },
              ),
            ],
          ),
        ),

        // Lista de notas
        Expanded(
          child: notes.isEmpty
              ? Center(
                  child: Text(
                    'Sin notas',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _buildNoteItem(notes[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildNoteItem(Note note) {
    final project = widget.appState.getProjectById(note.projectId);

    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📁 ${project?.name ?? 'Proyecto'}'),
            if (note.tags.isNotEmpty)
              Wrap(
                spacing: 4,
                children: note.tags.map((tag) {
                  return Chip(
                    label: Text(tag.name, style: const TextStyle(fontSize: 10)),
                    backgroundColor: Color(tag.colorValue).withOpacity(0.2),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
          ],
        ),
        onTap: () {
          widget.appState.setCurrentNote(note.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailScreen(
                appState: widget.appState,
                noteId: note.id,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCreateTagDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Etiqueta'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Nombre de la etiqueta',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                final colors = [
                  0xFF9C27B0, 0xFF2196F3, 0xFF4CAF50, 0xFFFF9800,
                  0xFFF44336, 0xFF009688, 0xFFE91E63, 0xFF3F51B5,
                ];
                widget.appState.addTag(
                  controller.text.trim(),
                  colors[widget.appState.tags.length % colors.length],
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showEditTagDialog(Tag tag) {
    final controller = TextEditingController(text: tag.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renombrar Etiqueta'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nuevo nombre',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                final existing = widget.appState.findTagByName(controller.text.trim());
                if (existing != null && existing.id != tag.id) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ya existe una etiqueta con ese nombre')),
                  );
                  return;
                }
                widget.appState.updateTag(tag.id, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteTagDialog(Tag tag) {
    final noteCount = widget.appState.getNoteCountForTag(tag.id);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Etiqueta'),
        content: Text(
          '¿Estás seguro de eliminar "${tag.name}"? Se quitará de $noteCount notas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              widget.appState.deleteTag(tag.id);
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
