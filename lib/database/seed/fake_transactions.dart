import 'package:drift/drift.dart';
import '../database.dart';

Future<void> seedFakeData(AppDatabase db) async {
  print('Bắt đầu seed dữ liệu giao dịch giả...');

  final categories = await db.select(db.categories).get();

  final Map<String, int> catIds = {
    for (final c in categories) c.name.toLowerCase(): c.id,
  };

  void requireCat(String name) {
    if (!catIds.containsKey(name.toLowerCase())) {
      throw Exception('❌ Không tìm thấy category: $name');
    }
  }

  const requiredCategories = [
    'lương',
    'thu nhập ngoài',
    'thưởng',
    'nhà cửa',
    'xe cộ',
    'ăn uống',
    'bệnh tật',
    'quần áo',
    'con cái',
  ];

  for (final name in requiredCategories) {
    requireCat(name);
  }

  print('Đã load ${catIds.length} category từ DB');

  final now = DateTime.now();
  final fakeTx = <TransactionsCompanion>[];

  for (int i = 0; i < 8; i++) {
    final date = now.subtract(Duration(days: 7 + i));
    final catName = ['ăn uống', 'quần áo', 'con cái', 'xe cộ'][i % 4];
    final amount = 70000 + i * 20000;

    fakeTx.add(
      TransactionsCompanion(
        categoryId: Value(catIds[catName]!),
        amount: Value(amount.toDouble()),
        note: Value('Chi $catName'),
        createdAt: Value(date),
      ),
    );
  }

  for (int i = 0; i < 12; i++) {
    final date = now.subtract(Duration(days: 30 + i * 2));

    String cat;
    double amount;

    if (i == 0) {
      cat = 'lương';
      amount = 18000000;
    } else if (i == 4) {
      cat = 'thưởng';
      amount = 4000000;
    } else if (i % 3 == 0) {
      cat = 'nhà cửa';
      amount = 1200000 + i * 100000;
    } else {
      cat = 'ăn uống';
      amount = 150000 + i * 30000;
    }

    fakeTx.add(
      TransactionsCompanion(
        categoryId: Value(catIds[cat]!),
        amount: Value(amount),
        note: Value('Giao dịch $cat'),
        createdAt: Value(date),
      ),
    );
  }

  for (int i = 0; i < 10; i++) {
    final date = now.subtract(Duration(days: 365 + i * 20));

    final isIncome = i % 2 == 0;
    final cat = isIncome ? 'lương' : 'bệnh tật';
    final amount = isIncome ? 15000000 + i * 1000000 : 2000000 + i * 300000;

    fakeTx.add(
      TransactionsCompanion(
        categoryId: Value(catIds[cat]!),
        amount: Value(amount.toDouble()),
        note: Value('Năm trước $cat'),
        createdAt: Value(date),
      ),
    );
  }

  await db.batch((batch) {
    for (final tx in fakeTx) {
      batch.insert(
        db.transactions,
        tx,
        mode: InsertMode.insertOrIgnore,
      );
    }
  });

  print('Seed thành công ${fakeTx.length} giao dịch giả (tất cả amount DƯƠNG)');
}