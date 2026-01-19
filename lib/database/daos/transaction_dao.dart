import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/categoris_table.dart';
import '../tables/transactions.dart';
part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions, Categories])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  Future<List<TransactionWithCategory>> getAllTransactions() {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
    ]);
    return query.map((row) => TransactionWithCategory(
      transaction: row.readTable(transactions),
      category: row.readTable(categories),
    )).get();
  }

  Future<List<TransactionWithCategory>> getTransactionsByCategory(int categoryId) {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
    ])
      ..where(transactions.categoryId.equals(categoryId));
    return query.map((row) => TransactionWithCategory(
      transaction: row.readTable(transactions),
      category: row.readTable(categories),
    )).get();
  }

  Future<int> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }

  Stream<double> getTotalIncome() {
    final sum = transactions.amount.sum();
    final query = selectOnly(transactions)
      ..addColumns([sum])
      ..join([innerJoin(categories, categories.id.equalsExp(transactions.categoryId))])
      ..where(categories.type.equals('income'));
    return query.map((row) => row.read(sum) ?? 0.0).watchSingle();
  }

  Stream<double> getTotalExpense() {
    final sum = transactions.amount.sum();
    final query = selectOnly(transactions)
      ..addColumns([sum])
      ..join([innerJoin(categories, categories.id.equalsExp(transactions.categoryId))])
      ..where(categories.type.equals('expense'));
    return query.map((row) => row.read(sum) ?? 0.0).watchSingle();
  }

  Stream<List<CategoryAmount>> getIncomeStats() {
    return _getStatsByType('income');
  }

  Stream<List<CategoryAmount>> getExpenseStats() {
    return _getStatsByType('expense');
  }

  Stream<List<CategoryAmount>> _getStatsByType(String type) {
    final amountSum = transactions.amount.sum();
    final query = select(categories).join([
      innerJoin(transactions, transactions.categoryId.equalsExp(categories.id)),
    ])
      ..where(categories.type.equals(type))
      ..groupBy([categories.id])
      ..addColumns([amountSum]);
    return query.map((row) {
      final category = row.readTable(categories);
      final sum = row.read(amountSum) ?? 0.0;
      return CategoryAmount(category: category, totalAmount: sum);
    }).watch();
  }
}

class TransactionWithCategory {
  final Transaction transaction;
  final Category category;

  TransactionWithCategory({required this.transaction, required this.category});
}

class CategoryAmount {
  final Category category;
  final double totalAmount;

  CategoryAmount({required this.category, required this.totalAmount});
}