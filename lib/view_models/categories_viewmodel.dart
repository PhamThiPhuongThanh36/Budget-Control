import 'package:flutter/material.dart';

import '../database/daos/transaction_dao.dart';
import '../database/database.dart';
import '../repository/database_repository.dart';

class CategoriesViewModel extends ChangeNotifier {
  final DatabaseRepository _repo;
  List<Category> categories = [];

  CategoriesViewModel(this._repo) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    categories = await _repo.getAllCategories();
    notifyListeners();
  }

  Future<void> addCategory(String name, String type) async {
    await _repo.addCategory(name, type);
    loadCategories();
  }

  Future<void> updateCategory(Category updatedCategory) async {
    await _repo.updateCategory(updatedCategory);
    await loadCategories();
  }

  Future<void> deleteCategory(Category category) async {
    await _repo.deleteCategory(category);
    loadCategories();
  }

  Future<List<TransactionWithCategory>> getTransactionsForCategory(int categoryId) async {
    return _repo.getTransactionsByCategory(categoryId);
  }
}