import 'package:flutter/material.dart';

Route createRoute({
  required Widget page,
  Offset beginOffset = const Offset(1.0, 0.0),
  Curve curve = Curves.easeInOut,
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(begin: beginOffset, end: Offset.zero)
          .chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
