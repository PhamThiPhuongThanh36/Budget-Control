import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_control/widgets/custom_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  String phone = "";
  String password = "";
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: screenWidth,
                    height: screenHeight * 0.25,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF4263FB), Color(0xFFB5C8FF)]
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight * 0.12,
                          left: 20,
                          right: 20,
                          bottom: 20
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Đăng nhập",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Chào mừng trở lại Quản lý chi tiêu",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 30,
                      left: 40,
                      right: 40,
                      bottom: 20
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _phoneController,
                        label: "Số điện thoại",
                        hint: "Nhập số điện thoại",
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: _passwordController,
                        label: "Mật khẩu",
                        hint: "Nhập mật khẩu",
                        isPassword: true,
                        icon: Icons.remove_red_eye,
                      ),
                      SizedBox( height: 12,),
                      Center(
                        child: FilledButton(
                            onPressed: () {
                              context.go('/home');
                            },
                            style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF279BFF),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15))
                            ),
                            child: const Text (
                                "Đăng nhập"
                            )
                        ),
                      ),
                      SizedBox( height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Chưa có tài khoản? "),
                          GestureDetector(
                            onTap: () {
                              print("Chuyển sang màn đăng ký");
                            },
                            child: const Text(
                              "Đăng ký ngay",
                              style: TextStyle(
                                color: Color(0xFF003098),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ]
          )
      ),
    );
  }
}