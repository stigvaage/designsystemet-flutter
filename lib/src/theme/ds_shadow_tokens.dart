import 'dart:ui' show Color, Offset;
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/painting.dart' show BoxShadow;

/// Design tokens for box shadows at five elevation levels (xs–xl).
///
/// [standard] (= [light]) inneholder det offisielle Designsystemet-skyggesettet
/// (én definisjon, uavhengig av fargemodus). [dark] er bevisst tomt: offisiell
/// Designsystemet bruker ikke skygger i mørk modus, fordi skyggene er bygget på
/// mørke fargetoner. I mørk modus skapes hierarki i stedet med lyse kanter/
/// border. Se site/nb/kom-i-gang/avrunding-og-skygger.md.
class DsShadowTokens {
  /// Skygge for nivå xs (laveste elevasjon).
  final List<BoxShadow> xs;

  /// Skygge for nivå sm.
  final List<BoxShadow> sm;

  /// Skygge for nivå md.
  final List<BoxShadow> md;

  /// Skygge for nivå lg.
  final List<BoxShadow> lg;

  /// Skygge for nivå xl (høyeste elevasjon).
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

  /// Light mode shadows (identical to [standard]).
  static const light = standard;

  /// Mørk modus: ingen skygger.
  ///
  /// Offisiell Designsystemet definerer kun ett skyggesett ([standard]) og
  /// fraråder bruk av skygger i mørk modus, siden skyggene er basert på mørke
  /// fargetoner som ikke gir kontrast mot mørk bakgrunn. Bruk lyse kanter/
  /// border for å skape elevasjon i mørk modus i stedet.
  static const dark = DsShadowTokens(xs: [], sm: [], md: [], lg: [], xl: []);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DsShadowTokens &&
          listEquals(other.xs, xs) &&
          listEquals(other.sm, sm) &&
          listEquals(other.md, md) &&
          listEquals(other.lg, lg) &&
          listEquals(other.xl, xl);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(xs),
    Object.hashAll(sm),
    Object.hashAll(md),
    Object.hashAll(lg),
    Object.hashAll(xl),
  );
}
