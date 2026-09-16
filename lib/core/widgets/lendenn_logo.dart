import 'package:flutter/material.dart';

class LendennLogo extends StatelessWidget {
  final double width;
  final bool showTagline;

  const LendennLogo({
    super.key,
    this.width = 320,
    this.showTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    final logoWidth = width;
    final logoHeight = showTagline ? width * 1.18 : width * 0.82;

    return SizedBox(
      width: logoWidth,
      height: logoHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: logoWidth * 0.86,
            height: logoWidth * 0.56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF031B1B),
                  Color(0xFF06181A),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1EF0A6).withValues(alpha: 0.42),
                  blurRadius: 24,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: const Color(0xFF34F0B3).withValues(alpha: 0.9),
                width: 2.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF0A2B2B).withValues(alpha: 0.95),
                            const Color(0xFF081B1B).withValues(alpha: 0.98),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: logoWidth * 0.08,
                    top: logoWidth * 0.1,
                    child: Transform.rotate(
                      angle: -0.52,
                      child: Container(
                        width: logoWidth * 0.42,
                        height: logoWidth * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFF8F9F7),
                              Color(0xFFE9F5EF),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.28),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: logoWidth * 0.06,
                    top: logoWidth * 0.18,
                    child: Transform.rotate(
                      angle: 0.28,
                      child: SizedBox(
                        width: logoWidth * 0.38,
                        height: logoWidth * 0.27,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Transform.rotate(
                                angle: -0.2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF49E7A8),
                                        Color(0xFF09A15B),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Transform.translate(
                                offset: const Offset(-8, 11),
                                child: Transform.rotate(
                                  angle: -0.15,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF72F0B5),
                                          Color(0xFF1FB76E),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Transform.translate(
                                offset: const Offset(-16, 22),
                                child: Transform.rotate(
                                  angle: -0.12,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF97F9C8),
                                          Color(0xFF38CD82),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: logoWidth * 0.12,
                    top: logoWidth * 0.18,
                    child: Container(
                      width: logoWidth * 0.17,
                      height: logoWidth * 0.17,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: const Color(0xFFF6F8F7),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.16),
                            blurRadius: 12,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Text(
                        '৳',
                        style: TextStyle(
                          color: Color(0xFF0B8D58),
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: logoWidth * 0.18,
                    bottom: logoWidth * 0.12,
                    child: Transform.rotate(
                      angle: -0.62,
                      child: Container(
                        width: logoWidth * 0.66,
                        height: logoWidth * 0.22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(120),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF6BE8B2),
                              Color(0xFF3FE5A0),
                              Color(0xFF0DA864),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF37D792).withValues(alpha: 0.45),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showTagline) ...[
            const SizedBox(height: 18),
            const Text(
              'LENDENN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 68,
                letterSpacing: -4,
                fontWeight: FontWeight.w900,
                color: Color(0xFFF6F9F8),
                shadows: [
                  Shadow(
                    color: Color(0xFF32E3A0),
                    blurRadius: 18,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'LOAN • TRACK • GROW',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 4,
                fontWeight: FontWeight.w700,
                color: Color(0xFF48E7AA),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
