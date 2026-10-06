import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../models/note.dart';
import '../models/tag.dart';
import 'note_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final AppState appState;

  const SearchScreen({super.key, required this.appState});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  String? _selectedProjectId;
  List<Tag> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar en todas las notas...',
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

          // Filtros
          _buildFilters(),

          // Resultados
          Expanded(
            child: ListenableBuilder(
              listenable: widget.appState,
              builder: (context, child) {
                final results = widget.appState.searchNotes(
                  _searchQuery,
                  projectId: _selectedProjectId,
                  tags: _selectedTags.isNotEmpty ? _selectedTags : null,
                );

                if (results.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _buildResultCard(results[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Filtro por proyecto
          DropdownButtonFormField<String?>(
            value: _selectedProjectId,
            decoration: const InputDecoration(
              labelText: 'Proyecto',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Todos los proyectos'),
              ),
              ...widget.appState.projects.map((project) {
                return DropdownMenuItem<String?>(
                  value: project.id,
                  child: Text(project.name),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                _selectedProjectId = value;
              });
            },
          ),
          const SizedBox(height: 8),

          // Filtro por etiquetas
          Wrap(
            spacing: 8,
            children: widget.appState.tags.map((tag) {
              final isSelected = _selectedTags.any((t) => t.id == tag.id);
              return FilterChip(
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
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Sin resultados',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'No se encontraron notas que coincidan con tu búsqueda',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(Note note) {
    final project = widget.appState.getProjectById(note.projectId);

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
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '📁 ${project?.name ?? 'Proyecto desconocido'}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (note.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  note.excerpt,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (note.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}
