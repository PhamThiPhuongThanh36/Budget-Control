import 'package:flutter/material.dart';

import '../database/daos/transaction_dao.dart';
import '../repository/database_repository.dart';

class TransactionsViewModel extends ChangeNotifier {
  final DatabaseRepository _repo;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double initialBalance = 0.0;

  double get totalBalance => initialBalance + totalIncome - totalExpense;

  List<TransactionWithCategory> transactions = [];

  bool get hasTransactions => transactions.isNotEmpty;
  bool get canEditInitialBalance => transactions.isEmpty;

  TransactionsViewModel(this._repo) {
    _init();
  }

  void _init() {
    _repo.totalIncome().listen((value) {
      totalIncome = value;
      notifyListeners();
    });

    _repo.totalExpense().listen((value) {
      totalExpense = value;
      notifyListeners();
    });

    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final all = await _repo.getAllTransactions();
    all.sort(
          (a, b) => b.transaction.createdAt.compareTo(a.transaction.createdAt),
    );
    transactions = all;
    notifyListeners();
  }

  Future<void> addTransaction(
      int? categoryId,
      double amount,
      String? note,
      String? type,
      ) async {
    final adjustedAmount = amount;

    await _repo.addTransaction(
      categoryId ?? 0,
      adjustedAmount,
      note,
    );
    await loadTransactions();
  }

  Future<List<TransactionWithCategory>> getRecentTransactions() async {
    final all = await _repo.getAllTransactions();
    all.sort((a, b) => b.transaction.createdAt.compareTo(a.transaction.createdAt));
    return all.take(10).toList();
  }
}