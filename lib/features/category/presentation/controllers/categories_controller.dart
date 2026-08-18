import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CategoryRepositoryImpl(db: db);
});

final categoriesStreamProvider =
    StreamProvider.family<List<CategoryEntity>, String?>((ref, type) {
      final repository = ref.watch(categoryRepositoryProvider);
      return repository.watchCategories(type: type);
    });
