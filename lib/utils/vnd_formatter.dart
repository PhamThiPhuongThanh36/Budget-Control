import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class VndFormatter {
  static final NumberFormat _formatter =
  NumberFormat.decimalPattern('vi_VN');

  static String format(num value) {
    return '${_formatter.format(value)} VNĐ';
  }

  static double parse(String text) {
    return double.parse(
      text.replaceAll('.', '').replaceAll(' VNĐ', ''),
    );
  }
}

class VndInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final number = int.parse(digitsOnly);
    final newText = VndFormatter._formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
