import 'package:drift/drift.dart';
import '../database.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(AppDatabase db) : super(db);

  Future<List<Category>> getAllCategories() => select(categories).get();

  Future<List<Category>> getCategoriesByType(String type) {
    return (select(categories)..where((c) => c.type.equals(type))).get();
  }

  Future<int> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  Future updateCategory(Category category) {
    return update(categories).replace(category);
  }

  Future deleteCategory(Category category) {
    return delete(categories).delete(category);
  }
}