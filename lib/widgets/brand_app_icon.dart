import 'package:flutter/material.dart';

class BrandAppIcon extends StatelessWidget {
  final double size;
  final bool elevated;

  const BrandAppIcon({super.key, this.size = 84, this.elevated = true});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(size * 0.24);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: const Color(0xFF1B6B63).withValues(alpha: 0.22),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset('assets/images/icon_2.png', fit: BoxFit.cover),
      ),
    );
  }
}
