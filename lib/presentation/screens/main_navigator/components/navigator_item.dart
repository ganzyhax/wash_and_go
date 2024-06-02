import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  final IconData assetImage;
  final bool isSelected;
  const NavigationItem({
    super.key,
    required this.assetImage,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, right: 10, left: 10),
      margin: EdgeInsets.only(
        top: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: (isSelected == true) ? Colors.deepPurpleAccent : Colors.white),
      child: Center(
        child: Icon(
          assetImage,
          color: (isSelected == true) ? Colors.white : Colors.grey,
          size: 25,
        ),
      ),
    );
  }
}
