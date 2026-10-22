import 'package:flutter_test/flutter_test.dart';
// ignore: avoid_relative_lib_imports
import '../lib/main.dart';

void main() {
  testWidgets('Example app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('AnimatedRepeatable'), findsOneWidget);
  });
}
