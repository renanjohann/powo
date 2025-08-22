// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in a widget, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:powo_app/main.dart';

void main() {
  testWidgets('POWO app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PowoApp());

    // Verify that our app shows the POWO title
    expect(find.text('POWO'), findsOneWidget);
    
    // Verify that onboarding screen is shown
    expect(find.text('Avalie restaurantes e produtos'), findsOneWidget);
    
    // Verify that both user type options are present
    expect(find.text('Sou um Usuário'), findsOneWidget);
    expect(find.text('Sou um Restaurante'), findsOneWidget);
  });
}
