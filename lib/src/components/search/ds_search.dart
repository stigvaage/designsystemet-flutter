import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../../utils/ds_icons.dart';
import '../input/ds_input.dart';

/// Søkefelt med forstørrelsesglass-ikon som prefiks.
///
/// Bygget på [DsInput] og videresender tekstendrings- og innsendingstilbakekall.
/// Speiler React-komposisjonen `Search` (`Search.Input` + `Search.Clear`): sett
/// [clearable] for å vise en tøm-knapp som suffiks når feltet har tekst.
/// Tøm-knappen er en fullverdig knapp som kan nås med Tab og aktiveres med
/// Enter/Mellomrom, med synlig fokusring.
class DsSearch extends StatefulWidget {
  const DsSearch({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onSubmit,
    this.size,
    this.placeholder,
    this.focusNode,
    this.clearable = false,
    this.onClear,
    this.clearLabel = 'Tøm',
    this.error,
    this.disabled = false,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
  });

  /// Kontrollerer teksten som redigeres. En kontroller opprettes internt når
  /// ingen er oppgitt.
  final TextEditingController? controller;

  /// Kalles hver gang teksten endres.
  final ValueChanged<String>? onChanged;

  /// Kalles når brukeren sender inn feltet (f.eks. trykker enter).
  final ValueChanged<String>? onSubmitted;

  /// Alias for [onSubmitted] som matcher React-navngivningen `onSubmit`. Når
  /// begge er oppgitt kalles [onSubmitted] først, deretter [onSubmit].
  final ValueChanged<String>? onSubmit;

  /// Størrelse på feltet. Faller tilbake til omsluttende `DsSizeScope`.
  final DsSize? size;

  /// Plassholdertekst som vises når feltet er tomt. Når ingen verdi oppgis er
  /// standarden «Søk...», men en tom plassholder når [clearable] er `true` (i
  /// tråd med offisiell anbefaling om tom plassholder ved tøm-knapp).
  final String? placeholder;

  /// Eksternt fokusobjekt for det underliggende feltet.
  final FocusNode? focusNode;

  /// Når `true` vises en tøm-knapp (et `x`-ikon) som suffiks mens feltet
  /// inneholder tekst. Et trykk tømmer feltet, kaller [onChanged] med tom
  /// streng, og kaller [onClear]. Knappen undertrykkes når feltet er [disabled]
  /// eller [readOnly].
  final bool clearable;

  /// Kalles etter at feltet er tømt via tøm-knappen.
  final VoidCallback? onClear;

  /// Tilgjengelig ledetekst for tøm-knappen. Standard er «Tøm».
  final String clearLabel;

  /// Feilmelding som aktiverer feiltilstand (rød kantlinje) i det
  /// underliggende [DsInput]. Faller tilbake til en omsluttende `DsField`.
  final String? error;

  /// Når `true` dempes feltet og det ignorerer all peker- og tastaturinput.
  final bool disabled;

  /// Når `true` er innholdet ikke redigerbart, men feltet kan fortsatt
  /// fokuseres og teksten markeres.
  final bool readOnly;

  /// Når `true` får feltet fokus automatisk ved første visning.
  final bool autofocus;

  /// Tastaturtype for myktastatur (f.eks. tall eller e-post).
  final TextInputType? keyboardType;

  /// Handlingen som handlingstasten på tastaturet representerer.
  final TextInputAction? textInputAction;

  /// Inndatafiltere som transformerer eller begrenser teksten mens den skrives.
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<DsSearch> createState() => _DsSearchState();
}

class _DsSearchState extends State<DsSearch> {
  TextEditingController? _ownController;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    if (widget.clearable) _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(DsSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldController = oldWidget.controller ?? _ownController;
    // Resolve through the getter so the listener is attached to the controller
    // [build] actually uses. When switching from an external controller to the
    // internal one, [_ownController] may still be null here; reading it via the
    // getter lazily creates it, ensuring the listener lands on the right
    // instance (otherwise the clear button would never show/hide).
    final newController =
        widget.controller ?? (_ownController ??= TextEditingController());
    if (oldController != newController ||
        oldWidget.clearable != widget.clearable) {
      if (oldWidget.clearable) {
        oldController?.removeListener(_onTextChanged);
      }
      if (widget.clearable) {
        newController.addListener(_onTextChanged);
      }
    }
  }

  @override
  void dispose() {
    (widget.controller ?? _ownController)?.removeListener(_onTextChanged);
    _ownController?.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Rebuild so the clear button appears/disappears as the field gains or
    // loses text.
    if (mounted) setState(() {});
  }

  void _handleSubmitted(String value) {
    widget.onSubmitted?.call(value);
    widget.onSubmit?.call(value);
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final colorScale = theme.colorScheme.resolve(DsColorScope.of(context));

    // En tom plassholder er offisiell anbefaling når en tøm-knapp er til stede;
    // ellers brukes «Søk...». En eksplisitt verdi overstyrer alltid.
    final placeholder =
        widget.placeholder ?? (widget.clearable ? '' : 'Søk...');

    // Et tomt felt har ingenting å tømme, og et deaktivert/skrivebeskyttet felt
    // skal ikke kunne tømmes.
    final showClear =
        widget.clearable &&
        !widget.disabled &&
        !widget.readOnly &&
        _controller.text.isNotEmpty;

    return DsInput(
      controller: _controller,
      size: widget.size,
      error: widget.error,
      disabled: widget.disabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onSubmitted: _handleSubmitted,
      focusNode: widget.focusNode,
      placeholder: placeholder,
      prefix: Icon(DsIcons.search, size: 16, color: colorScale.textSubtle),
      suffix: showClear
          ? _ClearButton(
              colorScale: colorScale,
              label: widget.clearLabel,
              onClear: _clear,
            )
          : null,
    );
  }
}

/// Tøm-knapp (`x`-ikon) for [DsSearch].
///
/// En fullverdig, tastaturbetjenbar knapp som speiler `DsChip` sin
/// fjern-knapp og `DsAlert` sin lukke-knapp: den kan nås med Tab, aktiveres med
/// Enter/Mellomrom og via trykk, viser en reservert fokusring uten å forskyve
/// oppsettet, og eksponerer knapp-semantikk med en tilgjengelig ledetekst og en
/// `onTap`-handling for hjelpemiddelteknologi.
class _ClearButton extends StatefulWidget {
  const _ClearButton({
    required this.colorScale,
    required this.label,
    required this.onClear,
  });

  final DsColorScale colorScale;
  final String label;
  final VoidCallback onClear;

  @override
  State<_ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<_ClearButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    // Sentrert glyf inni et trykkmål på minst 24x24 logiske piksler
    // (WCAG 2.2 SC 2.5.8). Tallet styrer treffareal/oppsett, ikke visuell
    // stil, og er derfor ikke en hardkodet visuell verdi.
    Widget icon = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: Icon(DsIcons.x, size: 16, color: widget.colorScale.textSubtle),
      ),
    );

    // Reserver fokusringen alltid for å unngå at oppsettet forskyves.
    icon = DsFocus.reserveRing(
      focused: _isFocused,
      radius: BorderRadius.circular(DsFocus.ringWidth),
      scale: widget.colorScale,
      child: icon,
    );

    return Semantics(
      button: true,
      enabled: true,
      label: widget.label,
      onTap: widget.onClear,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            widget.onClear();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onClear,
            child: icon,
          ),
        ),
      ),
    );
  }
}
