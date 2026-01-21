import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/daos/transaction_dao.dart';
import '../models/statistics_period.dart';
import '../repository/database_repository.dart';

class StatisticsViewModel extends ChangeNotifier {
  final DatabaseRepository _repo;

  StatisticsPeriod period = StatisticsPeriod.month;
  DateTime current = DateTime.now();

  List<CategoryAmount> income = [];
  List<CategoryAmount> expense = [];

  double totalIncome = 0.0;
  double totalExpense = 0.0;

  double previousTotalIncome = 0.0;
  double previousTotalExpense = 0.0;

  StreamSubscription<List<CategoryAmount>>? _incomeSub;
  StreamSubscription<List<CategoryAmount>>? _expenseSub;

  StatisticsViewModel(this._repo) {
    _setupStreams();
  }

  void _setupStreams() {
    _incomeSub?.cancel();
    _expenseSub?.cancel();

    _incomeSub = _repo
        .statistics(period: period, type: 'income', reference: current)
        .listen((data) {
      income = data;
      totalIncome = _sum(data);
      notifyListeners();
    });

    _expenseSub = _repo
        .statistics(period: period, type: 'expense', reference: current)
        .listen((data) {
      expense = data;
      totalExpense = _sum(data);
      notifyListeners();
    });

    _loadPreviousTotals();
  }

  double _sum(List<CategoryAmount> list) {
    return list.fold(0.0, (sum, e) => sum + e.totalAmount);
  }

  Future<void> _loadPreviousTotals() async {
    final prevRef = _getPreviousReference(current);

    final prevIncomeList = await _repo
        .statistics(period: period, type: 'income', reference: prevRef)
        .first;

    final prevExpenseList = await _repo
        .statistics(period: period, type: 'expense', reference: prevRef)
        .first;

    previousTotalIncome = _sum(prevIncomeList);
    previousTotalExpense = _sum(prevExpenseList);

    notifyListeners();
  }

  void changePeriod(StatisticsPeriod value) {
    if (period == value) return;
    period = value;
    current = DateTime.now();
    _setupStreams();
  }

  void previous() {
    current = _getPreviousReference(current);
    _setupStreams();
  }

  void next() {
    current = _getNextReference(current);
    _setupStreams();
  }

  @override
  void dispose() {
    _incomeSub?.cancel();
    _expenseSub?.cancel();
    super.dispose();
  }

  (DateTime, DateTime) _getPeriodRange(DateTime ref) {
    switch (period) {
      case StatisticsPeriod.week:
        final monday = ref.subtract(Duration(days: ref.weekday - 1));
        return (monday, monday.add(const Duration(days: 7)));
      case StatisticsPeriod.month:
        return (DateTime(ref.year, ref.month), DateTime(ref.year, ref.month + 1));
      case StatisticsPeriod.year:
        return (DateTime(ref.year), DateTime(ref.year + 1));
    }
  }

  DateTime _getPreviousReference(DateTime ref) {
    switch (period) {
      case StatisticsPeriod.week:
        return ref.subtract(const Duration(days: 7));
      case StatisticsPeriod.month:
        return DateTime(ref.year, ref.month - 1, 15);
      case StatisticsPeriod.year:
        return DateTime(ref.year - 1, 6, 15);
    }
  }

  DateTime _getNextReference(DateTime ref) {
    switch (period) {
      case StatisticsPeriod.week:
        return ref.add(const Duration(days: 7));
      case StatisticsPeriod.month:
        return DateTime(ref.year, ref.month + 1, 15);
      case StatisticsPeriod.year:
        return DateTime(ref.year + 1, 6, 15);
    }
  }

  String get title {
    switch (period) {
      case StatisticsPeriod.week:
        final (s, e) = _getPeriodRange(current);
        return '${DateFormat('dd/MM').format(s)} - ${DateFormat('dd/MM/yyyy').format(e.subtract(const Duration(days: 1)))}';
      case StatisticsPeriod.month:
        return DateFormat('MMMM yyyy', 'vi').format(current);
      case StatisticsPeriod.year:
        return '${current.year}';
    }
  }

  String get expenseChangeText => _changeText(totalExpense, previousTotalExpense);
  String get incomeChangeText => _changeText(totalIncome, previousTotalIncome);

  String _changeText(double current, double previous) {
    if (previous == 0) return 'Không có so sánh';
    final percent = ((current - previous) / previous) * 100;
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(0)}% so với kỳ trước';
  }
}
