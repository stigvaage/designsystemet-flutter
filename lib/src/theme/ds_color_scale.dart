import 'dart:ui' show Color;

class DsColorScale {
  final Color backgroundDefault;
  final Color backgroundTinted;
  final Color surfaceDefault;
  final Color surfaceTinted;
  final Color surfaceHover;
  final Color surfaceActive;
  final Color borderSubtle;
  final Color borderDefault;
  final Color borderStrong;
  final Color textSubtle;
  final Color textDefault;
  final Color baseDefault;
  final Color baseHover;
  final Color baseActive;
  final Color baseContrastSubtle;
  final Color baseContrastDefault;

  const DsColorScale({
    required this.backgroundDefault,
    required this.backgroundTinted,
    required this.surfaceDefault,
    required this.surfaceTinted,
    required this.surfaceHover,
    required this.surfaceActive,
    required this.borderSubtle,
    required this.borderDefault,
    required this.borderStrong,
    required this.textSubtle,
    required this.textDefault,
    required this.baseDefault,
    required this.baseHover,
    required this.baseActive,
    required this.baseContrastSubtle,
    required this.baseContrastDefault,
  });

  DsColorScale copyWith({
    Color? backgroundDefault,
    Color? backgroundTinted,
    Color? surfaceDefault,
    Color? surfaceTinted,
    Color? surfaceHover,
    Color? surfaceActive,
    Color? borderSubtle,
    Color? borderDefault,
    Color? borderStrong,
    Color? textSubtle,
    Color? textDefault,
    Color? baseDefault,
    Color? baseHover,
    Color? baseActive,
    Color? baseContrastSubtle,
    Color? baseContrastDefault,
  }) {
    return DsColorScale(
      backgroundDefault: backgroundDefault ?? this.backgroundDefault,
      backgroundTinted: backgroundTinted ?? this.backgroundTinted,
      surfaceDefault: surfaceDefault ?? this.surfaceDefault,
      surfaceTinted: surfaceTinted ?? this.surfaceTinted,
      surfaceHover: surfaceHover ?? this.surfaceHover,
      surfaceActive: surfaceActive ?? this.surfaceActive,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      textSubtle: textSubtle ?? this.textSubtle,
      textDefault: textDefault ?? this.textDefault,
      baseDefault: baseDefault ?? this.baseDefault,
      baseHover: baseHover ?? this.baseHover,
      baseActive: baseActive ?? this.baseActive,
      baseContrastSubtle: baseContrastSubtle ?? this.baseContrastSubtle,
      baseContrastDefault: baseContrastDefault ?? this.baseContrastDefault,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DsColorScale &&
        other.backgroundDefault == backgroundDefault &&
        other.backgroundTinted == backgroundTinted &&
        other.surfaceDefault == surfaceDefault &&
        other.surfaceTinted == surfaceTinted &&
        other.surfaceHover == surfaceHover &&
        other.surfaceActive == surfaceActive &&
        other.borderSubtle == borderSubtle &&
        other.borderDefault == borderDefault &&
        other.borderStrong == borderStrong &&
        other.textSubtle == textSubtle &&
        other.textDefault == textDefault &&
        other.baseDefault == baseDefault &&
        other.baseHover == baseHover &&
        other.baseActive == baseActive &&
        other.baseContrastSubtle == baseContrastSubtle &&
        other.baseContrastDefault == baseContrastDefault;
  }

  @override
  int get hashCode => Object.hash(
    backgroundDefault,
    backgroundTinted,
    surfaceDefault,
    surfaceTinted,
    surfaceHover,
    surfaceActive,
    borderSubtle,
    borderDefault,
    borderStrong,
    textSubtle,
    textDefault,
    baseDefault,
    baseHover,
    baseActive,
    baseContrastSubtle,
    baseContrastDefault,
  );
}
