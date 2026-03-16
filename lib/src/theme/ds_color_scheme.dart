import '../utils/ds_enums.dart';
import 'ds_color_scale.dart';

class DsColorScheme {
  final DsColorScale accent;
  final DsColorScale neutral;
  final DsColorScale brand1;
  final DsColorScale brand2;
  final DsColorScale brand3;
  final DsColorScale success;
  final DsColorScale danger;
  final DsColorScale warning;
  final DsColorScale info;
  final Map<String, DsColorScale> custom;

  const DsColorScheme({
    required this.accent,
    required this.neutral,
    required this.brand1,
    required this.brand2,
    required this.brand3,
    required this.success,
    required this.danger,
    required this.warning,
    required this.info,
    this.custom = const {},
  });

  DsColorScheme copyWith({
    DsColorScale? accent,
    DsColorScale? neutral,
    DsColorScale? brand1,
    DsColorScale? brand2,
    DsColorScale? brand3,
    DsColorScale? success,
    DsColorScale? danger,
    DsColorScale? warning,
    DsColorScale? info,
    Map<String, DsColorScale>? custom,
  }) {
    return DsColorScheme(
      accent: accent ?? this.accent,
      neutral: neutral ?? this.neutral,
      brand1: brand1 ?? this.brand1,
      brand2: brand2 ?? this.brand2,
      brand3: brand3 ?? this.brand3,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      custom: custom ?? this.custom,
    );
  }

  DsColorScale resolve(DsColor color) {
    return switch (color) {
      DsColorAccent() => accent,
      DsColorNeutral() => neutral,
      DsColorBrand1() => brand1,
      DsColorBrand2() => brand2,
      DsColorBrand3() => brand3,
      DsColorSuccess() => success,
      DsColorDanger() => danger,
      DsColorWarning() => warning,
      DsColorInfo() => info,
      DsColorCustom(key: final k) => custom[k] ?? accent,
    };
  }
}
