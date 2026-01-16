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
    );
  }
}