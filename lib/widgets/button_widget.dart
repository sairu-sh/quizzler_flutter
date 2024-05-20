import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? textColor;
  final Color? buttonColor;
  final bool isPressed;

  const Button(
      {super.key,
      required this.onPressed,
      required this.text,
      this.textColor = Colors.white,
      this.buttonColor = Colors.lightBlueAccent,
      required this.isPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        height: 50,
        width: 100,
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isPressed ? Colors.grey.shade200 : Colors.grey.shade300),
            boxShadow: isPressed
                ? []
                : [
                    BoxShadow(
                        color: Colors.grey.shade500,
                        blurRadius: 15,
                        spreadRadius: 1,
                        offset: const Offset(6, 6)),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-6, -6),
                      blurRadius: 15,
                      spreadRadius: 1,
                    )
                  ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
