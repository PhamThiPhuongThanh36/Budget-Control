import 'package:budget_control/repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'core/app_route.dart';
import 'database/database.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'database/seed/fake_transactions.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final db = AppDatabase();

  try {
    print('Đang seed dữ liệu giả...');
    // await db.delete(db.transactions).go();
    // await seedFakeData(db);
    print('Seed fake data hoàn tất.');
  } catch (e, stack) {
    print('LỖI KHI SEED FAKE DATA: $e');
    print('Stack trace: $stack');
  }

  runApp(
    Provider<DatabaseRepository>(
      create: (_) => DatabaseRepository(db),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            fontSize: 16,
          ),
        )
      ),
      routerConfig: AppRouter.router,
    );
  }
}