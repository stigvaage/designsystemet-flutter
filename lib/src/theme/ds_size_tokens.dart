import '../utils/ds_enums.dart';

/// Canonical size-keyed scalar values shared across components.
///
/// Provides the official Designsystemet font sizes (14/16/18) used by
/// button, input and select so they are defined once instead of being
/// duplicated in each component's `switch (size)`.
abstract final class DsSizeValues {
  /// The canonical body/control font size for [size]: 14 (sm), 16 (md), 18 (lg).
  static double fontSize(DsSize size) =>
      size.pick(sm: 14.0, md: 16.0, lg: 18.0);
}

/// Spacing and sizing tokens generated from a [base] value and [step]
/// multiplier, producing 31 sizes (size0–size30).
class DsSizeTokens {
  final double base;
  final double step;
  final double size0;
  final double size1;
  final double size2;
  final double size3;
  final double size4;
  final double size5;
  final double size6;
  final double size7;
  final double size8;
  final double size9;
  final double size10;
  final double size11;
  final double size12;
  final double size13;
  final double size14;
  final double size15;
  final double size16;
  final double size17;
  final double size18;
  final double size19;
  final double size20;
  final double size21;
  final double size22;
  final double size23;
  final double size24;
  final double size25;
  final double size26;
  final double size27;
  final double size28;
  final double size29;
  final double size30;
  final double sizeUnit;

  const DsSizeTokens._({
    required this.base,
    required this.step,
    required this.size0,
    required this.size1,
    required this.size2,
    required this.size3,
    required this.size4,
    required this.size5,
    required this.size6,
    required this.size7,
    required this.size8,
    required this.size9,
    required this.size10,
    required this.size11,
    required this.size12,
    required this.size13,
    required this.size14,
    required this.size15,
    required this.size16,
    required this.size17,
    required this.size18,
    required this.size19,
    required this.size20,
    required this.size21,
    required this.size22,
    required this.size23,
    required this.size24,
    required this.size25,
    required this.size26,
    required this.size27,
    required this.size28,
    required this.size29,
    required this.size30,
    required this.sizeUnit,
  });

  factory DsSizeTokens.fromBaseAndStep({
    required double base,
    double step = 4,
  }) {
    return DsSizeTokens._(
      base: base,
      step: step,
      size0: 0,
      size1: step * 1,
      size2: step * 2,
      size3: step * 3,
      size4: step * 4,
      size5: step * 5,
      size6: step * 6,
      size7: step * 7,
      size8: step * 8,
      size9: step * 9,
      size10: step * 10,
      size11: step * 11,
      size12: step * 12,
      size13: step * 13,
      size14: step * 14,
      size15: step * 15,
      size16: step * 16,
      size17: step * 17,
      size18: step * 18,
      size19: step * 19,
      size20: step * 20,
      size21: step * 21,
      size22: step * 22,
      size23: step * 23,
      size24: step * 24,
      size25: step * 25,
      size26: step * 26,
      size27: step * 27,
      size28: step * 28,
      size29: step * 29,
      size30: step * 30,
      sizeUnit: step,
    );
  }

  /// Small size mode: 16px base
  static final sm = DsSizeTokens.fromBaseAndStep(base: 16);

  /// Medium size mode: 18px base (default)
  static final md = DsSizeTokens.fromBaseAndStep(base: 18);

  /// Large size mode: 21px base
  static final lg = DsSizeTokens.fromBaseAndStep(base: 21);

  /// Returns the size for [index] (0–30) by direct field lookup.
  ///
  /// Implemented as a `switch` so no intermediate list is allocated per call.
  double operator [](int index) {
    assert(index >= 0 && index <= 30, 'Size index must be 0-30');
    return switch (index) {
      0 => size0,
      1 => size1,
      2 => size2,
      3 => size3,
      4 => size4,
      5 => size5,
      6 => size6,
      7 => size7,
      8 => size8,
      9 => size9,
      10 => size10,
      11 => size11,
      12 => size12,
      13 => size13,
      14 => size14,
      15 => size15,
      16 => size16,
      17 => size17,
      18 => size18,
      19 => size19,
      20 => size20,
      21 => size21,
      22 => size22,
      23 => size23,
      24 => size24,
      25 => size25,
      26 => size26,
      27 => size27,
      28 => size28,
      29 => size29,
      30 => size30,
      _ => throw RangeError.range(index, 0, 30, 'index'),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DsSizeTokens &&
          other.base == base &&
          other.step == step &&
          other.size0 == size0 &&
          other.size1 == size1 &&
          other.size2 == size2 &&
          other.size3 == size3 &&
          other.size4 == size4 &&
          other.size5 == size5 &&
          other.size6 == size6 &&
          other.size7 == size7 &&
          other.size8 == size8 &&
          other.size9 == size9 &&
          other.size10 == size10 &&
          other.size11 == size11 &&
          other.size12 == size12 &&
          other.size13 == size13 &&
          other.size14 == size14 &&
          other.size15 == size15 &&
          other.size16 == size16 &&
          other.size17 == size17 &&
          other.size18 == size18 &&
          other.size19 == size19 &&
          other.size20 == size20 &&
          other.size21 == size21 &&
          other.size22 == size22 &&
          other.size23 == size23 &&
          other.size24 == size24 &&
          other.size25 == size25 &&
          other.size26 == size26 &&
          other.size27 == size27 &&
          other.size28 == size28 &&
          other.size29 == size29 &&
          other.size30 == size30 &&
          other.sizeUnit == sizeUnit;

  @override
  int get hashCode => Object.hashAll([
    base,
    step,
    size0,
    size1,
    size2,
    size3,
    size4,
    size5,
    size6,
    size7,
    size8,
    size9,
    size10,
    size11,
    size12,
    size13,
    size14,
    size15,
    size16,
    size17,
    size18,
    size19,
    size20,
    size21,
    size22,
    size23,
    size24,
    size25,
    size26,
    size27,
    size28,
    size29,
    size30,
    sizeUnit,
  ]);
}
