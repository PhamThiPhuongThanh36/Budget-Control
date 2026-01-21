import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../database/database.dart';
import '../view_models/categories_viewmodel.dart';

void showCategoryDialog(
    BuildContext context,
    CategoriesViewModel vm,
    {Category? category} ) {
  final isEdit = category != null;
  final nameController = TextEditingController(text: isEdit ? category.name : '');
  int selectedIndex = isEdit ? (category.type == 'income' ? 0 : 1) : 0;

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
                height: 65,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF427EBA),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit ? 'Sửa danh mục' : 'Thêm danh mục mới',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: SvgPicture.asset(
                        'assets/icons/ic_close.svg',
                        width: 20,
                        height: 20,
                        colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Nhập tên danh mục",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (!isEdit) ...[
                      const Text(
                        "Loại giao dịch",
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTypeButton(
                                label: "Thu nhập",
                                index: 0,
                                selectedIndex: selectedIndex,
                                onPressed: () =>
                                    setState(() => selectedIndex = 0),
                              ),
                            ),
                            Expanded(
                              child: _buildTypeButton(
                                label: "Chi tiêu",
                                index: 1,
                                selectedIndex: selectedIndex,
                                onPressed: () =>
                                    setState(() => selectedIndex = 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = nameController.text.trim();
                          if (name.isEmpty) return;

                          final type =
                          selectedIndex == 0 ? 'income' : 'expense';

                          if (isEdit) {
                            await vm.updateCategory(
                              category!.copyWith(name: name, type: type),
                            );
                          } else {
                            await vm.addCategory(name, type);
                          }

                          if (context.mounted) {
                            Navigator.pop(dialogContext);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B8CEE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isEdit ? "Cập nhật" : "Lưu",
                          style: const TextStyle(color: Colors.white),
                        ),
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