import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  void _goToBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: navigationShell.currentIndex,
        onTap: _goToBranch,
        selectedItemColor: const Color(0xFFF9771C),
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/ic_home.svg',
                width: 28,
                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/ic_home.svg',
                width: 28,
                colorFilter: const ColorFilter.mode(Color(0xFFF9771C), BlendMode.srcIn),
              ),
              label: 'Trang chủ'
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/ic_chart.svg',
                width: 24,
                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/ic_chart.svg',
                width: 24,
                colorFilter: const ColorFilter.mode(Color(0xFFF9771C), BlendMode.srcIn),
              ),
              label: 'Thống kê'
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/ic_category.svg',
                width: 24,
                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/ic_category.svg',
                width: 24,
                colorFilter: const ColorFilter.mode(Color(0xFFF9771C), BlendMode.srcIn),
              ),
              label: 'Danh mục'
          ),
        ],
      ),
    );
  }
}