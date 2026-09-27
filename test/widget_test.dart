import 'package:flutter_test/flutter_test.dart';
import 'package:secret_among_us/main.dart';

void main() {
  testWidgets('Secret Among Us launches', (WidgetTester tester) async {
    await tester.pumpWidget(const SecretAmongUsApp());
    await tester.pumpAndSettle();

    expect(find.text('Secret Among Us'), findsOneWidget);
  });
}
