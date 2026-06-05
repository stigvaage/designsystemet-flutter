import 'package:flutter/widgets.dart';
import '../theme/ds_color_scope.dart';
import '../theme/ds_size_scope.dart';
import '../theme/ds_theme.dart';
import '../utils/ds_enums.dart';

/// Etikettkomponent som bruker Designsystemets typografi-tokens.
///
/// Brukes til skjemafeltetiketter og annen kort, beskrivende tekst.
///
/// Merk: [DsLabel] rendrer ren tekst og kobles ikke automatisk til et
/// skjemafelt. For programmatisk kobling, bruk en skjemakomponent (f.eks.
/// `DsInput`/`DsField`) som håndterer etikettkoblingen, eller pakk etikett og
/// felt i en `Semantics`-widget selv.
class DsLabel extends StatelessWidget {
  const DsLabel({
    super.key,
    required this.text,
    this.size,
    this.color,
    this.weight,
  });

  /// Etiketteksten som vises.
  final String text;

  /// Størrelsen på etiketten. Faller tilbake til [DsSizeScope] når den er
  /// `null` (standard `md`).
  final DsSize? size;

  /// Fargetema for etiketten. Faller tilbake til [DsColorScope] når den er
  /// `null`.
  final DsColor? color;

  /// Skriftvekt for etiketten. Standard er [DsFontWeight.medium], som svarer
  /// til den offisielle `Label`-standarden (`medium`/500).
  final DsFontWeight? weight;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    final sizeMode = size ?? DsSizeScope.of(context);

    // Offisiell Label-skriftstørrelse for sm/md/lg = 16/18/21 px (body.md i
    // hhv. small/medium/large size-mode). Repoets body-stige har ingen 21px-
    // token, så lg utledes fra bodyLg (18px) skalert til 21px for å treffe
    // den offisielle størrelsen nøyaktig.
    final baseStyle = switch (sizeMode) {
      DsSize.sm => theme.typography.bodyMd,
      DsSize.md => theme.typography.bodyLg,
      DsSize.lg => theme.typography.bodyLg.copyWith(
        fontSize: theme.typography.bodyLg.fontSize! * (21 / 18),
      ),
    };

    final style = baseStyle.copyWith(
      color: colorScale.textDefault,
      fontWeight: (weight ?? DsFontWeight.medium).toFontWeight(),
    );

    return Text(text, style: style);
  }
}
