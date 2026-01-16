import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_control/widgets/custom_cart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      context.go('/login');
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/images/person.png"),
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/icons/full_ring.svg",
                    height: 25,
                    width: 25,
                  )
                ],
              ),
              SizedBox(height: 48),
              Text(
                "TỔNG TIỀN",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                "9.000.000 VNĐ",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCart(
                      icon: SvgPicture.asset(
                        'assets/icons/ic_up.svg',
                        colorFilter: ColorFilter.mode(Color(0xFF059669), BlendMode.srcIn),
                      ),
                      color: Color(0xFF059669),
                      title: "THU NHẬP",
                      subtitle: "+ 4.000.000"
                  ),
                  CustomCart(
                      icon: SvgPicture.asset(
                        'assets/icons/ic_down.svg',
                        colorFilter: ColorFilter.mode(Color(0xFFE11E49), BlendMode.srcIn),
                      ),
                      color: Color(0xFFE11E49),
                      title: "CHI TIÊU",
                      subtitle: "- 1.900.000"
                  )
                ],
              ),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Giao dịch gần đây",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Text(
                    "Xem thêm",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Color(0xFF2B8CEE)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransactionSheet(context);
        },
        child: Icon(Icons.add),
      )
    );
  }
}

void _showAddTransactionSheet(BuildContext context) {
  int selectedIndex = 0;
  showModalBottomSheet(
    context: context,
    backgroundColor: Color(0xFFFFFFFF),
    isScrollControlled: true, // Quan trọng: Giúp sheet không bị bàn phím che mất
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setSheetState) {
        return Padding(
          // Padding này giúp đẩy sheet lên trên khi bàn phím xuất hiện
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Sheet chỉ cao vừa đủ nội dung
            children: [
              const Text('Thêm Giao Dịch Mới', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                color: Color(0xFFF1F5F9),
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildTypeButton(
                        label: "Thu nhập",
                        index: 0,
                        selectedIndex: selectedIndex,
                        onPressed: () => setSheetState(() => selectedIndex = 0),
                        ),
                    ),
                    Expanded(
                      child: _buildTypeButton(
                        label: "Chi tiêu",
                        index: 1,
                        selectedIndex: selectedIndex,
                        onPressed: () => setSheetState(() => selectedIndex = 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Số tiền',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF838383), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF838383), width: 2), // Màu xanh nổi bật
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Danh mục",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16,
              ),
              SizedBox(
                width: double.infinity, // Ép nút tràn hết chiều rộng
                height: 50, // Độ cao của nút
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF427EBA), // Màu xanh bạn thích
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Lưu giao dịch', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      });
    },
  );
}

Widget _buildTypeButton({
  required String label,
  required int index,
  required int selectedIndex,
  required VoidCallback onPressed,
}) {
  bool isSelected = selectedIndex == index;

  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? const Color(0xFFFFFFFF) : Colors.transparent,
      foregroundColor: isSelected ? Colors.red : Colors.blueGrey,
      splashFactory: NoSplash.splashFactory,
      elevation: 0,
      shadowColor: Colors.transparent,
      minimumSize: const Size(double.infinity, 45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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