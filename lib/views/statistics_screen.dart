import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/database_repository.dart';
import '../view_models/statistics_viewmodel.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  static final List<Color> chartColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.amber,
    Colors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          StatisticsViewModel(context.read<DatabaseRepository>()),
      child: Consumer<StatisticsViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFF68B2FF),
                      ),
                      child: Center(
                        child: Text(
                            'Thống kê',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFFFFFF)
                            )
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          _buildSection(
                            title: 'Thu nhập',
                            stats: vm.incomeStats,
                          ),
                          const SizedBox(height: 32),
                          _buildSection(
                            title: 'Chi tiêu',
                            stats: vm.expenseStats,
                          ),
                        ],
                      )
                  )
                ],
              ),
            )
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List stats,
  }) {
    if (stats.isEmpty) {
      return Text('$title: Không có dữ liệu');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 220,
              width: 220,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 0,
                  sectionsSpace: 2,
                  sections: List.generate(stats.length, (index) {
                    final stat = stats[index];
                    return PieChartSectionData(
                      value: stat.totalAmount,
                      color: chartColors[index % chartColors.length],
                      radius: 90,
                      title: '',
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(stats),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(List stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(stats.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6).copyWith(right: 30),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: chartColors[index % chartColors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                stats[index].category.name,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        );
      }),
    );
  }
}
