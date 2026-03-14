// DsSize enum
enum DsSize { sm, md, lg }

// DsColor — sealed class with 9 named + custom
sealed class DsColor {
  const DsColor();
  static const accent = DsColorAccent();
  static const neutral = DsColorNeutral();
  static const brand1 = DsColorBrand1();
  static const brand2 = DsColorBrand2();
  static const brand3 = DsColorBrand3();
  static const success = DsColorSuccess();
  static const danger = DsColorDanger();
  static const warning = DsColorWarning();
  static const info = DsColorInfo();
  static DsColorCustom custom(String key) => DsColorCustom(key);
}
class DsColorAccent extends DsColor { const DsColorAccent(); }
class DsColorNeutral extends DsColor { const DsColorNeutral(); }
class DsColorBrand1 extends DsColor { const DsColorBrand1(); }
class DsColorBrand2 extends DsColor { const DsColorBrand2(); }
class DsColorBrand3 extends DsColor { const DsColorBrand3(); }
class DsColorSuccess extends DsColor { const DsColorSuccess(); }
class DsColorDanger extends DsColor { const DsColorDanger(); }
class DsColorWarning extends DsColor { const DsColorWarning(); }
class DsColorInfo extends DsColor { const DsColorInfo(); }
class DsColorCustom extends DsColor {
  final String key;
  const DsColorCustom(this.key);
  @override bool operator ==(Object other) => other is DsColorCustom && other.key == key;
  @override int get hashCode => key.hashCode;
}

// DsSeverity
enum DsSeverity { info, warning, success, danger }

// DsButtonVariant
enum DsButtonVariant { primary, secondary, tertiary }

// DsIconPosition
enum DsIconPosition { left, right }

// DsHeadingLevel
enum DsHeadingLevel { xxl, xl, lg, md, sm, xs, xxs }

// DsBodySize
enum DsBodySize { xl, lg, md, sm, xs }

// DsBodyVariant
enum DsBodyVariant { standard, short, long }

// DsBadgePlacement
enum DsBadgePlacement { topRight, topLeft, bottomRight, bottomLeft }
