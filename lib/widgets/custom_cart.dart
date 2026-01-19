import 'package:flutter/material.dart';
class CustomCart extends StatefulWidget{
  final Widget icon;
  final Color color;
  final String title;
  final String subtitle;

  const CustomCart({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  State<CustomCart> createState() => _CustomCartState();
}

class _CustomCartState extends State<CustomCart> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.4,
      height: screenHeight * 0.15,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF959595), width: 2)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Center(
              child: widget.icon,
            ),
          ),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Color(0xFF53789E)),
          ),
          SizedBox(height: 8),
          Text(
            widget.subtitle,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(color: widget.color, fontSize: 15),
          )
        ]
      ),
    );
  }
}