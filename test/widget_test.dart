import 'package:flutter_test/flutter_test.dart';
import 'package:gemshunter/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts on the start page.
    expect(find.text('GEMS HUNTER'), findsOneWidget);
    expect(find.text('START MISSION'), findsOneWidget);
  });
}
