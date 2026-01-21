  import 'package:drift/drift.dart';

  import '../database/daos/transaction_dao.dart';
  import '../database/database.dart';
  import '../models/statistics_period.dart';

  class DatabaseRepository {
    final AppDatabase _db;

    DatabaseRepository(this._db);

    Future<List<Category>> getAllCategories() => _db.categoryDao.getAllCategories();

    Future<List<Category>> getCategoriesByType(String type) => _db.categoryDao.getCategoriesByType(type);

    Future<int> addCategory(String name, String type) {
      return _db.categoryDao.insertCategory(CategoriesCompanion(name: Value(name), type: Value(type)));
    }

    Future updateCategory(Category category) => _db.categoryDao.updateCategory(category);

    Future deleteCategory(Category category) => _db.categoryDao.deleteCategory(category);

    Future<List<TransactionWithCategory>> getAllTransactions() => _db.transactionDao.getAllTransactions();

    Future<List<TransactionWithCategory>> getTransactionsByCategory(int categoryId) =>
        _db.transactionDao.getTransactionsByCategory(categoryId);

    Future<int> addTransaction(int categoryId, double amount, String? note) {
      return _db.transactionDao.insertTransaction(TransactionsCompanion(
        categoryId: Value(categoryId),
        amount: Value(amount),
        note: Value(note),
        createdAt: Value(DateTime.now()),
      ));
    }

    Stream<double> totalIncome() =>
        _db.transactionDao.totalByType('income');

    Stream<double> totalExpense() =>
        _db.transactionDao.totalByType('expense');

    Future<List<CategoryAmount>> statistics({
      required StatisticsPeriod period,
      required String type,
      required DateTime reference,
    }) {
      late DateTime start;
      late DateTime end;

      switch (period) {
        case StatisticsPeriod.week:
          start = reference.subtract(
            Duration(days: reference.weekday - 1),
          );
          end = start.add(const Duration(days: 7));
          break;

        case StatisticsPeriod.month:
          start = DateTime(reference.year, reference.month);
          end = DateTime(reference.year, reference.month + 1);
          break;

        case StatisticsPeriod.year:
          start = DateTime(reference.year);
          end = DateTime(reference.year + 1);
          break;
      }

      return _db.transactionDao.statsByPeriod(
        type: type,
        start: start,
        end: end,
      );
    }
  }