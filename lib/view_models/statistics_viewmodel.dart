import 'package:flutter/material.dart';

import '../database/daos/transaction_dao.dart';
import '../repository/database_repository.dart';

class StatisticsViewModel extends ChangeNotifier {
  final DatabaseRepository _repo;
  List<CategoryAmount> incomeStats = [];
  List<CategoryAmount> expenseStats = [];

  StatisticsViewModel(this._repo) {
    _repo.incomeStats().listen((stats) {
      incomeStats = stats;
      notifyListeners();
    });
    _repo.expenseStats().listen((stats) {
      expenseStats = stats;
      notifyListeners();
    });
  }
}