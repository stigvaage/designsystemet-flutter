import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';

/// En plassholder-lasteindikator med en pulserende skimmer-animasjon.
///
/// Støtter tekst-, sirkel- og rektangelvarianter. Respekterer plattformens
/// reduser-bevegelse-innstilling.
///
/// Som i Designsystemet er plassholderen som standard nøytral grå
/// (`neutral`-skalaens `surface-tinted`-token). Bruk [color] kun når du
/// bevisst ønsker en tonet skjelettfarge.
class DsSkeleton extends StatefulWidget {
  const DsSkeleton({
    super.key,
    this.variant,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
    this.label,
  });

  /// Variant som styrer standarddimensjoner og hjørneradius.
  final DsSkeletonVariant? variant;

  /// Eksplisitt bredde. Faller tilbake til variantens standardverdi.
  final double? width;

  /// Eksplisitt høyde. Faller tilbake til variantens standardverdi.
  final double? height;

  /// Eksplisitt hjørneradius. Faller tilbake til variantens standardverdi.
  final double? borderRadius;

  /// Valgfri overstyring av fargeskalaen plassholderen tegnes fra.
  ///
  /// Når `null` (standard) brukes den nøytrale grå skalaen, i tråd med
  /// Designsystemet. Angi en [DsColor] kun for en bevisst tonet plassholder.
  final DsColor? color;

  /// Valgfri tilgjengelighetsetikett som annonseres av skjermlesere.
  ///
  /// Når `null` (standard) er skjelettet dekorativt og stille for hjelpemidler,
  /// slik som i Designsystemet — det omkringliggende området eier `aria-busy`.
  /// Sett en etikett (f.eks. `'Laster innhold'`) kun når en enkelt skjelett-
  /// gruppe er den eneste lasteindikasjonen; da pakkes plassholderen i en
  /// [Semantics]-node med [Semantics.liveRegion]. Unngå å sette etikett på hvert
  /// enkelt skjelett i en liste, da det oversvømmer skjermlesere.
  final String? label;

  @override
  State<DsSkeleton> createState() => _DsSkeletonState();
}

class _DsSkeletonState extends State<DsSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!DsAnimation.shouldAnimate(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    // Designsystemet tegner skjelettet fra den nøytrale grå skalaen
    // (`--ds-color-neutral-surface-tinted`). Vi arver bevisst IKKE den
    // omkringliggende (ofte aksent-/blå) DsColorScope for standardtilfellet.
    final colorScale = widget.color != null
        ? theme.colorScheme.resolve(widget.color!)
        : theme.colorScheme.neutral;
    final defaultRadius = theme.borderRadius.sm;

    final (
      effectiveWidth,
      effectiveHeight,
      effectiveRadius,
    ) = switch (widget.variant) {
      DsSkeletonVariant.text => (
        widget.width ?? double.infinity,
        widget.height ?? 16.0,
        widget.borderRadius ?? defaultRadius,
      ),
      DsSkeletonVariant.circle => (
        widget.width ?? 40.0,
        widget.width ?? 40.0,
        (widget.width ?? 40.0) / 2,
      ),
      DsSkeletonVariant.rectangle => (
        widget.width,
        widget.height ?? 100.0,
        widget.borderRadius ?? 0.0,
      ),
      null => (
        widget.width,
        widget.height ?? 20.0,
        widget.borderRadius ?? defaultRadius,
      ),
    };

    final animated = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Jevn puls i området [0, 1]; ren tidsmatematikk, ikke en visuell verdi.
        final t = 0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi);
        // Lerp mellom to ugjennomsiktige token-steg, slik at plassholderen
        // forblir solid (ingen bakgrunn som skinner gjennom) og kun bruker
        // tokens. Endepunktene matcher Designsystemets nøytrale grå.
        final shimmerColor =
            Color.lerp(colorScale.surfaceTinted, colorScale.surfaceHover, t) ??
            colorScale.surfaceTinted;
        return Container(
          width: effectiveWidth,
          height: effectiveHeight,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(effectiveRadius),
          ),
        );
      },
    );

    final label = widget.label;
    if (label == null) {
      return animated;
    }
    return Semantics(
      label: label,
      liveRegion: true,
      container: true,
      child: animated,
    );
  }
}
