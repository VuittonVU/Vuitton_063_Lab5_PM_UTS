import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final double size;

  const BackButtonWidget({
    super.key,
    required this.onPressed,
    this.color = Colors.black,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: color,
        size: size,
      ),
      onPressed: onPressed,
    );
  }
}
