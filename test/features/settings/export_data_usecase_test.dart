import 'dart:convert';
import 'package:finly/features/settings/domain/usecases/export_data_usecase.dart';
import 'package:finly/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ExportDataUseCase exportUseCase;

  setUp(() {
    exportUseCase = const ExportDataUseCase();
  });

  group('ExportDataUseCase Tests', () {
    final now = DateTime(2026, 8, 18, 14, 30);
    final txList = [
      TransactionEntity(
        id: 'tx_1',
        type: 'expense',
        amount: 250000.0,
        currency: 'VND',
        walletId: 'w1',
        walletName: 'Ví tiền mặt',
        categoryId: 'c1',
        categoryName: 'Ăn uống',
        note: 'Ăn trưa với đồng nghiệp',
        occurredAt: now,
        createdAt: now,
        updatedAt: now,
      ),
      TransactionEntity(
        id: 'tx_2',
        type: 'income',
        amount: 15000000.0,
        currency: 'VND',
        walletId: 'w2',
        walletName: 'Techcombank',
        categoryId: 'c2',
        categoryName: 'Lương',
        occurredAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    test('Generates valid CSV formatted string with headers', () {
      final csv = exportUseCase.exportToCsv(txList);
      expect(
        csv,
        contains(
          'ID,Ngay,Loai,So_Tien,Don_Vi,Danh_Muc,Vi_Nguon,Vi_Dich,Ghi_Chu',
        ),
      );
      expect(
        csv,
        contains(
          'tx_1,18/08/2026,expense,250000.0,VND,"Ăn uống","Ví tiền mặt","","Ăn trưa với đồng nghiệp"',
        ),
      );
      expect(
        csv,
        contains(
          'tx_2,18/08/2026,income,15000000.0,VND,"Lương","Techcombank","",""',
        ),
      );
    });

    test('Generates valid JSON formatted string', () {
      final jsonStr = exportUseCase.exportToJson(txList);
      final decoded = json.decode(jsonStr) as List<dynamic>;

      expect(decoded.length, equals(2));
      expect(decoded.first['id'], equals('tx_1'));
      expect(decoded.first['amount'], equals(250000.0));
      expect(decoded.first['walletName'], equals('Ví tiền mặt'));
    });
  });
}
