import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/repositories/analytics_repository_impl.dart';
import '../../domain/entities/analytics_entity.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../domain/usecases/get_analytics_usecase.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AnalyticsRepositoryImpl(db: db);
});

final getAnalyticsUseCaseProvider = Provider<GetAnalyticsUseCase>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  return GetAnalyticsUseCase(repository);
});

final selectedAnalyticsPeriodProvider = StateProvider<AnalyticsPeriod>((ref) {
  return AnalyticsPeriod.thisMonth;
});

final analyticsStreamProvider = StreamProvider<AnalyticsSummary>((ref) {
  final useCase = ref.watch(getAnalyticsUseCaseProvider);
  final period = ref.watch(selectedAnalyticsPeriodProvider);
  return useCase.watch(period);
});
