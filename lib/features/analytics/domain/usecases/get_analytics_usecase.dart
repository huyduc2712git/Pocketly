import '../../../../core/result/result.dart';
import '../entities/analytics_entity.dart';
import '../repositories/analytics_repository.dart';

class GetAnalyticsUseCase {
  final AnalyticsRepository _repository;

  const GetAnalyticsUseCase(this._repository);

  Stream<AnalyticsSummary> watch(AnalyticsPeriod period) {
    return _repository.watchAnalytics(period);
  }

  Future<Result<AnalyticsSummary>> call(AnalyticsPeriod period) {
    return _repository.getAnalytics(period);
  }
}
