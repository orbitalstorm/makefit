import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/makefit_models.dart';

/// Palette Tactique OLED MakeFit (`v1.0.0` — Skill `mobile-game-ui v1.2.0`).
class MakeFitTheme {
  const MakeFitTheme._();

  static const Color oledBlack = Color(0xFF0A0E14);
  static const Color slateSurface = Color(0xFF111823);
  static const Color slateCard = Color(0xFF161F2E);
  static const Color slateBorder = Color(0xFF263347);
  static const Color amberTactical = Color(0xFFF59E0B);
  static const Color amberLip = Color(0xFFB45309);
  static const Color cyanRadar = Color(0xFF06B6D4);
  static const Color cyanLip = Color(0xFF0E7490);
  static const Color emeraldH2f = Color(0xFF10B981);
  static const Color emeraldLip = Color(0xFF047857);
  static const Color coralAlert = Color(0xFFEF4444);
  static const Color coralLip = Color(0xFFB91C1C);
  static const Color purpleCore = Color(0xFF8B5CF6);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
}

/// Bouton 3D Tactique à Squash & Stretch immédiat (`scale: 0.94` sur `Listener.onPointerDown`,
/// rebond `Curves.elasticOut`, bordure 3D inférieure `5dp`, `HapticFeedback`).
class JuicyTactical3DButton extends StatefulWidget {
  const JuicyTactical3DButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.subtitle,
    this.icon,
    this.backgroundColor = MakeFitTheme.amberTactical,
    this.bottomLipColor = MakeFitTheme.amberLip,
    this.foregroundColor = MakeFitTheme.oledBlack,
    this.height = 56,
    this.expand = true,
    this.lipDepth = 5.0,
    this.fontSize = 14.0,
  });

  final String label;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color bottomLipColor;
  final Color foregroundColor;
  final double height;
  final bool expand;
  final double lipDepth;
  final double fontSize;

  @override
  State<JuicyTactical3DButton> createState() => _JuicyTactical3DButtonState();
}

class _JuicyTactical3DButtonState extends State<JuicyTactical3DButton> {
  bool _isPressed = false;

  void _handlePointerDown(PointerDownEvent _) {
    if (widget.onPressed == null) {
      return;
    }
    HapticFeedback.lightImpact();
    if (!_isPressed && mounted) {
      setState(() => _isPressed = true);
    }
  }

  void _handlePointerUp(PointerUpEvent _) {
    if (_isPressed && mounted) {
      setState(() => _isPressed = false);
    }
  }

  void _handlePointerCancel(PointerCancelEvent _) {
    if (_isPressed && mounted) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTap() {
    if (widget.onPressed == null) {
      return;
    }
    HapticFeedback.mediumImpact();
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onPressed != null;
    final Color bg = enabled ? widget.backgroundColor : const Color(0xFF334155);
    final Color lip = enabled ? widget.bottomLipColor : const Color(0xFF1E293B);
    final Color fg = enabled ? widget.foregroundColor : const Color(0xFF94A3B8);
    final double currentLip = _isPressed ? 1.0 : widget.lipDepth;
    final double translateY = _isPressed ? (widget.lipDepth - 1.0) : 0.0;

    final Widget buttonBody = Listener(
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.94 : 1.0,
          duration: Duration(milliseconds: _isPressed ? 70 : 320),
          curve: _isPressed ? Curves.easeOutCubic : Curves.elasticOut,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 48,
              minHeight: widget.height,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 75),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(0, translateY, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                  width: 1.0,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: lip,
                    blurRadius: 0,
                    offset: Offset(0, currentLip),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize:
                    widget.expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (widget.icon != null) ...<Widget>[
                    Icon(widget.icon, color: fg, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: fg,
                            fontWeight: FontWeight.w900,
                            fontSize: widget.fontSize,
                            letterSpacing: 0.6,
                          ),
                        ),
                        if (widget.subtitle != null) ...<Widget>[
                          const SizedBox(height: 2),
                          Text(
                            widget.subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: fg.withValues(alpha: 0.82),
                              fontWeight: FontWeight.w700,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.expand) {
      return SizedBox(width: double.infinity, child: buttonBody);
    }
    return buttonBody;
  }
}

/// Compteur de TXP interpolé via `TweenAnimationBuilder<double>` (`Curves.easeOutCubic`)
/// isolé dans un `RepaintBoundary` pour préserver le 60/120 FPS sans rebuild global.
class InterpolatedTxpCounter extends StatelessWidget {
  const InterpolatedTxpCounter({
    super.key,
    required this.txpValue,
    this.prefix = '',
    this.suffix = ' TXP',
    this.style,
    this.duration = const Duration(milliseconds: 650),
  });

  final int txpValue;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final TextStyle effectiveStyle = style ??
        const TextStyle(
          color: MakeFitTheme.amberTactical,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
        );

    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: txpValue.toDouble(), end: txpValue.toDouble()),
        duration: duration,
        curve: Curves.easeOutCubic,
        builder: (BuildContext context, double animatedValue, Widget? _) {
          final int rounded = animatedValue.round();
          return Text(
            '$prefix$rounded$suffix',
            style: effectiveStyle,
          );
        },
      ),
    );
  }
}

/// Anneau lumineux animé `4s Inspire • 4s Plein • 4s Expire • 4s Vide`
/// pour la phase `WorkoutStepStage.h2fCooldown` (Box Breathing Navy SEAL).
class BoxBreathingRing extends StatelessWidget {
  const BoxBreathingRing({
    super.key,
    required this.phase,
    required this.stepElapsedSeconds,
    this.size = 148,
  });

  final BoxBreathingPhase phase;
  final int stepElapsedSeconds;
  final double size;

  @override
  Widget build(BuildContext context) {
    final int secondInPhase = (stepElapsedSeconds % 4) + 1;
    final double targetScale = switch (phase) {
      BoxBreathingPhase.inhale => 0.82 + (secondInPhase / 4.0) * 0.22,
      BoxBreathingPhase.holdFull => 1.04,
      BoxBreathingPhase.exhale => 1.04 - (secondInPhase / 4.0) * 0.22,
      BoxBreathingPhase.holdEmpty => 0.82,
    };

    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MakeFitTheme.slateCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: phase.color.withValues(alpha: 0.65),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.air_rounded, color: phase.color, size: 18),
                const SizedBox(width: 6),
                const Flexible(
                  child: Text(
                    'BOX BREATHING NAVY SEAL (4-4-4-4)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MakeFitTheme.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size,
              height: size,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: targetScale, end: targetScale),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
                builder: (BuildContext context, double scale, Widget? child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: <Color>[
                            phase.color.withValues(alpha: 0.32),
                            phase.color.withValues(alpha: 0.06),
                          ],
                        ),
                        border: Border.all(
                          color: phase.color,
                          width: 4,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: phase.color.withValues(alpha: 0.35),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${secondInPhase}S / 4S',
                      style: TextStyle(
                        color: phase.color,
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        fontFeatures: const <FontFeature>[
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        phase.instruction,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '4s Inspire • 4s Plein • 4s Expire • 4s Vide',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MakeFitTheme.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sélecteur 1-Tap des 5 niveaux RPE (`1 Recon` à `5 Surchauffe`) avec code couleur
/// sémantique et bonus d'honnêteté `+15 / +25 TXP`.
class RpeSelectorBar extends StatelessWidget {
  const RpeSelectorBar({
    super.key,
    required this.selectedRpe,
    required this.onRpeSelected,
  });

  final int selectedRpe;
  final ValueChanged<int> onRpeSelected;

  static const List<_RpeOptionSpec> _options = <_RpeOptionSpec>[
    _RpeOptionSpec(
      score: 1,
      shortTitle: '1 Recon',
      detail: 'Très facile (≥5 RIR)',
      bonusLabel: '+15 TXP',
      color: MakeFitTheme.emeraldH2f,
    ),
    _RpeOptionSpec(
      score: 2,
      shortTitle: '2 Patrouille',
      detail: 'Fluide (3-4 RIR)',
      bonusLabel: '+15 TXP',
      color: MakeFitTheme.cyanRadar,
    ),
    _RpeOptionSpec(
      score: 3,
      shortTitle: '3 Standard',
      detail: 'Optimal H2F (2 RIR)',
      bonusLabel: '+25 TXP',
      color: MakeFitTheme.amberTactical,
    ),
    _RpeOptionSpec(
      score: 4,
      shortTitle: '4 Combat',
      detail: 'Intense (0-1 RIR)',
      bonusLabel: '+25 TXP',
      color: Color(0xFFF97316),
    ),
    _RpeOptionSpec(
      score: 5,
      shortTitle: '5 Surchauffe',
      detail: 'Deload J+1 (-20%)',
      bonusLabel: '+25 TXP',
      color: MakeFitTheme.coralAlert,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'CALIBRATION AUTO-RÉGULATION RPE (1-TAP)',
          style: TextStyle(
            color: MakeFitTheme.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 12.5,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _options.map((_RpeOptionSpec opt) {
            final bool isSelected = opt.score == selectedRpe;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onRpeSelected(opt.score);
                  },
                  child: AnimatedScale(
                    scale: isSelected ? 1.03 : 0.96,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      constraints: const BoxConstraints(minHeight: 74),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? opt.color.withValues(alpha: 0.24)
                            : MakeFitTheme.slateSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? opt.color
                              : MakeFitTheme.slateBorder,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'RPE ${opt.score}',
                            style: TextStyle(
                              color: opt.color,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            opt.shortTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: MakeFitTheme.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: opt.color.withValues(alpha: 0.20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              opt.bonusLabel,
                              style: TextStyle(
                                color: opt.color,
                                fontWeight: FontWeight.w900,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(growable: false),
        ),
      ],
    );
  }
}

class _RpeOptionSpec {
  const _RpeOptionSpec({
    required this.score,
    required this.shortTitle,
    required this.detail,
    required this.bonusLabel,
    required this.color,
  });

  final int score;
  final String shortTitle;
  final String detail;
  final String bonusLabel;
  final Color color;
}
