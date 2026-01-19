import 'package:flutter/material.dart';

import '../database/daos/transaction_dao.dart';
import '../repository/database_repository.dart';

class TransactionsViewModel extends ChangeNotifier {
  final DatabaseRepository _repo;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double initialBalance = 0.0;

  double get totalBalance => initialBalance + totalIncome - totalExpense;

  TransactionsViewModel(this._repo) {
    _repo.totalIncome().listen((value) {
      totalIncome = value;
      notifyListeners();
    });
    _repo.totalExpense().listen((value) {
      totalExpense = value;
      notifyListeners();
    });
  }

  Future<void> addTransaction(int? categoryId, double amount, String? note, String? type) async {
    final adjustedAmount = type == 'expense' ? -amount : amount;
    await _repo.addTransaction(categoryId ?? 0, adjustedAmount, note);
  }

  Future<List<TransactionWithCategory>> getRecentTransactions() async {
    final all = await _repo.getAllTransactions();
    all.sort((a, b) => b.transaction.createdAt.compareTo(a.transaction.createdAt));
    return all.take(10).toList();
  }

  Future<List<TransactionWithCategory>> getAllTransactions() async {
    final all = await _repo.getAllTransactions();
    all.sort((a, b) => b.transaction.createdAt.compareTo(a.transaction.createdAt));
    return all;
  }
}