import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obescureText;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obescureText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 68,
            child: TextField(
              controller: controller,
              obscureText: obescureText,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 220, 218, 218)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 197, 190, 190)),
                  ),
                  filled: true,
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  fillColor: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
