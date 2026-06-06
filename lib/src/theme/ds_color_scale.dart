import 'dart:ui' show Color;

/// A 16-step color scale with background, surface, border, text, and base tokens.
///
/// Mirrors the Designsystemet color-scale structure. Each step maps to a
/// specific UI role (e.g. [baseDefault] for filled buttons, [textDefault] for body text).
class DsColorScale {
  /// Sidebakgrunn; tilsvarer Designsystemet `background-default`.
  final Color backgroundDefault;

  /// Lett tonet sidebakgrunn; tilsvarer `background-tinted`.
  final Color backgroundTinted;

  /// Standard overflate/komponentbakgrunn (kort, paneler).
  final Color surfaceDefault;

  /// Lett tonet overflate; tilsvarer `surface-tinted`.
  final Color surfaceTinted;

  /// Overflatefarge ved hover.
  final Color surfaceHover;

  /// Overflatefarge ved aktiv/trykk.
  final Color surfaceActive;

  /// Diskret kantfarge (svake skiller).
  final Color borderSubtle;

  /// Standard 1px kantfarge.
  final Color borderDefault;

  /// Kraftig kantfarge (sterkere skiller).
  final Color borderStrong;

  /// Sekundær/dempet tekstfarge.
  final Color textSubtle;

  /// Standard tekstfarge for brødtekst.
  final Color textDefault;

  /// Standard fyllfarge for solide/primære elementer (fylte knapper).
  final Color baseDefault;

  /// Fyllfarge ved hover.
  final Color baseHover;

  /// Fyllfarge ved aktiv/trykk.
  final Color baseActive;

  /// Dempet kontrastfarge mot [baseDefault] (sekundær tekst/ikon på fyll).
  final Color baseContrastSubtle;

  /// Standard kontrastfarge mot [baseDefault] (tekst/ikon på fyll).
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

  /// Returnerer en kopi der angitte felter er erstattet.
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
