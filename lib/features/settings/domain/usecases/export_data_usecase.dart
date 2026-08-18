import 'dart:convert';
import '../../../../core/utils/date_formatter.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';

class ExportDataUseCase {
  const ExportDataUseCase();

  String exportToCsv(List<TransactionEntity> transactions) {
    final buffer = StringBuffer();
    // CSV Header
    buffer.writeln(
      'ID,Ngay,Loai,So_Tien,Don_Vi,Danh_Muc,Vi_Nguon,Vi_Dich,Ghi_Chu',
    );

    for (final tx in transactions) {
      final dateStr = DateFormatter.formatDate(tx.occurredAt);
      final noteStr = tx.note != null
          ? '"${tx.note!.replaceAll('"', '""')}"'
          : '""';
      final catStr = tx.categoryName != null ? '"${tx.categoryName!}"' : '""';
      final walletStr = tx.walletName != null ? '"${tx.walletName!}"' : '""';
      final toWalletStr = tx.toWalletName != null
          ? '"${tx.toWalletName!}"'
          : '""';

      buffer.writeln(
        '${tx.id},$dateStr,${tx.type},${tx.amount},${tx.currency},$catStr,$walletStr,$toWalletStr,$noteStr',
      );
    }

    return buffer.toString();
  }

  String exportToJson(List<TransactionEntity> transactions) {
    final list = transactions.map((tx) {
      return {
        'id': tx.id,
        'type': tx.type,
        'amount': tx.amount,
        'currency': tx.currency,
        'walletId': tx.walletId,
        'walletName': tx.walletName,
        'toWalletId': tx.toWalletId,
        'toWalletName': tx.toWalletName,
        'categoryId': tx.categoryId,
        'categoryName': tx.categoryName,
        'note': tx.note,
        'occurredAt': tx.occurredAt.toIso8601String(),
        'createdAt': tx.createdAt.toIso8601String(),
      };
    }).toList();

    return const JsonEncoder.withIndent('  ').convert(list);
  }
}
