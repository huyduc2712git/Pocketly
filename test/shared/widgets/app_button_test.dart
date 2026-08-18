import 'package:finly/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppButton Widget Tests', () {
    testWidgets('Renders button text and responds to tap', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Xác nhận',
              onPressed: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Xác nhận'), findsOneWidget);
      await tester.tap(find.text('Xác nhận'));
      await tester.pump();

      expect(wasTapped, isTrue);
    });

    testWidgets('Shows CircularProgressIndicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Đang lưu...',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Đang lưu...'), findsNothing);
    });
  });
}
