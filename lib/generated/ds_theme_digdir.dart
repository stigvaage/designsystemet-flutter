import 'dart:ui' show Brightness, Color;

import '../src/theme/ds_border_radius_tokens.dart';
import '../src/theme/ds_color_scale.dart';
import '../src/theme/ds_color_scheme.dart';
import '../src/theme/ds_shadow_tokens.dart';
import '../src/theme/ds_size_tokens.dart';
import '../src/theme/ds_theme_data.dart';
import '../src/theme/ds_typography.dart';

/// Built-in Digdir theme with colors from designsystemet.no.
///
/// These values are sourced from the official Digdir theme.
/// For custom themes, use the code generator:
/// `dart run komponentbibliotek_flutter:generate`
class DsThemeDigdir {
  DsThemeDigdir._();

  static DsThemeData light() => DsThemeData(
    brightness: Brightness.light,
    colorScheme: _lightColorScheme,
    sizeTokens: DsSizeTokens.md,
    typography: DsTypography.create(baseFontSize: 18),
    borderRadius: DsBorderRadiusTokens.fromBase(4),
    shadows: DsShadowTokens.light,
  );

  static DsThemeData dark() => DsThemeData(
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,
    sizeTokens: DsSizeTokens.md,
    typography: DsTypography.create(baseFontSize: 18),
    borderRadius: DsBorderRadiusTokens.fromBase(4),
    shadows: DsShadowTokens.dark,
  );

  // ── Light color scheme ──────────────────────────────────────────────

  static const _lightColorScheme = DsColorScheme(
    accent: _lightAccent,
    neutral: _lightNeutral,
    brand1: _lightBrand1,
    brand2: _lightBrand2,
    brand3: _lightBrand3,
    success: _lightSuccess,
    danger: _lightDanger,
    warning: _lightWarning,
    info: _lightInfo,
  );

  static const _lightAccent = DsColorScale(
    backgroundDefault: Color(0xFFFEFEFF),
    backgroundTinted: Color(0xFFEEF4FA),
    surfaceDefault: Color(0xFFDDE9F3),
    surfaceTinted: Color(0xFFCCDFF0),
    surfaceHover: Color(0xFFB3CFE5),
    surfaceActive: Color(0xFF99C0DB),
    borderSubtle: Color(0xFF85B0CC),
    borderDefault: Color(0xFF5A9AC4),
    borderStrong: Color(0xFF2B7BB5),
    textSubtle: Color(0xFF1A5C97),
    textDefault: Color(0xFF003052),
    baseDefault: Color(0xFF003087),
    baseHover: Color(0xFF00266B),
    baseActive: Color(0xFF001D52),
    baseContrastSubtle: Color(0xFFD4E4F0),
    baseContrastDefault: Color(0xFFFFFFFF),
  );

  static const _lightNeutral = DsColorScale(
    backgroundDefault: Color(0xFFFCFCFD),
    backgroundTinted: Color(0xFFF3F4F5),
    surfaceDefault: Color(0xFFE9EAEC),
    surfaceTinted: Color(0xFFDFE1E3),
    surfaceHover: Color(0xFFCFD2D5),
    surfaceActive: Color(0xFFC0C4C8),
    borderSubtle: Color(0xFFB0B5BA),
    borderDefault: Color(0xFF8D949B),
    borderStrong: Color(0xFF68707A),
    textSubtle: Color(0xFF495361),
    textDefault: Color(0xFF1B2534),
    baseDefault: Color(0xFF1E2B3C),
    baseHover: Color(0xFF141D2A),
    baseActive: Color(0xFF0E1520),
    baseContrastSubtle: Color(0xFFCDD2D8),
    baseContrastDefault: Color(0xFFFFFFFF),
  );

  static const _lightBrand1 = DsColorScale(
    backgroundDefault: Color(0xFFFEFEFF),
    backgroundTinted: Color(0xFFEEF4FA),
    surfaceDefault: Color(0xFFDDE9F3),
    surfaceTinted: Color(0xFFCCDFF0),
    surfaceHover: Color(0xFFB3CFE5),
    surfaceActive: Color(0xFF99C0DB),
    borderSubtle: Color(0xFF85B0CC),
    borderDefault: Color(0xFF5A9AC4),
    borderStrong: Color(0xFF2B7BB5),
    textSubtle: Color(0xFF1A5C97),
    textDefault: Color(0xFF003052),
    baseDefault: Color(0xFF003087),
    baseHover: Color(0xFF00266B),
    baseActive: Color(0xFF001D52),
    baseContrastSubtle: Color(0xFFD4E4F0),
    baseContrastDefault: Color(0xFFFFFFFF),
  );

  static const _lightBrand2 = DsColorScale(
    backgroundDefault: Color(0xFFFCFEFF),
    backgroundTinted: Color(0xFFE6F4FC),
    surfaceDefault: Color(0xFFCDE9F9),
    surfaceTinted: Color(0xFFB8DFF6),
    surfaceHover: Color(0xFF96D0F2),
    surfaceActive: Color(0xFF74C0ED),
    borderSubtle: Color(0xFF58B1E5),
    borderDefault: Color(0xFF2C9ADB),
    borderStrong: Color(0xFF0C82C8),
    textSubtle: Color(0xFF0D6DAC),
    textDefault: Color(0xFF063551),
    baseDefault: Color(0xFF1E98F5),
    baseHover: Color(0xFF0B7AD4),
    baseActive: Color(0xFF0960A6),
    baseContrastSubtle: Color(0xFF092940),
    baseContrastDefault: Color(0xFF000000),
  );

  static const _lightBrand3 = DsColorScale(
    backgroundDefault: Color(0xFFFEFEFF),
    backgroundTinted: Color(0xFFEEF4FA),
    surfaceDefault: Color(0xFFDDE9F3),
    surfaceTinted: Color(0xFFCCDFF0),
    surfaceHover: Color(0xFFB3CFE5),
    surfaceActive: Color(0xFF99C0DB),
    borderSubtle: Color(0xFF85B0CC),
    borderDefault: Color(0xFF5A9AC4),
    borderStrong: Color(0xFF2B7BB5),
    textSubtle: Color(0xFF1A5C97),
    textDefault: Color(0xFF003052),
    baseDefault: Color(0xFF003087),
    baseHover: Color(0xFF00266B),
    baseActive: Color(0xFF001D52),
    baseContrastSubtle: Color(0xFFD4E4F0),
    baseContrastDefault: Color(0xFFFFFFFF),
  );

  static const _lightSuccess = DsColorScale(
    backgroundDefault: Color(0xFFFCFEFC),
    backgroundTinted: Color(0xFFECF6EC),
    surfaceDefault: Color(0xFFDAEEDA),
    surfaceTinted: Color(0xFFC8E5C8),
    surfaceHover: Color(0xFFACD9AC),
    surfaceActive: Color(0xFF90CC90),
    borderSubtle: Color(0xFF78BF78),
    borderDefault: Color(0xFF4DA84D),
    borderStrong: Color(0xFF218F21),
    textSubtle: Color(0xFF1A6F1A),
    textDefault: Color(0xFF0A3A0A),
    baseDefault: Color(0xFF078D19),
    baseHover: Color(0xFF056E13),
    baseActive: Color(0xFF04550F),
    baseContrastSubtle: Color(0xFFCFE7D2),
    baseContrastDefault: Color(0xFFFFFFFF),
  );

  static const _lightDanger = DsColorScale(
    backgroundDefault: Color(0xFFFFFCFC),
    backgroundTinted: Color(0xFFFCECEC),
    surfaceDefault: Color(0xFFF9D9D9),
    surfaceTinted: Color(0xFFF5C7C7),
    surfaceHover: Color(0xFFF0AAAA),
    surfaceActive: Color(0xFFEA8D8D),
    borderSubtle: Color(0xFFE27474),
    borderDefault: Color(0xFFD44C4C),
    borderStrong: Color(0xFFC22222),
    textSubtle: Color(0xFF9E1B1B),
    textDefault: Color(0xFF520E0E),
    baseDefault: Color(0xFFE02E2E),
    baseHover: Color(0xFFB52424),
    baseActive: Color(0xFF8E1C1C),
    baseContrastSubtle: Color(0xFFF0D1D1),
    baseContrastDefault: Color(0xFFFFFFFF),
  );

  static const _lightWarning = DsColorScale(
    backgroundDefault: Color(0xFFFFFEFC),
    backgroundTinted: Color(0xFFFDF6E3),
    surfaceDefault: Color(0xFFFAEDC7),
    surfaceTinted: Color(0xFFF7E4AB),
    surfaceHover: Color(0xFFF3D77F),
    surfaceActive: Color(0xFFEECA53),
    borderSubtle: Color(0xFFE5BC30),
    borderDefault: Color(0xFFD4A80D),
    borderStrong: Color(0xFFB38D08),
    textSubtle: Color(0xFF8A6D06),
    textDefault: Color(0xFF473803),
    baseDefault: Color(0xFFE5AA20),
    baseHover: Color(0xFFBB8B19),
    baseActive: Color(0xFF926C13),
    baseContrastSubtle: Color(0xFF3D3019),
    baseContrastDefault: Color(0xFF000000),
  );

  static const _lightInfo = DsColorScale(
    backgroundDefault: Color(0xFFFCFDFE),
    backgroundTinted: Color(0xFFE8F1F8),
    surfaceDefault: Color(0xFFD1E4F2),
    surfaceTinted: Color(0xFFBAD6EB),
    surfaceHover: Color(0xFF97C2E1),
    surfaceActive: Color(0xFF74ADD7),
    borderSubtle: Color(0xFF579BC9),
    borderDefault: Color(0xFF2E81B7),
    borderStrong: Color(0xFF0E68A2),
    textSubtle: Color(0xFF0D5585),
    textDefault: Color(0xFF072C45),
    baseDefault: Color(0xFF218BC5),
    baseHover: Color(0xFF1A6F9E),
    baseActive: Color(0xFF14567B),
    baseContrastSubtle: Color(0xFFCEE2EF),
    baseContrastDefault: Color(0xFFFFFFFF),
  );

  // ── Dark color scheme ───────────────────────────────────────────────

  static const _darkColorScheme = DsColorScheme(
    accent: _darkAccent,
    neutral: _darkNeutral,
    brand1: _darkBrand1,
    brand2: _darkBrand2,
    brand3: _darkBrand3,
    success: _darkSuccess,
    danger: _darkDanger,
    warning: _darkWarning,
    info: _darkInfo,
  );

  static const _darkAccent = DsColorScale(
    backgroundDefault: Color(0xFF0A1929),
    backgroundTinted: Color(0xFF0F2440),
    surfaceDefault: Color(0xFF163052),
    surfaceTinted: Color(0xFF1D3D66),
    surfaceHover: Color(0xFF274F7D),
    surfaceActive: Color(0xFF326194),
    borderSubtle: Color(0xFF3E73A8),
    borderDefault: Color(0xFF5A9AC4),
    borderStrong: Color(0xFF7FB8DB),
    textSubtle: Color(0xFF8FC5E5),
    textDefault: Color(0xFFD4E8F5),
    baseDefault: Color(0xFF3B8FD4),
    baseHover: Color(0xFF5AA3DE),
    baseActive: Color(0xFF7BB7E6),
    baseContrastSubtle: Color(0xFF0F2440),
    baseContrastDefault: Color(0xFF000000),
  );

  static const _darkNeutral = DsColorScale(
    backgroundDefault: Color(0xFF111820),
    backgroundTinted: Color(0xFF1A2230),
    surfaceDefault: Color(0xFF232D3D),
    surfaceTinted: Color(0xFF2D384A),
    surfaceHover: Color(0xFF3A4862),
    surfaceActive: Color(0xFF485877),
    borderSubtle: Color(0xFF56688A),
    borderDefault: Color(0xFF7586A0),
    borderStrong: Color(0xFF95A4B8),
    textSubtle: Color(0xFFA8B5C6),
    textDefault: Color(0xFFDEE4EB),
    baseDefault: Color(0xFFCDD4DD),
    baseHover: Color(0xFFDDE2E8),
    baseActive: Color(0xFFEBEEF2),
    baseContrastSubtle: Color(0xFF1A2230),
    baseContrastDefault: Color(0xFF000000),
  );

  static const _darkBrand1 = _darkAccent;
  static const _darkBrand2 = _darkAccent;
  static const _darkBrand3 = _darkAccent;

  static const _darkSuccess = DsColorScale(
    backgroundDefault: Color(0xFF071407),
    backgroundTinted: Color(0xFF0F220F),
    surfaceDefault: Color(0xFF183018),
    surfaceTinted: Color(0xFF224022),
    surfaceHover: Color(0xFF2F562F),
    surfaceActive: Color(0xFF3D6D3D),
    borderSubtle: Color(0xFF4D844D),
    borderDefault: Color(0xFF6CA86C),
    borderStrong: Color(0xFF90C890),
    textSubtle: Color(0xFFA0D6A0),
    textDefault: Color(0xFFD6EFD6),
    baseDefault: Color(0xFF3DA84D),
    baseHover: Color(0xFF55BB65),
    baseActive: Color(0xFF70CC7F),
    baseContrastSubtle: Color(0xFF0F220F),
    baseContrastDefault: Color(0xFF000000),
  );

  static const _darkDanger = DsColorScale(
    backgroundDefault: Color(0xFF1E0808),
    backgroundTinted: Color(0xFF2F0F0F),
    surfaceDefault: Color(0xFF421818),
    surfaceTinted: Color(0xFF552222),
    surfaceHover: Color(0xFF6E2F2F),
    surfaceActive: Color(0xFF883D3D),
    borderSubtle: Color(0xFFA04D4D),
    borderDefault: Color(0xFFC46C6C),
    borderStrong: Color(0xFFDF9191),
    textSubtle: Color(0xFFE8A5A5),
    textDefault: Color(0xFFF5D6D6),
    baseDefault: Color(0xFFD45555),
    baseHover: Color(0xFFDE7474),
    baseActive: Color(0xFFE69292),
    baseContrastSubtle: Color(0xFF2F0F0F),
    baseContrastDefault: Color(0xFF000000),
  );

  static const _darkWarning = DsColorScale(
    backgroundDefault: Color(0xFF1A1408),
    backgroundTinted: Color(0xFF2A2010),
    surfaceDefault: Color(0xFF3B2E1A),
    surfaceTinted: Color(0xFF4D3C24),
    surfaceHover: Color(0xFF665032),
    surfaceActive: Color(0xFF806541),
    borderSubtle: Color(0xFF997A51),
    borderDefault: Color(0xFFBB9C6C),
    borderStrong: Color(0xFFDABC90),
    textSubtle: Color(0xFFE5CCA5),
    textDefault: Color(0xFFF5EAD6),
    baseDefault: Color(0xFFCCA040),
    baseHover: Color(0xFFD9B35E),
    baseActive: Color(0xFFE2C47D),
    baseContrastSubtle: Color(0xFF2A2010),
    baseContrastDefault: Color(0xFF000000),
  );

  static const _darkInfo = DsColorScale(
    backgroundDefault: Color(0xFF081520),
    backgroundTinted: Color(0xFF0F2133),
    surfaceDefault: Color(0xFF182F48),
    surfaceTinted: Color(0xFF223D5D),
    surfaceHover: Color(0xFF305175),
    surfaceActive: Color(0xFF3E668E),
    borderSubtle: Color(0xFF4D7BA5),
    borderDefault: Color(0xFF6C9BBE),
    borderStrong: Color(0xFF91B9D5),
    textSubtle: Color(0xFFA5C8E0),
    textDefault: Color(0xFFD6E8F2),
    baseDefault: Color(0xFF4A9BCB),
    baseHover: Color(0xFF66ADD6),
    baseActive: Color(0xFF83C0DF),
    baseContrastSubtle: Color(0xFF0F2133),
    baseContrastDefault: Color(0xFF000000),
  );
}
