import 'dart:ui' show Color, Offset;
import 'package:flutter/painting.dart' show BoxShadow;

class DsShadowTokens {
  final List<BoxShadow> xs;
  final List<BoxShadow> sm;
  final List<BoxShadow> md;
  final List<BoxShadow> lg;
  final List<BoxShadow> xl;

  const DsShadowTokens({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  static const standard = DsShadowTokens(
    xs: [
      BoxShadow(
        offset: Offset(0, 0),
        blurRadius: 1,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.16),
      ),
      BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.12),
      ),
    ],
    sm: [
      BoxShadow(
        offset: Offset(0, 0),
        blurRadius: 1,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.15),
      ),
      BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.12),
      ),
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 4,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.10),
      ),
    ],
    md: [
      BoxShadow(
        offset: Offset(0, 0),
        blurRadius: 1,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.14),
      ),
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 4,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.12),
      ),
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 8,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.12),
      ),
    ],
    lg: [
      BoxShadow(
        offset: Offset(0, 0),
        blurRadius: 1,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.13),
      ),
      BoxShadow(
        offset: Offset(0, 3),
        blurRadius: 5,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.13),
      ),
      BoxShadow(
        offset: Offset(0, 6),
        blurRadius: 12,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.14),
      ),
    ],
    xl: [
      BoxShadow(
        offset: Offset(0, 0),
        blurRadius: 1,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.12),
      ),
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 8,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.16),
      ),
      BoxShadow(
        offset: Offset(0, 12),
        blurRadius: 24,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.16),
      ),
    ],
  );
}
