import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../database/daos/transaction_dao.dart';
import '../database/database.dart';
import '../repository/database_repository.dart';
import '../utils/vnd_formatter.dart';
import '../view_models/categories_viewmodel.dart';
import '../view_models/transactions_viewmodel.dart';
import '../widgets/custom_cart.dart';

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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
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
                          subtitle: "+ ${txVm.totalIncome.toStringAsFixed(0)}",
                        ),
                        CustomCart(
                          icon: SvgPicture.asset(
                            'assets/icons/ic_down.svg',
                            colorFilter: const ColorFilter.mode(Color(0xFFE11E49), BlendMode.srcIn),
                          ),
                          color: const Color(0xFFE11E49),
                          title: "CHI TIÊU",
                          subtitle: "- ${txVm.totalExpense.toStringAsFixed(0)}",
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
                        Text(
                          "Xem thêm",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFF2B8CEE)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    FutureBuilder<List<TransactionWithCategory>>(
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
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recent.length > 5 ? 5 : recent.length,
                          itemBuilder: (context, index) {
                            final item = recent[index];
                            final tx = item.transaction;
                            final cat = item.category;
                            final isIncome = tx.amount > 0;

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isIncome ? Colors.green[100] : Colors.red[100],
                                  child: Icon(
                                    isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                                    color: isIncome ? Colors.green[800] : Colors.red[800],
                                  ),
                                ),
                                title: Text(
                                  '${tx.amount.toStringAsFixed(0)} VNĐ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isIncome ? Colors.green[800] : Colors.red[800],
                                  ),
                                ),
                                subtitle: Text('${cat.name} • ${tx.note ?? 'Không ghi chú'}'),
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
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showAddTransactionSheet(context, txVm, Provider.of<CategoriesViewModel>(context, listen: false));
              },
              child: const Icon(Icons.add), ),
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
                          amountController.text.replaceAll(' ', ''),
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
              final newBalance = double.tryParse(controller.text.replaceAll(',', '')) ?? 0.0;
              txVm.setInitialBalance(newBalance);
              Navigator.pop(context);
            },
            child: const Text('Lưu', style: TextStyle(color: Color(0xFF2B8CEE))),
          ),
        ],
      ),
    );
  }
}