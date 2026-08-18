import 'package:finly/app/app.dart';
import 'package:finly/app/config/env_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    AppConfig.initialize(env: EnvConfig.dev);
  });

  testWidgets(
    'FinlyApp renders 5 navigation tabs and displays Dashboard components',
    (tester) async {
      // Set desktop / tablet screen size to avoid any viewport overflow in tests
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const ProviderScope(child: FinlyApp()));

      // Initial pump and settle
      await tester.pumpAndSettle();

      // Verify Finly App title and navigation bar destinations
      expect(find.text('Finly'), findsOneWidget);
      expect(find.text('Tổng quan'), findsOneWidget);
      expect(find.text('Sổ thu chi'), findsOneWidget);
      expect(find.text('Ngân sách'), findsOneWidget);
      expect(find.text('Báo cáo'), findsOneWidget);
      expect(find.text('Cá nhân'), findsOneWidget);

      // Verify Dashboard Cards
      expect(find.text('Tổng số dư khả dụng'), findsOneWidget);
      expect(find.text('Finly Smart Insight'), findsOneWidget);
      expect(find.text('Ngân sách danh mục'), findsOneWidget);
      expect(find.text('Giao dịch gần đây'), findsOneWidget);
    },
  );
}
