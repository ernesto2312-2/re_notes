import 'package:flutter_test/flutter_test.dart';
import 'package:renotes/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ReNotesApp());

    // Verificar que el BottomNavigationBar tiene los 3 destinos
    expect(find.text('Proyectos'), findsWidgets);
    expect(find.text('Etiquetas'), findsWidgets);
    expect(find.text('Buscar'), findsWidgets);
  });
}
