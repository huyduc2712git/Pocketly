import '../logger/app_logger.dart';

abstract class NotificationService {
  Future<void> initialize();
  Future<void> scheduleDailyReminder({required int hour, required int minute});
  Future<void> scheduleSubscriptionAlert({
    required String subscriptionId,
    required String subscriptionName,
    required double amount,
    required DateTime alertDate,
  });
  Future<void> cancelAlert(String id);
}

class NotificationServiceImpl implements NotificationService {
  @override
  Future<void> initialize() async {
    AppLogger.info('NotificationService: Initialized successfully');
  }

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    AppLogger.info(
      'NotificationService: Scheduled daily reminder at $hour:$minute',
    );
  }

  @override
  Future<void> scheduleSubscriptionAlert({
    required String subscriptionId,
    required String subscriptionName,
    required double amount,
    required DateTime alertDate,
  }) async {
    AppLogger.info(
      'NotificationService: Scheduled renewal alert for "$subscriptionName" ($amount ₫) on $alertDate',
    );
  }

  @override
  Future<void> cancelAlert(String id) async {
    AppLogger.info('NotificationService: Cancelled alert for $id');
  }
}
