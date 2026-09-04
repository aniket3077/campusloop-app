import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusloop/widgets/common/campusloop_logo_widget.dart';

void main() {
  testWidgets('CampusLoopLogoWidget renders properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CampusLoopLogoWidget(size: 100),
        ),
      ),
    );

    expect(find.byType(CampusLoopLogoWidget), findsOneWidget);
  });
}
