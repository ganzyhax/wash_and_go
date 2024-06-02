import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function() function;
  final bool? isLoading;
  final bool? isActive;
  const CustomButton(
      {super.key,
      required this.function,
      required this.title,
      this.isActive = true,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (isLoading == false && isActive == true) ? function : null,
        child: Container(
          child: Center(
            child: (isLoading == true)
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                : Text(
                    title,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),
          decoration: BoxDecoration(
              color: (isActive == true)
                  ? Colors.deepPurple
                  : Colors.deepPurple.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.only(top: 15, bottom: 15, right: 20, left: 20),
        ));
  }
}
