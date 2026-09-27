import 'package:flutter_test/flutter_test.dart';
import 'package:secret_among_us/main.dart';

void main() {
  testWidgets('Secret Among Us launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const SecretAmongUsApp());
    await tester.pump();
    expect(find.byType(SecretAmongUsApp), findsOneWidget);
  });
}
