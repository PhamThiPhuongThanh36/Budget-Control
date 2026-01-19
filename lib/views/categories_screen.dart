import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showDialogAddCategory(context, vm);
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
                                      _showDialogEditCategory(context, vm, category);
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

  void _showDialogAddCategory(BuildContext context, CategoriesViewModel vm) {
    final nameController = TextEditingController();
    int selectedIndex = 0;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  height: 65,
                  decoration: const BoxDecoration(
                    color: Color(0xFF427EBA),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thêm danh mục mới',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: 18, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(dialogContext),
                        child: SvgPicture.asset(
                          'assets/icons/ic_close.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tên danh mục",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Nhập tên danh mục",
                          hintStyle: const TextStyle(color: Color(0xFF838383)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF838383), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF2B8CEE), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        "Loại giao dịch",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTypeButton(
                                label: "Thu nhập",
                                index: 0,
                                selectedIndex: selectedIndex,
                                onPressed: () => setState(() => selectedIndex = 0),
                              ),
                            ),
                            Expanded(
                              child: _buildTypeButton(
                                label: "Chi tiêu",
                                index: 1,
                                selectedIndex: selectedIndex,
                                onPressed: () => setState(() => selectedIndex = 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final name = nameController.text.trim();
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Vui lòng nhập tên danh mục')),
                              );
                              return;
                            }

                            final type = selectedIndex == 0 ? 'income' : 'expense';
                            await vm.addCategory(name, type);
                            if (context.mounted) Navigator.pop(dialogContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B8CEE),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Lưu", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDialogEditCategory(BuildContext context, CategoriesViewModel vm, Category category) {
    final nameController = TextEditingController(text: category.name);
    int selectedIndex = category.type == 'income' ? 0 : 1;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  height: 65,
                  decoration: const BoxDecoration(
                    color: Color(0xFF427EBA),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sửa danh mục',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: 18, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(dialogContext),
                        child: SvgPicture.asset(
                          'assets/icons/ic_close.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tên danh mục", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Nhập tên danh mục",
                          hintStyle: const TextStyle(color: Color(0xFF838383)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF838383), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF2B8CEE), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text("Loại giao dịch", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTypeButton(
                                label: "Thu nhập",
                                index: 0,
                                selectedIndex: selectedIndex,
                                onPressed: () => setState(() => selectedIndex = 0),
                              ),
                            ),
                            Expanded(
                              child: _buildTypeButton(
                                label: "Chi tiêu",
                                index: 1,
                                selectedIndex: selectedIndex,
                                onPressed: () => setState(() => selectedIndex = 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final newName = nameController.text.trim();
                            if (newName.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tên danh mục không được để trống')),
                              );
                              return;
                            }

                            final newType = selectedIndex == 0 ? 'income' : 'expense';
                            final updatedCategory = category.copyWith(
                              name: newName,
                              type: newType,
                            );

                            await vm.updateCategory(updatedCategory);
                            if (context.mounted) Navigator.pop(dialogContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B8CEE),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Cập nhật", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required int index,
    required int selectedIndex,
    required VoidCallback onPressed,
  }) {
    final isSelected = selectedIndex == index;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFFFFFFFF) : Colors.transparent,
        foregroundColor: isSelected ? const Color(0xFFE11E49) : Colors.blueGrey,
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ).copyWith(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}