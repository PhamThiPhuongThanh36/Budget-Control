import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/categoris_table.dart';
import '../tables/transactions.dart';
part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions, Categories])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  Expression<bool> _betweenDate(
      DateTimeColumn column,
      DateTime start,
      DateTime end,
      ) {
    return column.isBiggerOrEqualValue(start) &
    column.isSmallerThanValue(end);
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

  Future<List<TransactionWithCategory>> getAllTransactions() {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
    ]);

    return query.map((row) {
      return TransactionWithCategory(
        transaction: row.readTable(transactions),
        category: row.readTable(categories),
      );
    }).get();
  }

  Future<int> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }

  Stream<double> totalByType(String type) {
    final sumAmount = transactions.amount.sum();

    final query = selectOnly(transactions)
      ..addColumns([sumAmount])
      ..join([
        innerJoin(categories,
            categories.id.equalsExp(transactions.categoryId)),
      ])
      ..where(categories.type.equals(type));

    return query.map((row) => row.read(sumAmount) ?? 0.0).watchSingle();
  }

  Stream<List<CategoryAmount>> statsByPeriod({
    required String type,
    required DateTime start,
    required DateTime end,
  }) {
    final sumAmount = transactions.amount.sum();

    final query = select(categories).join([
      innerJoin(transactions, transactions.categoryId.equalsExp(categories.id)),
    ])
      ..where(categories.type.equals(type))
      ..where(_betweenDate(transactions.createdAt, start, end))
      ..groupBy([categories.id])
      ..addColumns([sumAmount]);

    return query.map((row) {
      return CategoryAmount(
        category: row.readTable(categories),
        totalAmount: (row.read(sumAmount) ?? 0).abs(),
      );
    }).watch();
  }

  Stream<double> totalIncome() {
    final query = customSelect(
      '''
      SELECT COALESCE(SUM(t.amount), 0) AS total
      FROM transactions t
      JOIN categories c ON c.id = t.category_id
      WHERE c.type = 'income'
      ''',
      readsFrom: {transactions, categories},
    );

    return query.watch().map((row) => row.first.read<double>('total'));
  }

  Stream<double> totalExpense() {
    final query = customSelect(
      '''
      SELECT COALESCE(SUM(t.amount), 0) AS total
      FROM transactions t
      JOIN categories c ON c.id = t.category_id
      WHERE c.type = 'expense'
      ''',
      readsFrom: {transactions, categories},
    );

    return query.watch().map((row) => row.first.read<double>('total'));
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

  const CategoryAmount({
    required this.category,
    required this.totalAmount,
  });
}

