import 'dart:async';

import 'package:flutter/material.dart';

import '../database/daos/transaction_dao.dart';
import '../models/statistics_period.dart';
import '../repository/database_repository.dart';


import 'package:intl/intl.dart';

class StatisticsViewModel extends ChangeNotifier {
  final DatabaseRepository _repo;

  StatisticsPeriod period = StatisticsPeriod.month;
  DateTime current = DateTime.now();

  List<CategoryAmount> income = [];
  List<CategoryAmount> expense = [];

  double totalIncome = 0.0;
  double totalExpense = 0.0;

  double previousTotalExpense = 0.0;
  double previousTotalIncome = 0.0;

  StatisticsViewModel(this._repo) {
    load();
  }

  Future<void> load() async {
    final (start, end) = _getPeriodRange(current);

    final (prevStart, prevEnd) = _getPeriodRange(_getPreviousReference(current));

    final currentExpense = await _repo.statistics(
      period: period,
      type: 'expense',
      reference: current,
    );
    final currentIncome = await _repo.statistics(
      period: period,
      type: 'income',
      reference: current,
    );

    final prevExpense = await _repo.statistics(
      period: period,
      type: 'expense',
      reference: _getPreviousReference(current),
    );
    final prevIncome = await _repo.statistics(
      period: period,
      type: 'income',
      reference: _getPreviousReference(current),
    );

    totalExpense = currentExpense.fold(0.0, (sum, ca) => sum + ca.totalAmount);
    totalIncome = currentIncome.fold(0.0, (sum, ca) => sum + ca.totalAmount);

    previousTotalExpense = prevExpense.fold(0.0, (sum, ca) => sum + ca.totalAmount);
    previousTotalIncome = prevIncome.fold(0.0, (sum, ca) => sum + ca.totalAmount);

    expense = currentExpense;
    income = currentIncome;

    notifyListeners();
  }

  void changePeriod(StatisticsPeriod value) {
    if (period != value) {
      period = value;
      current = DateTime.now();
      load();
    }
  }


  void previous() {
    current = _getPreviousReference(current);
    load();
  }

  void next() {
    current = _getNextReference(current);
    load();
  }


  (DateTime start, DateTime end) _getPeriodRange(DateTime ref) {
    switch (period) {
      case StatisticsPeriod.week:
        final start = ref.subtract(Duration(days: ref.weekday - 1));
        return (start, start.add(const Duration(days: 7)));
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
        return DateTime(ref.year, ref.month - 1);
      case StatisticsPeriod.year:
        return DateTime(ref.year - 1);
    }
  }

  DateTime _getNextReference(DateTime ref) {
    switch (period) {
      case StatisticsPeriod.week:
        return ref.add(const Duration(days: 7));
      case StatisticsPeriod.month:
        return DateTime(ref.year, ref.month + 1);
      case StatisticsPeriod.year:
        return DateTime(ref.year + 1);
    }
  }

  String get title {
    final f = DateFormat('MMMM yyyy', 'vi');
    switch (period) {
      case StatisticsPeriod.week:
        final start = _getPeriodRange(current).$1;
        final end = _getPeriodRange(current).$2.subtract(const Duration(days: 1));
        return '${DateFormat('dd/MM').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}';
      case StatisticsPeriod.month:
        return f.format(current);
      case StatisticsPeriod.year:
        return '${current.year}';
    }
  }

  String get expenseChangeText {
    if (previousTotalExpense == 0) return 'No change';
    final percent = ((totalExpense - previousTotalExpense) / previousTotalExpense) * 100;
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(0)}% vs kỳ trước';
  }

  String get incomeChangeText {
    if (previousTotalIncome == 0) return 'No change';
    final percent = ((totalIncome - previousTotalIncome) / previousTotalIncome) * 100;
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(0)}% vs kỳ trước';
  }
}