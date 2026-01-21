import 'package:budget_control/widgets/custom_add_edit_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../repository/database_repository.dart';
import '../utils/vnd_formatter.dart';
import '../view_models/categories_viewmodel.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoriesViewModel>(
      create: (context) => CategoriesViewModel(
        context.read<DatabaseRepository>(),
      ),
      child: Consumer<CategoriesViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showCategoryDialog(context, vm);
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/ic_add.svg',
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFFFFFF),
                            BlendMode.srcIn,
                          ),
                          height: 20,
                          width: 20,
                        ),
                        label: const Text("Thêm danh mục mới"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFFFFF),
                          backgroundColor: const Color(0xFF2B8CEE),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: vm.categories.isEmpty
                          ? const Center(
                        child: Text(
                          'Chưa có danh mục nào',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                          : ListView.builder(
                        itemCount: vm.categories.length,
                        itemBuilder: (context, index) {
                          final category = vm.categories[index];
                          final isIncome = category.type == 'income';

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                isIncome ? Colors.green[100] : Colors.red[100],
                                child: Icon(
                                  isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: isIncome ? Colors.green[800] : Colors.red[800],
                                ),
                              ),
                              title: Text(
                                category.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                isIncome ? 'Thu nhập' : 'Chi tiêu',
                                style: TextStyle(
                                  color: isIncome ? Colors.green[700] : Colors.red[700],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      showCategoryDialog(context, vm, category: category);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Xác nhận xóa'),
                                          content: Text(
                                              'Bạn có chắc muốn xóa danh mục "${category.name}"?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Hủy'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        await vm.deleteCategory(category);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final transactions = await vm.getTransactionsForCategory(category.id);
                                if (!context.mounted) return;

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Giao dịch - ${category.name}'),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      height: 300,
                                      child: transactions.isEmpty
                                          ? const Center(child: Text('Chưa có giao dịch nào'))
                                          : ListView.builder(
                                        itemCount: transactions.length,
                                        itemBuilder: (context, i) {
                                          final tx = transactions[i].transaction;
                                          return ListTile(
                                            title: Text(
                                              // '${tx.amount.toStringAsFixed(0)} VNĐ',
                                              VndFormatter.format(tx.amount),
                                              style: TextStyle(
                                                color: isIncome ? Colors.green : Colors.red,
                                              ),
                                            ),
                                            subtitle: Text(tx.note ?? 'Không có ghi chú'),
                                            trailing: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  DateFormat('dd/MM/yyyy').format(tx.createdAt),
                                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                                ),
                                                Text(
                                                  DateFormat('HH:mm:ss').format(tx.createdAt),
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey[500],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Đóng'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}