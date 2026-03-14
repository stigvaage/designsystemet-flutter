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

  double operator [](int index) {
    assert(index >= 0 && index <= 30, 'Size index must be 0-30');
    // Use a list lookup for indexed access
    final values = [
      size0, size1, size2, size3, size4, size5, size6, size7, size8, size9,
      size10, size11, size12, size13, size14, size15, size16, size17, size18, size19,
      size20, size21, size22, size23, size24, size25, size26, size27, size28, size29,
      size30,
    ];
    return values[index];
  }
}
