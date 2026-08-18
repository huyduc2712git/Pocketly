import '../../../../core/result/result.dart';
import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Stream<List<CategoryEntity>> watchCategories({String? type});
  Future<Result<List<CategoryEntity>>> getCategories({String? type});
  Future<Result<CategoryEntity>> getCategoryById(String id);
  Future<Result<CategoryEntity>> createCategory(CategoryEntity category);
  Future<Result<CategoryEntity>> updateCategory(CategoryEntity category);
  Future<Result<void>> deleteCategory(String id);
}
