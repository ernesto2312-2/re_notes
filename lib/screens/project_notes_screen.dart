import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../models/note.dart';
import '../models/tag.dart';
import 'note_detail_screen.dart';
import 'note_editor_screen.dart';

class ProjectNotesScreen extends StatefulWidget {
  final AppState appState;
  final String projectId;

  const ProjectNotesScreen({
    super.key,
    required this.appState,
    required this.projectId,
  });

  @override
  State<ProjectNotesScreen> createState() => _ProjectNotesScreenState();
}

class _ProjectNotesScreenState extends State<ProjectNotesScreen> {
  String _searchQuery = '';
  List<Tag> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: widget.appState,
          builder: (context, child) {
            final project = widget.appState.getProjectById(widget.projectId);
            final noteCount = widget.appState.getNoteCountForProject(widget.projectId);
            return Text('${project?.name ?? 'Proyecto'} ($noteCount notas)');
          },
        ),
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar en notas...',
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
          // Filtros por etiquetas
          _buildTagFilters(),
          // Lista de notas
          Expanded(
            child: ListenableBuilder(
              listenable: widget.appState,
              builder: (context, child) {
                var notes = widget.appState.getNotesForProject(widget.projectId);

                // Filtrar por búsqueda
                if (_searchQuery.isNotEmpty) {
                  notes = notes.where((n) =>
                    n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    n.description.toLowerCase().contains(_searchQuery.toLowerCase())
                  ).toList();
                }

                // Filtrar por etiquetas
                if (_selectedTags.isNotEmpty) {
                  notes = notes.where((n) =>
                    _selectedTags.every((t) => n.tags.any((nt) => nt.id == t.id))
                  ).toList();
                }

                if (notes.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _buildNoteCard(notes[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditorScreen(
                appState: widget.appState,
                projectId: widget.projectId,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTagFilters() {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, child) {
        final notes = widget.appState.getNotesForProject(widget.projectId);
        final availableTags = <Tag>{};
        for (final note in notes) {
          availableTags.addAll(note.tags);
        }

        if (availableTags.isEmpty) return const SizedBox.shrink();

        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: availableTags.map((tag) {
              final isSelected = _selectedTags.any((t) => t.id == tag.id);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(tag.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.removeWhere((t) => t.id == tag.id);
                      }
                    });
                  },
                  selectedColor: Color(tag.colorValue).withOpacity(0.3),
                  checkmarkColor: Color(tag.colorValue),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_add, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _selectedTags.isNotEmpty
                ? 'Sin resultados'
                : 'Sin notas',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedTags.isNotEmpty
                ? 'No se encontraron notas con los filtros aplicados'
                : 'Crea la primera nota de este proyecto',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    color: Colors.red,
                    onPressed: () => _showDeleteNoteDialog(note),
                  ),
                ],
              ),
              if (note.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  note.excerpt,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              if (note.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: note.tags.map((tag) {
                    return Chip(
                      label: Text(
                        tag.name,
                        style: const TextStyle(fontSize: 11, color: Colors.white),
                      ),
                      backgroundColor: Color(tag.colorValue),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              const SizedBox(height: 8),
              Text(
                'Mod: ${_formatDate(note.modifiedAt)}',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showDeleteNoteDialog(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Nota'),
        content: Text('¿Estás seguro de eliminar "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              widget.appState.deleteNote(note.id);
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
