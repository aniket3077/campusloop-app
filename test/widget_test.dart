import 'package:flutter_test/flutter_test.dart';
import 'package:campusloop/main.dart';

void main() {
  testWidgets('CampusLoopApp launches smoke test', (WidgetTester tester) async {
    // Build CampusLoopApp and trigger a frame.
    await tester.pumpWidget(const CampusLoopApp());

    // Verify that CampusLoop app renders.
    expect(find.byType(CampusLoopApp), findsOneWidget);
  });
}
