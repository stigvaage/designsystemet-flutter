import 'package:flutter/rendering.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_size_tokens.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../field/ds_field.dart';

/// Core text input component styled with Designsystemet tokens.
///
/// Built directly on [EditableText] from `package:flutter/widgets.dart` — no
/// Material or Cupertino dependency. The visual chrome (border, background,
/// padding, focus ring) and the placeholder are drawn by this widget around
/// the bare editor, so cursor, selection and text colours come straight from
/// [DsTheme] tokens.
///
/// Prefer [DsTextfield] for single-line inputs or [DsField] to add labels.
class DsInput extends StatefulWidget {
  const DsInput({
    super.key,
    this.controller,
    this.size,
    this.error,
    this.disabled = false,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.placeholder,
    this.textInputAction,
    this.inputFormatters,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.textAlign = TextAlign.start,
  });

  /// Eksternt felt for å lese/skrive verdien. Når `null` oppretter feltet sin
  /// egen kontroller og holder den i live så lenge widgeten lever.
  final TextEditingController? controller;

  /// Størrelse på feltet. Faller tilbake til [DsSizeScope] når `null`.
  final DsSize? size;

  /// Feilmelding som aktiverer feiltilstand (rød kantlinje). Faller tilbake til
  /// [DsFieldScope.error] når `null`, slik at en omsluttende [DsField] kan styre
  /// tilstanden.
  final String? error;

  /// Når `true` dempes feltet ([Opacity]) og det ignorerer all peker-input
  /// ([IgnorePointer]). Kan ikke fokuseres eller åpne tastatur.
  final bool disabled;

  /// Når `true` er innholdet ikke redigerbart, men feltet kan fortsatt
  /// fokuseres og teksten markeres. Tastaturet åpnes ikke, og kantlinjen i
  /// hviletilstand fjernes (fokusringen vises fortsatt).
  final bool readOnly;

  /// Valgfritt innhold til venstre for tekstfeltet (f.eks. et ikon). Et trykk i
  /// prefiks-området fokuserer feltet med mindre prefikset selv håndterer trykk.
  final Widget? prefix;

  /// Valgfritt innhold til høyre for tekstfeltet (f.eks. et ikon eller en
  /// tøm-knapp). Et trykk i suffiks-området fokuserer feltet.
  final Widget? suffix;

  /// Kalles for hvert tastetrykk når verdien endres.
  final ValueChanged<String>? onChanged;

  /// Kalles når brukeren utløser handlingstasten på tastaturet (f.eks. «ferdig»
  /// eller linjeskift). Skiller seg fra [onChanged] som fyrer ved hver endring.
  final ValueChanged<String>? onSubmitted;

  /// Eksternt fokusobjekt. Når `null` oppretter feltet sitt eget.
  final FocusNode? focusNode;

  /// Tastaturtype for myktastatur (f.eks. tall eller e-post).
  final TextInputType? keyboardType;

  /// Når `true` skjules tegnene (passordfelt).
  final bool obscureText;

  /// Maksimalt antall tegn. Håndheves via en [LengthLimitingTextInputFormatter]
  /// (ingen synlig teller vises).
  final int? maxLength;

  /// Maksimalt antall linjer. `1` gir et enkeltlinjefelt; en høyere verdi gjør
  /// feltet flerlinjet og lar det vokse opp til dette antallet.
  final int? maxLines;

  /// Minste antall synlige linjer for et flerlinjefelt. `null` lar feltet starte
  /// på én linje.
  final int? minLines;

  /// Når `true` får feltet fokus automatisk ved første visning.
  final bool autofocus;

  /// Plassholdertekst som vises når feltet er tomt. Erstatter ikke en etikett.
  final String? placeholder;

  /// Handlingen som handlingstasten på tastaturet representerer.
  final TextInputAction? textInputAction;

  /// Inndatafiltere som transformerer eller begrenser teksten mens den skrives.
  final List<TextInputFormatter>? inputFormatters;

  /// Når `true` foreslår plattformen rettelser mens brukeren skriver.
  final bool autocorrect;

  /// Når `true` viser plattformen skriveforslag.
  final bool enableSuggestions;

  /// Hvordan plattformen automatisk gjør tekst til store bokstaver.
  final TextCapitalization textCapitalization;

  /// Kalles når brukeren trykker på feltet. Utløses i tillegg til at feltet
  /// fokuseres.
  final VoidCallback? onTap;

  /// Horisontal justering av teksten i feltet.
  final TextAlign textAlign;

  @override
  State<DsInput> createState() => _DsInputState();
}

class _DsInputState extends State<DsInput> {
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;
  bool _isHovered = false;
  bool _isFocused = false;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  @override
  void didUpdateWidget(DsInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_onFocusChange);
      _focusNode.addListener(_onFocusChange);
      _isFocused = _focusNode.hasFocus;
    }
    // Reconcile controller swaps the same way _ownFocusNode is handled: when
    // the parent hands us an external controller (or takes one away), carry the
    // current text/selection across the boundary so the visible value does not
    // jump or get lost, then dispose the now-unused _ownController.
    if (widget.controller != oldWidget.controller) {
      // Keep the placeholder-overlay listener attached to whichever controller
      // is currently active.
      (oldWidget.controller ?? _ownController)?.removeListener(_onTextChange);
      // The value the field showed before the swap. When the old widget had no
      // external controller, that value lives in our _ownController.
      final previous = (oldWidget.controller ?? _ownController)?.value;
      if (widget.controller != null) {
        // Switching to (or between) an external controller. Preserve continuity
        // only when we owned the previous value and the incoming controller is
        // still empty, so we never clobber text the parent already set.
        if (oldWidget.controller == null &&
            previous != null &&
            widget.controller!.value == TextEditingValue.empty) {
          widget.controller!.value = previous;
        }
        // We no longer need our own controller; dispose it like _ownFocusNode is
        // disposed once an external node takes over (in dispose()).
        _ownController?.dispose();
        _ownController = null;
      } else if (previous != null) {
        // Switching back to internal management: seed a fresh _ownController
        // from the value the external controller last showed.
        (_ownController ??= TextEditingController()).value = previous;
      }
      _controller.addListener(_onTextChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    (widget.controller ?? _ownController)?.removeListener(_onTextChange);
    _ownController?.dispose();
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus) _ensureVisibleAboveKeyboard();
  }

  // Rebuilds so the placeholder overlay appears/disappears as the field goes
  // empty/non-empty. EditableText draws no hint of its own, so the overlay is
  // the only placeholder.
  void _onTextChange() {
    if (mounted) setState(() {});
  }

  /// Scrolls the focused field above the soft keyboard so the user can see
  /// what they are typing. No-op when the field is not inside a [Scrollable]
  /// (keyboard avoidance is then left to Scaffold.resizeToAvoidBottomInset).
  ///
  /// Runs one extra frame after focus so it targets the post-keyboard
  /// (shrunken) viewport instead of racing EditableText's own caret reveal;
  /// it converges to the same end state, so the two do not oscillate.
  void _ensureVisibleAboveKeyboard() {
    if (widget.readOnly) return; // read-only fields don't open the keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_focusNode.hasFocus) return;
      if (Scrollable.maybeOf(context) == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_focusNode.hasFocus || !context.mounted) return;
        // keepVisibleAtStart only scrolls when the field is NOT already
        // visible, so fields already on screen are left in place.
        Scrollable.ensureVisible(
          context,
          duration: DsAnimation.resolveDuration(
            context,
            const Duration(milliseconds: 150),
          ),
          curve: Curves.easeOut,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final dangerScale = theme.colorScheme.danger;
    final sizeMode = widget.size ?? DsSizeScope.of(context);
    final effectiveError = widget.error ?? DsFieldScope.of(context)?.error;
    final hasError = effectiveError != null;
    final radius = BorderRadius.circular(theme.borderRadius.defaultRadius);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.fast);

    final padding = sizeMode.pick(
      sm: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      md: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      lg: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    final fontSize = DsSizeValues.fontSize(sizeMode);

    Color borderColor;
    if (widget.disabled) {
      borderColor = colorScale.borderDefault;
    } else if (hasError) {
      borderColor = dangerScale.borderDefault;
    } else if (_isFocused) {
      borderColor = colorScale.borderStrong;
    } else if (_isHovered) {
      borderColor = colorScale.borderStrong;
    } else {
      borderColor = colorScale.borderDefault;
    }

    final borderSide = widget.readOnly
        ? BorderSide.none
        : BorderSide(color: borderColor, width: 1);

    final textStyle = TextStyle(
      fontFamily: theme.typography.fontFamily,
      fontSize: fontSize,
      color: colorScale.textDefault,
    );

    // maxLines == 1 keeps the editor single-line; a higher value makes it
    // multi-line. EditableText has no maxLength of its own, so the limit is
    // enforced with a formatter (the previous TextField counter was suppressed
    // anyway).
    final formatters = <TextInputFormatter>[
      ...?widget.inputFormatters,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(widget.maxLength),
    ];

    final editor = EditableText(
      controller: _controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly || widget.disabled,
      obscureText: widget.obscureText,
      style: textStyle,
      strutStyle: StrutStyle.fromTextStyle(textStyle),
      cursorColor: colorScale.baseDefault,
      backgroundCursorColor: colorScale.surfaceDefault,
      selectionColor: colorScale.surfaceActive,
      cursorWidth: 2,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: formatters,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTapOutside: (_) {},
      rendererIgnoresPointer: false,
      // No Material/Cupertino-free built-in TextSelectionControls exists, so
      // selectionControls is omitted: basic editing, caret placement and
      // keyboard-driven selection all keep working.
    );

    // Placeholder is drawn by us (EditableText has no hint): shown only while
    // the field is empty. IgnorePointer keeps taps falling through to the
    // editor/Listener so it never steals the first-tap keyboard open.
    final showPlaceholder =
        widget.placeholder != null && _controller.text.isEmpty;

    Widget editorStack = Stack(
      children: [
        if (showPlaceholder)
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: widget.textAlign == TextAlign.center
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: Text(
                  widget.placeholder!,
                  maxLines: widget.maxLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign: widget.textAlign,
                  style: textStyle.copyWith(color: colorScale.textSubtle),
                ),
              ),
            ),
          ),
        editor,
      ],
    );

    // EditableText requires WidgetsLocalizations + Directionality ancestors.
    // Directionality is already provided up the tree; only add a self-contained
    // Localizations scope (widgets-only — NO Material) when none is present.
    // isApplicationLevel: true suppresses the localeForSubtree Semantics node
    // that a nested Localizations would otherwise inject — keeping it would
    // mask the EditableText's own textField semantics node. Since we only add
    // this scope when no Localizations ancestor exists, it IS the
    // application-level localizations for this subtree.
    final hasWidgetsLocalizations =
        Localizations.of<WidgetsLocalizations>(context, WidgetsLocalizations) !=
        null;
    if (!hasWidgetsLocalizations) {
      final locale = Localizations.maybeLocaleOf(context) ?? const Locale('en');
      editorStack = Localizations(
        locale: locale,
        delegates: const [DefaultWidgetsLocalizations.delegate],
        isApplicationLevel: true,
        child: editorStack,
      );
    }

    final canFocusByTap = !widget.disabled && !widget.readOnly;

    // Listener (not GestureDetector) does not enter the gesture arena, so taps
    // reach EditableText's own gesture handling unhindered. onPointerDown
    // requests focus for taps anywhere in the field — including the content
    // padding / prefix / suffix gutters that EditableText itself does not
    // hit-test — so the keyboard opens on the FIRST tap (EditableText opens its
    // input connection as soon as it gains focus). The keyboard-open behaviour
    // is what the regression tests assert.
    Widget result = Listener(
      onPointerDown: (_) {
        if (canFocusByTap && !_focusNode.hasFocus) {
          _focusNode.requestFocus();
          widget.onTap?.call();
        }
      },
      child: AnimatedContainer(
        duration: duration,
        curve: DsAnimation.defaultCurve,
        decoration: BoxDecoration(
          color: widget.readOnly
              ? colorScale.surfaceDefault
              : colorScale.backgroundDefault,
          borderRadius: radius,
          border: Border.fromBorderSide(borderSide),
        ),
        child: Row(
          children: [
            if (widget.prefix != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: widget.prefix!,
              ),
            Expanded(
              child: Padding(padding: padding, child: editorStack),
            ),
            if (widget.suffix != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: widget.suffix!,
              ),
          ],
        ),
      ),
    );

    // The focus-ring wrapper is ALWAYS in the tree (its space is always
    // reserved); only its decoration toggles. DsFocus.reserveRing keeps the
    // DecoratedBox+Padding structure constant regardless of focus state — so
    // the widget type under the MouseRegion never changes and the EditableText
    // element is not torn down. It also removes the 3px layout jump on focus by
    // reserving the ring gap whether focused or not. A focused read-only field
    // still shows the ring (only `disabled` suppresses it), so a keyboard user
    // always has a visible focus indicator.
    final showFocusRing = _isFocused && !widget.disabled;
    result = DsFocus.reserveRing(
      focused: showFocusRing,
      radius: radius,
      scale: colorScale,
      child: result,
    );

    if (widget.disabled) {
      result = IgnorePointer(
        child: Opacity(opacity: theme.disabledOpacity, child: result),
      );
    }

    result = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: result,
    );

    // EditableText's semantics differ from a Material TextField's, so describe
    // the field explicitly: it is a text field, exposes its current value, the
    // placeholder as a label, and its enabled/read-only state for assistive
    // tech. The error state is surfaced both as an invalid `validationResult`
    // (the aria-invalid equivalent) and as a hint carrying the message, so
    // screen readers announce the validation problem and associate it with the
    // field.
    return Semantics(
      textField: true,
      label: widget.placeholder,
      value: _controller.text,
      hint: effectiveError,
      enabled: !widget.disabled,
      readOnly: widget.readOnly,
      validationResult: hasError
          ? SemanticsValidationResult.invalid
          : SemanticsValidationResult.none,
      child: result,
    );
  }
}
