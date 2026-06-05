import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_size_tokens.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// Fanenavigasjon med tastaturstøtte og innholdspaneler.
///
/// Følger WAI-ARIA Tabs-mønsteret med «roving focus»: piltastene venstre/høyre
/// flytter fokus og aktiverer fanen, mens `Home`/`End` hopper til første/siste
/// fane. Hver fane viser en synlig fokusindikator ved tastaturnavigasjon
/// (WCAG 2.4.7) og eksponeres for skjermlesere som en valgbar knapp.
///
/// Komponenten kan brukes ukontrollert (sett startfanen via [initialIndex]) eller
/// kontrollert (oppgi [value] og hold den oppdatert i [onChanged]). Når [value]
/// er satt, styrer forelderen den valgte fanen og [value] har forrang over den
/// interne tilstanden.
///
/// Arver farge/størrelse fra [DsColorScope]/[DsSizeScope] når de ikke er satt
/// eksplisitt.
class DsTabs extends StatefulWidget {
  const DsTabs({
    super.key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.value,
    this.onChanged,
    this.size,
    this.color,
  });

  /// Etikettene til fanene, i rekkefølge.
  final List<String> tabs;

  /// Innholdspanelet som vises for hver fane, parallelt med [tabs].
  final List<Widget> children;

  /// Indeksen til fanen som er valgt ved oppstart (ukontrollert modus).
  ///
  /// Ignoreres når [value] er satt (kontrollert modus).
  final int initialIndex;

  /// Den valgte faneindeksen i kontrollert modus.
  ///
  /// Når denne er satt, styrer forelderen valget og verdien har forrang over
  /// den interne tilstanden. La den være `null` for å bruke ukontrollert modus
  /// med [initialIndex].
  final int? value;

  /// Kalles med den nye indeksen når valgt fane endres.
  final ValueChanged<int>? onChanged;

  /// Størrelsen på fanekomponenten. Faller tilbake til [DsSizeScope].
  final DsSize? size;

  /// Fargevarianten til fanekomponenten. Faller tilbake til [DsColorScope].
  final DsColor? color;

  @override
  State<DsTabs> createState() => _DsTabsState();
}

class _DsTabsState extends State<DsTabs> {
  late int _selectedIndex;
  late List<FocusNode> _focusNodes;

  /// Den faktiske valgte indeksen: [DsTabs.value] i kontrollert modus, ellers
  /// den interne tilstanden.
  int get _activeIndex => widget.value ?? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _clampIndex(widget.value ?? widget.initialIndex);
    _focusNodes = List.generate(widget.tabs.length, (_) => FocusNode());
  }

  @override
  void didUpdateWidget(DsTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Regenerer fokusnodene når antall faner endres, slik at indeksering holder
    // seg innenfor rekkevidde (unngår RangeError når faner legges til) og ingen
    // noder lekker (når faner fjernes). Klem også den interne tilstanden inn i
    // gyldig område.
    if (widget.tabs.length != oldWidget.tabs.length) {
      for (final node in _focusNodes) {
        node.dispose();
      }
      _focusNodes = List.generate(widget.tabs.length, (_) => FocusNode());
      _selectedIndex = _clampIndex(_selectedIndex);
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  int _clampIndex(int index) {
    if (widget.tabs.isEmpty) return 0;
    if (index < 0) return 0;
    if (index >= widget.tabs.length) return widget.tabs.length - 1;
    return index;
  }

  void _selectTab(int index) {
    // I kontrollert modus er forelderen kilden til sannhet; oppdater bare den
    // interne tilstanden i ukontrollert modus.
    if (widget.value == null) {
      setState(() => _selectedIndex = index);
    }
    widget.onChanged?.call(index);
  }

  void _moveTo(int next) {
    _selectTab(next);
    _focusNodes[next].requestFocus();
  }

  KeyEventResult _handleKeyEvent(KeyEvent event, int index) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final count = widget.tabs.length;
    if (count == 0) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _moveTo((index + 1) % count);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _moveTo((index - 1 + count) % count);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.home) {
      _moveTo(0);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.end) {
      _moveTo(count - 1);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = widget.size ?? DsSizeScope.of(context);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.fast);

    final tabHeight = switch (sizeMode) {
      DsSize.sm => 36.0,
      DsSize.md => 44.0,
      DsSize.lg => 52.0,
    };
    final fontSize = DsSizeValues.fontSize(sizeMode);
    final activeIndex = _activeIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Fanelinje (tablist).
        Semantics(
          container: true,
          explicitChildNodes: true,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colorScale.borderSubtle, width: 1),
              ),
            ),
            child: Row(
              children: List.generate(widget.tabs.length, (i) {
                return _DsTab(
                  // Knytt fanen til indeksen sin slik at den per-fane-tilstanden
                  // (og fokus-lytteren) holder seg stabil på tvers av rebuilds.
                  key: ValueKey(i),
                  focusNode: _focusNodes[i],
                  label: widget.tabs[i],
                  selected: i == activeIndex,
                  colorScale: colorScale,
                  fontFamily: theme.typography.fontFamily,
                  fontSize: fontSize,
                  height: tabHeight,
                  duration: duration,
                  onTap: () {
                    // Be om fokus slik at påfølgende piltastnavigasjon virker
                    // selv når fanen ble aktivert med mus/berøring.
                    _focusNodes[i].requestFocus();
                    _selectTab(i);
                  },
                  onKey: (event) => _handleKeyEvent(event, i),
                );
              }),
            ),
          ),
        ),
        // Panel (tabpanel).
        if (activeIndex < widget.children.length)
          Semantics(
            container: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: widget.children[activeIndex],
            ),
          ),
      ],
    );
  }
}

/// En enkelt fane i [DsTabs].
///
/// Dette er en privat [StatefulWidget] slik at bare den fokuserte fanen bygges
/// på nytt når dens egen [FocusNode] endrer fokus, i stedet for å bygge hele
/// fanelinjen på nytt ved hver fokusendring (samme mønster som DsToggleGroup).
class _DsTab extends StatefulWidget {
  const _DsTab({
    super.key,
    required this.focusNode,
    required this.label,
    required this.selected,
    required this.colorScale,
    required this.fontFamily,
    required this.fontSize,
    required this.height,
    required this.duration,
    required this.onTap,
    required this.onKey,
  });

  final FocusNode focusNode;
  final String label;
  final bool selected;
  final DsColorScale colorScale;
  final String fontFamily;
  final double fontSize;
  final double height;
  final Duration duration;
  final VoidCallback onTap;
  final KeyEventResult Function(KeyEvent event) onKey;

  @override
  State<_DsTab> createState() => _DsTabState();
}

class _DsTabState extends State<_DsTab> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
    _isFocused = widget.focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(_DsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChange);
      widget.focusNode.addListener(_handleFocusChange);
      _isFocused = widget.focusNode.hasFocus;
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    final focused = widget.focusNode.hasFocus;
    if (mounted && focused != _isFocused) {
      setState(() => _isFocused = focused);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.colorScale;

    Widget tab = AnimatedContainer(
      duration: widget.duration,
      curve: DsAnimation.defaultCurve,
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: widget.selected
                ? scale.baseDefault
                : const Color(0x00000000),
            width: 2,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        widget.label,
        style: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          fontWeight: widget.selected ? FontWeight.w500 : FontWeight.w400,
          color: widget.selected ? scale.textDefault : scale.textSubtle,
        ),
      ),
    );

    // Reserver alltid plass til fokusringen (gjennomsiktig når ikke fokusert)
    // slik at ringen aldri flytter layouten og forblir synlig ved
    // tastaturnavigasjon (WCAG 2.4.7). Valgindikatoren (understreken) beholdes.
    tab = DsFocus.reserveRing(
      focused: _isFocused,
      radius: BorderRadius.zero,
      scale: scale,
      child: tab,
    );

    return Semantics(
      button: true,
      selected: widget.selected,
      enabled: true,
      child: Focus(
        focusNode: widget.focusNode,
        onKeyEvent: (node, event) => widget.onKey(event),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: tab,
          ),
        ),
      ),
    );
  }
}
