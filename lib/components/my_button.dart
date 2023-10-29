import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color boxColor;
  final Color textColor;

  final Function()? onTap;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.boxColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(20),
          width: 350,
          // height: 50,
          // margin: EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: boxColor, borderRadius: BorderRadius.circular(44)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ],
          )),
    );
  }
}
