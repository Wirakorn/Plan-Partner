import 'package:flutter/material.dart';

class BrandAppIcon extends StatelessWidget {
  final double size;
  final bool elevated;

  const BrandAppIcon({super.key, this.size = 84, this.elevated = true});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(size * 0.24);
    final innerInset = size * 0.16;
    final calendarRadius = size * 0.09;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB8F2EE), Color(0xFF4EA7C8), Color(0xFF1F69A8)],
          stops: [0.0, 0.58, 1.0],
        ),
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
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(innerInset),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(size * 0.13),
                  border: Border.all(color: Colors.white, width: size * 0.05),
                ),
              ),
            ),
          ),
          Positioned(
            left: size * 0.20,
            right: size * 0.20,
            top: size * 0.26,
            child: Container(
              height: size * 0.12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size * 0.06),
              ),
            ),
          ),
          Positioned(
            left: size * 0.20,
            right: size * 0.20,
            top: size * 0.45,
            child: Container(
              height: size * 0.12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size * 0.06),
              ),
            ),
          ),
          Positioned(
            left: size * 0.20,
            top: size * 0.63,
            child: Container(
              width: size * 0.18,
              height: size * 0.09,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size * 0.045),
              ),
            ),
          ),
          Positioned(
            left: size * 0.13,
            top: size * 0.13,
            child: Row(
              children: [
                _BinderRing(size: calendarRadius),
                SizedBox(width: size * 0.07),
                _BinderRing(size: calendarRadius),
              ],
            ),
          ),
          Positioned(
            left: size * 0.11,
            top: size * 0.31,
            child: SizedBox(
              width: size * 0.44,
              height: size * 0.44,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: size * 0.03,
                crossAxisSpacing: size * 0.03,
                children: List.generate(9, (index) {
                  if (index == 4 || index == 7) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(size * 0.02),
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            right: size * 0.08,
            bottom: size * 0.08,
            child: Container(
              width: size * 0.42,
              height: size * 0.42,
              decoration: BoxDecoration(
                color: const Color(0xFF79D95B),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1C5B73).withValues(alpha: 0.16),
                    blurRadius: 12,
                    offset: const Offset(-4, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: size * 0.23,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BinderRing extends StatelessWidget {
  final double size;

  const _BinderRing({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 1.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C5B73).withValues(alpha: 0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
