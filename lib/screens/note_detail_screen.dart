import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../models/note.dart';
import 'note_editor_screen.dart';
import 'tags_screen.dart';

class NoteDetailScreen extends StatefulWidget {
  final AppState appState;
  final String noteId;

  const NoteDetailScreen({
    super.key,
    required this.appState,
    required this.noteId,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Nota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final note = widget.appState.getNoteById(widget.noteId);
              if (note != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteEditorScreen(
                      appState: widget.appState,
                      projectId: note.projectId,
                      noteId: note.id,
                    ),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.appState,
        builder: (context, child) {
          final note = widget.appState.getNoteById(widget.noteId);
          if (note == null) {
            return const Center(child: Text('Nota no encontrada'));
          }

          final project = widget.appState.getProjectById(note.projectId);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón volver
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver'),
                ),
                const SizedBox(height: 8),

                // Título
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Metadatos
                Text(
                  '📁 ${project?.name ?? 'Proyecto desconocido'} · '
                  'Creada: ${_formatDate(note.createdAt)} · '
                  'Mod: ${_formatDate(note.modifiedAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                // Etiquetas
                if (note.tags.isNotEmpty) ...[
                  const Text(
                    'Etiquetas:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: note.tags.map((tag) {
                      return ActionChip(
                        label: Text(tag.name),
                        backgroundColor: Color(tag.colorValue).withOpacity(0.2),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TagsScreen(
                                appState: widget.appState,
                                initialFilterTag: tag,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Descripción
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    note.description.isEmpty ? 'Sin descripción' : note.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: note.description.isEmpty ? Colors.grey[400] : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Nota'),
        content: const Text('¿Estás seguro de eliminar esta nota?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              widget.appState.deleteNote(widget.noteId);
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context); // Volver a la pantalla anterior
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
