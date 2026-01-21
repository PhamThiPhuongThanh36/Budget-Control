import 'package:budget_control/widgets/custom_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../repository/database_repository.dart';
import '../utils/vnd_formatter.dart';
import '../view_models/categories_viewmodel.dart';
import '../view_models/transactions_viewmodel.dart';

class TransactionsHistoryScreen extends StatelessWidget{
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
            child: Column(
              children: [
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: IconButton(
                          onPressed: () => context.pop(),
                          icon: SvgPicture.asset(
                            'assets/icons/ic_back.svg',
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Lịch sử giao dịch',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: txVm.transactions.isEmpty
                      ? const Center(
                    child: Text('Chưa có giao dịch nào'),
                  )
                      : ListView.builder(
                    itemCount: txVm.transactions.length,
                    itemBuilder: (context, index) {
                      final item = txVm.transactions[index];
                      final tx = item.transaction;
                      final cat = item.category;
                      final isIncome = cat.type == 'income';

                      return CustomTransaction(
                        icon: isIncome
                            ? SvgPicture.asset('assets/icons/ic_up.svg')
                            : SvgPicture.asset('assets/icons/ic_down.svg'),
                        color: isIncome ? Colors.green : Colors.red,
                        title: VndFormatter.format(tx.amount),
                        subtitle: tx.note?.isNotEmpty == true
                            ? '${cat.name} • ${tx.note}'
                            : cat.name,
                        date: DateFormat('dd/MM/yyyy').format(tx.createdAt),
                        time: DateFormat('HH:mm').format(tx.createdAt),
                      );
                    },
                  ),
                )

              ],
            ),
          )
        );
      }),
  );
  }
}