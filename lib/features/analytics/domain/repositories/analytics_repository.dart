import '../../../../core/result/result.dart';
import '../entities/analytics_entity.dart';

abstract class AnalyticsRepository {
  Future<Result<AnalyticsSummary>> getAnalytics(AnalyticsPeriod period);
  Stream<AnalyticsSummary> watchAnalytics(AnalyticsPeriod period);
}
