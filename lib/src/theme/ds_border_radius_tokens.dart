class DsBorderRadiusTokens {
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double defaultRadius;
  final double full;

  const DsBorderRadiusTokens({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.defaultRadius,
    this.full = 9999,
  });

  factory DsBorderRadiusTokens.fromBase(double base) {
    return DsBorderRadiusTokens(
      sm: base / 2,
      md: base,
      lg: base * 2,
      xl: base * 3,
      defaultRadius: base,
    );
  }
}
