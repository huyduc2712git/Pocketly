import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase db;

  CategoryRepositoryImpl({required this.db});

  CategoryEntity _toEntity(CategoryRow row) {
    return CategoryEntity(
      id: row.id,
      name: row.name,
      type: row.type,
      icon: row.icon,
      color: row.color,
      parentId: row.parentId,
      isSystem: row.isSystem,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  @override
  Stream<List<CategoryEntity>> watchCategories({String? type}) {
    final query = db.select(db.categoriesTable);
    if (type != null) {
      query.where((tbl) => tbl.type.equals(type));
    }
    query.orderBy([(t) => OrderingTerm(expression: t.name)]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<Result<List<CategoryEntity>>> getCategories({String? type}) async {
    try {
      final query = db.select(db.categoriesTable);
      if (type != null) {
        query.where((tbl) => tbl.type.equals(type));
      }
      query.orderBy([(t) => OrderingTerm(expression: t.name)]);
      final rows = await query.get();
      return Result.success(rows.map(_toEntity).toList());
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<CategoryEntity>> getCategoryById(String id) async {
    try {
      final row = await (db.select(db.categoriesTable)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();
      if (row == null) {
        return const Result.failure(DatabaseFailure(message: 'Không tìm thấy danh mục'));
      }
      return Result.success(_toEntity(row));
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<CategoryEntity>> createCategory(CategoryEntity category) async {
    try {
      final now = DateTime.now();
      final id = category.id.isNotEmpty ? category.id : IdGenerator.generate();
      final companion = CategoriesTableCompanion.insert(
        id: id,
        name: category.name,
        type: category.type,
        icon: category.icon,
        color: category.color,
        parentId: Value(category.parentId),
        isSystem: Value(category.isSystem),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await db.into(db.categoriesTable).insert(companion);
      return Result.success(category.copyWith(id: id, createdAt: now, updatedAt: now));
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<CategoryEntity>> updateCategory(CategoryEntity category) async {
    try {
      final now = DateTime.now();
      await (db.update(db.categoriesTable)..where((tbl) => tbl.id.equals(category.id))).write(
        CategoriesTableCompanion(
          name: Value(category.name),
          type: Value(category.type),
          icon: Value(category.icon),
          color: Value(category.color),
          parentId: Value(category.parentId),
          updatedAt: Value(now),
        ),
      );
      return Result.success(category.copyWith(updatedAt: now));
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> deleteCategory(String id) async {
    try {
      await (db.delete(db.categoriesTable)..where((tbl) => tbl.id.equals(id))).go();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }
}
