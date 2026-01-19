import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../database/daos/transaction_dao.dart';
import '../database/database.dart';
import '../repository/database_repository.dart';
import '../utils/vnd_formatter.dart';
import '../view_models/categories_viewmodel.dart';
import '../view_models/transactions_viewmodel.dart';
import '../widgets/custom_cart.dart';
import '../widgets/custom_transaction.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider<TransactionsViewModel>(
          create: (context) =>
              TransactionsViewModel(context.read<DatabaseRepository>()),
        ),
        ChangeNotifierProvider<CategoriesViewModel>(
          create: (context) =>
              CategoriesViewModel(context.read<DatabaseRepository>()),
        ),
      ],
      child: Consumer<TransactionsViewModel>(
        builder: (context, txVm, child) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.go('/login');
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage("assets/images/person.png"),
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/icons/full_ring.svg",
                          height: 25,
                          width: 25,
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    GestureDetector(
                      onTap: () => _showEditInitialBalanceDialog(context, txVm),
                      child: Column(
                        children: [
                          Text(
                            "TỔNG TIỀN",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            VndFormatter.format(txVm.totalBalance),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: txVm.totalBalance >= 0
                                  ? Colors.green[800]
                                  : Colors.red[800],
                            ),
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomCart(
                          icon: SvgPicture.asset(
                            'assets/icons/ic_up.svg',
                            colorFilter: const ColorFilter.mode(Color(0xFF059669), BlendMode.srcIn),
                          ),
                          color: const Color(0xFF059669),
                          title: "THU NHẬP",
                          subtitle: "+ ${VndFormatter.format(txVm.totalIncome)}",
                        ),
                        CustomCart(
                          icon: SvgPicture.asset(
                            'assets/icons/ic_down.svg',
                            colorFilter: const ColorFilter.mode(Color(0xFFE11E49), BlendMode.srcIn),
                          ),
                          color: const Color(0xFFE11E49),
                          title: "CHI TIÊU",
                          subtitle: "- ${VndFormatter.format(txVm.totalExpense)}",
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Giao dịch gần đây",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/transactions_history'),
                          child: Text(
                            "Xem tất cả",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith()
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: FutureBuilder<List<TransactionWithCategory>>(
                        future: txVm.getRecentTransactions(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('Chưa có giao dịch nào', style: TextStyle(color: Colors.grey)),
                            );
                          }

                          final recent = snapshot.data!;
                          return ListView.builder(
                            itemCount: recent.length > 10 ? 10 : recent.length,
                            itemBuilder: (context, index) {
                              final item = recent[index];
                              final tx = item.transaction;
                              final cat = item.category;
                              final isIncome = cat.type == 'income';

                              return CustomTransaction(
                                icon: isIncome ? SvgPicture.asset('assets/icons/ic_up.svg') : SvgPicture.asset('assets/icons/ic_down.svg'),
                                color: isIncome ? Colors.green : Colors.red,
                                title: VndFormatter.format(tx.amount),
                                subtitle: tx.note?.isNotEmpty == true
                                    ? '${cat.name} • ${tx.note}'
                                    : cat.name,
                                date: DateFormat('dd/MM/yyyy').format(tx.createdAt),
                                time: DateFormat('HH:mm').format(tx.createdAt),
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFFFFFFFF),
              onPressed: () {
                _showAddTransactionSheet(context, txVm, Provider.of<CategoriesViewModel>(context, listen: false));
              },
              child: const Icon(
                Icons.add,
              )
            ),
          );
        },
      ),
    );
  }

  void _showAddTransactionSheet(
      BuildContext context,
      TransactionsViewModel txVm,
      CategoriesViewModel catVm,
      ) {
    String type = 'income';
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    Category? selectedCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thêm giao dịch mới',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Danh mục',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder(
                    future: catVm.loadCategories(),
                    builder: (context, snapshot) {
                      if (catVm.categories.isEmpty) {
                        return const Text('Chưa có danh mục nào. Vui lòng thêm ở tab Danh mục.');
                      }
                      return DropdownButtonFormField<Category>(
                        value: selectedCategory,
                        hint: const Text('Chọn danh mục'),
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        items: catVm.categories.map((cat) {
                          final isIncomeCat = cat.type == 'income';
                          return DropdownMenuItem<Category>(
                            value: cat,
                            child: Row(
                              children: [
                                Icon(
                                  isIncomeCat ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: isIncomeCat ? Colors.green : Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(cat.name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => setModalState(() => selectedCategory = value),
                      );
                    },
                  ),

                  SizedBox(height: 16),

                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Số tiền (VNĐ)',
                      suffixText: 'VNĐ ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      VndInputFormatter(),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      labelText: 'Ghi chú',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () async {
                        double amount = double.parse(
                          amountController.text.replaceAll('.', ''),
                        );
                        if (amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Số tiền phải lớn hơn 0')),
                          );
                          return;
                        }
                        if (selectedCategory == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng chọn danh mục')),
                          );
                          return;
                        }

                        await txVm.addTransaction(
                          selectedCategory!.id,
                          amount,
                          noteController.text.trim().isEmpty ? null : noteController.text.trim(),
                          type,
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã thêm giao dịch thành công')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B8CEE),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Lưu giao dịch', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditInitialBalanceDialog(BuildContext context, TransactionsViewModel txVm) {
    final controller = TextEditingController(
      text: txVm.initialBalance.toStringAsFixed(0),
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa số dư'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Số dư',
            suffixText: 'VNĐ ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              final newBalance = double.tryParse(controller.text.replaceAll('.', '')) ?? 0.0;
              // txVm.setInitialBalance(newBalance);
              txVm.addTransaction(null, newBalance, null, null);
              Navigator.pop(context);
            },
            child: const Text('Lưu', style: TextStyle(color: Color(0xFF2B8CEE))),
          ),
        ],
      ),
    );
  }
}