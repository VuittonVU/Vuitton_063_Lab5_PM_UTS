import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, this.size = 320});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/logo1.png', height: size),
          Positioned(
            top: size * 0.18,
            child: Image.asset('assets/images/logo2.png', height: size * 0.34),
          ),
        ],
      ),
    );
  }
}
