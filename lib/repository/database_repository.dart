import 'package:drift/drift.dart';

import '../database/daos/transaction_dao.dart';
import '../database/database.dart';

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

  Stream<double> totalIncome() => _db.transactionDao.getTotalIncome();

  Stream<double> totalExpense() => _db.transactionDao.getTotalExpense();

  Stream<List<CategoryAmount>> incomeStats() => _db.transactionDao.getIncomeStats();

  Stream<List<CategoryAmount>> expenseStats() => _db.transactionDao.getExpenseStats();
}