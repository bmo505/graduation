import 'package:flutter/material.dart';

class SplashImage extends StatefulWidget {
  const SplashImage({super.key});

  @override
  _SplashImageState createState() => _SplashImageState();
}

class _SplashImageState extends State<SplashImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(begin: 0.5, end: 4.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * 3.14).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    ));

    _shakeAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: FractionalTranslation(
              translation: _shakeAnimation.value,
              child: Image.asset(
                'assets/5800700504500717591-removebg-preview.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
