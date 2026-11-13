import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/makefit_models.dart';

/// Composants vectoriels haute précision MakeFit (@Leonardo — v1.0.0) :
/// - [MakeFitLogoBadge] : Bouclier commando heptagonal/hexagonal biseauté,
///   doubles chevrons d'officier 3D, athlète en planche/poussée et étoile SpecOps.
/// - [MilitaryRankBadge] : Insignes vectoriels authentiques des 12 Grades
///   Militaires (`E-1` à `SF-2`) avec chevrons, arcs (rockers), barres d'officier,
///   étoiles facettées, couronne de lauriers et dague commando SpecOps.
/// - [BiomechanicalFamilyBadge] : Emblèmes techniques des 5 Familles Biomécaniques
///   (`PUSH`, `PULL`, `LEGS`, `CORE`, `METCON`).
/// - [CampaignThumbnailBanner] : Bannière vectorielle tactique des 4 Campagnes
///   Opérationnelles 28 Jours (grille radar, topographie commando, insigne d'opération).
/// - [TacticalDogTagIcon] : Plaques d'identité militaires (Jetons de Permission Tactique).
class MakeFitLogoBadge extends StatelessWidget {
  const MakeFitLogoBadge({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(
        painter: _MakeFitShieldLogoPainter(),
      ),
    );
  }
}

class _MakeFitShieldLogoPainter extends CustomPainter {
  const _MakeFitShieldLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w * 0.50, h * 0.50);

    // 1. Calque Silhouette & Blindage Extérieur Biseauté
    final Path outerShield = Path()
      ..moveTo(w * 0.50, h * 0.04)
      ..lineTo(w * 0.91, h * 0.19)
      ..lineTo(w * 0.85, h * 0.70)
      ..lineTo(w * 0.50, h * 0.96)
      ..lineTo(w * 0.15, h * 0.70)
      ..lineTo(w * 0.09, h * 0.19)
      ..close();

    // Ombre portée externe
    canvas.drawPath(
      outerShield.shift(Offset(0, h * 0.02)),
      Paint()..color = const Color(0xAA020408),
    );

    // Remplissage blindage acier brossé
    canvas.drawPath(
      outerShield,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFE2E8F0),
            Color(0xFF64748B),
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
          stops: <double>[0.0, 0.35, 0.72, 1.0],
        ).createShader(Offset.zero & size),
    );

    // Contour Or/Ambre Tactique
    canvas.drawPath(
      outerShield,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFEF08A),
            Color(0xFFF59E0B),
            Color(0xFFB45309),
          ],
        ).createShader(Offset.zero & size)
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = w * 0.042,
    );

    // Cœur Carbone OLED interne
    final Path innerShield = Path()
      ..moveTo(w * 0.50, h * 0.11)
      ..lineTo(w * 0.84, h * 0.24)
      ..lineTo(w * 0.79, h * 0.67)
      ..lineTo(w * 0.50, h * 0.89)
      ..lineTo(w * 0.21, h * 0.67)
      ..lineTo(w * 0.16, h * 0.24)
      ..close();

    canvas.drawPath(
      innerShield,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF162238),
            Color(0xFF0A0E14),
            Color(0xFF06080D),
          ],
        ).createShader(Offset.zero & size),
    );

    // Liseré interne Émeraude Night-Vision
    canvas.drawPath(
      innerShield,
      Paint()
        ..color = const Color(0xFF10B981).withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.016,
    );

    // Anneau télémétrique Cyan Radar
    canvas.drawCircle(
      center,
      w * 0.26,
      Paint()
        ..color = const Color(0xFF06B6D4).withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.014,
    );

    // 2. Sous-ensembles : Doubles Chevrons d'Officier Biseautés 3D
    _drawBeveledChevron(
      canvas: canvas,
      size: size,
      apexY: h * 0.29,
      wingY: h * 0.48,
      thickness: h * 0.078,
      halfSpan: w * 0.25,
    );
    _drawBeveledChevron(
      canvas: canvas,
      size: size,
      apexY: h * 0.41,
      wingY: h * 0.57,
      thickness: h * 0.068,
      halfSpan: w * 0.21,
    );

    // 3. Silhouette Athlétique Géométrique en Planche / Poussée Dynamique
    // Plateforme d'appui Émeraude Night-Vision
    final Paint platformPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = h * 0.036;
    canvas.drawLine(
      Offset(w * 0.26, h * 0.69),
      Offset(w * 0.74, h * 0.69),
      platformPaint,
    );

    // Ligne de corps gainée (Chevilles -> Bassin -> Épaules)
    final Path bodyPlank = Path()
      ..moveTo(w * 0.29, h * 0.65)
      ..lineTo(w * 0.58, h * 0.54)
      ..lineTo(w * 0.60, h * 0.585)
      ..lineTo(w * 0.31, h * 0.67)
      ..close();
    canvas.drawPath(bodyPlank, Paint()..color = const Color(0xFFF8FAFC));

    // Bras d'appui fléchi à 45° (Humérus + Avant-bras)
    final Path armPath = Path()
      ..moveTo(w * 0.59, h * 0.56)
      ..lineTo(w * 0.65, h * 0.615)
      ..lineTo(w * 0.63, h * 0.68);
    canvas.drawPath(
      armPath,
      Paint()
        ..color = const Color(0xFFE2E8F0)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = w * 0.042,
    );

    // Nœud articulaire deltoïde/épaule (Ambre)
    canvas.drawCircle(
      Offset(w * 0.59, h * 0.56),
      w * 0.032,
      Paint()..color = const Color(0xFFF59E0B),
    );

    // Tête / Visière tactique alignée
    canvas.drawCircle(
      Offset(w * 0.655, h * 0.525),
      w * 0.028,
      Paint()..color = const Color(0xFFF8FAFC),
    );

    // 4. Étoile SpecOps à 5 branches au sommet + Rivets
    _drawFivePointStar(
      canvas: canvas,
      center: Offset(w * 0.50, h * 0.205),
      outerRadius: w * 0.068,
      innerRadius: w * 0.029,
      fillColor: const Color(0xFFFEF08A),
      strokeColor: const Color(0xFFF59E0B),
    );

    // Rivets mécaniques aux 6 sommets
    final Paint rivetPaint = Paint()..color = const Color(0xFFE2E8F0);
    final List<Offset> rivets = <Offset>[
      Offset(w * 0.50, h * 0.075),
      Offset(w * 0.87, h * 0.21),
      Offset(w * 0.82, h * 0.68),
      Offset(w * 0.50, h * 0.92),
      Offset(w * 0.18, h * 0.68),
      Offset(w * 0.13, h * 0.21),
    ];
    for (final Offset pt in rivets) {
      canvas.drawCircle(pt, w * 0.013, rivetPaint);
    }
  }

  void _drawBeveledChevron({
    required Canvas canvas,
    required Size size,
    required double apexY,
    required double wingY,
    required double thickness,
    required double halfSpan,
  }) {
    final double cx = size.width * 0.50;
    final Path leftWing = Path()
      ..moveTo(cx, apexY)
      ..lineTo(cx - halfSpan, wingY)
      ..lineTo(cx - halfSpan, wingY + thickness)
      ..lineTo(cx, apexY + thickness)
      ..close();

    final Path rightWing = Path()
      ..moveTo(cx, apexY)
      ..lineTo(cx + halfSpan, wingY)
      ..lineTo(cx + halfSpan, wingY + thickness)
      ..lineTo(cx, apexY + thickness)
      ..close();

    canvas.drawPath(
      leftWing,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFFFEF08A), Color(0xFFF59E0B)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      rightWing,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFFD97706), Color(0xFF92400E)],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Insigne vectoriel haute précision des 12 Grades Militaires (`E-1` à `SF-2`).
class MilitaryRankBadge extends StatelessWidget {
  const MilitaryRankBadge({
    super.key,
    required this.rank,
    this.size = 44,
    this.isLocked = false,
  });

  final MilitaryRank rank;
  final double size;
  final bool isLocked;

  static Color primaryColorForRank(MilitaryRank rank, {required bool isLocked}) {
    if (isLocked) {
      return const Color(0xFF475569);
    }
    if (rank.order >= 11) {
      return const Color(0xFFEF4444); // SpecOps (SF-1, SF-2)
    }
    if (rank.order >= 8) {
      return const Color(0xFF06B6D4); // Officiers (O-1 à O-3)
    }
    if (rank.order >= 5) {
      return const Color(0xFF10B981); // Sous-Officiers NCO (E-5 à E-7)
    }
    return const Color(0xFFF59E0B); // Enrôlés (E-1 à E-4)
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = primaryColorForRank(rank, isLocked: isLocked);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: _MilitaryRankInsigniaPainter(
                rank: rank,
                isLocked: isLocked,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.78),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size * 0.08,
                vertical: size * 0.01,
              ),
              decoration: BoxDecoration(
                color: const Color(0xEE0A0E14),
                borderRadius: BorderRadius.circular(size * 0.08),
                border: Border.all(
                  color: primary.withValues(alpha: 0.85),
                  width: math.max(1.0, size * 0.025),
                ),
              ),
              child: Text(
                rank.code,
                maxLines: 1,
                style: TextStyle(
                  color: isLocked ? const Color(0xFF94A3B8) : Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: size * 0.19,
                  height: 1.0,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MilitaryRankInsigniaPainter extends CustomPainter {
  const _MilitaryRankInsigniaPainter({
    required this.rank,
    required this.isLocked,
  });

  final MilitaryRank rank;
  final bool isLocked;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Color primary =
        MilitaryRankBadge.primaryColorForRank(rank, isLocked: isLocked);
    final Color highlight = isLocked
        ? const Color(0xFF94A3B8)
        : Color.lerp(primary, Colors.white, 0.45)!;
    final Color goldAccent =
        isLocked ? const Color(0xFF64748B) : const Color(0xFFF59E0B);

    // 1. Écusson Tactique Biseauté
    final Path shield = Path()
      ..moveTo(w * 0.50, h * 0.04)
      ..lineTo(w * 0.90, h * 0.18)
      ..lineTo(w * 0.84, h * 0.74)
      ..lineTo(w * 0.50, h * 0.96)
      ..lineTo(w * 0.16, h * 0.74)
      ..lineTo(w * 0.10, h * 0.18)
      ..close();

    canvas.drawPath(
      shield,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF1E293B),
            Color(0xFF0F172A),
            Color(0xFF070A0F),
          ],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      shield,
      Paint()
        ..color = primary
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = math.max(1.5, w * 0.045),
    );

    // 2. Motif authentique selon le grade (E-1 à SF-2)
    switch (rank) {
      case MilitaryRank.e1Recruit:
        // Barre horizontale de recrue + étoile de calibration
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(w * 0.50, h * 0.48),
              width: w * 0.44,
              height: h * 0.08,
            ),
            Radius.circular(w * 0.02),
          ),
          Paint()..color = highlight,
        );
        _drawFivePointStar(
          canvas: canvas,
          center: Offset(w * 0.50, h * 0.31),
          outerRadius: w * 0.075,
          innerRadius: w * 0.032,
          fillColor: primary,
        );
      case MilitaryRank.e2Private:
        // 1 Chevron commando + losange
        _drawRankChevron(canvas, w, h, h * 0.28, h * 0.075, highlight, primary);
        _drawDiamond(canvas, Offset(w * 0.50, h * 0.52), w * 0.06, goldAccent);
      case MilitaryRank.e3Corporal:
        // 2 Chevrons + étoile d'épreuve PT
        _drawRankChevron(canvas, w, h, h * 0.23, h * 0.065, highlight, primary);
        _drawRankChevron(canvas, w, h, h * 0.35, h * 0.065, highlight, primary);
        _drawFivePointStar(
          canvas: canvas,
          center: Offset(w * 0.50, h * 0.55),
          outerRadius: w * 0.062,
          innerRadius: w * 0.026,
          fillColor: highlight,
        );
      case MilitaryRank.e4Sergeant:
        // 3 Chevrons + losange tactique
        _drawRankChevron(canvas, w, h, h * 0.19, h * 0.055, highlight, primary);
        _drawRankChevron(canvas, w, h, h * 0.29, h * 0.055, highlight, primary);
        _drawRankChevron(canvas, w, h, h * 0.39, h * 0.055, highlight, primary);
        _drawDiamond(canvas, Offset(w * 0.50, h * 0.57), w * 0.055, highlight);
      case MilitaryRank.e5StaffSergeant:
        // 3 Chevrons + 1 Arc inférieur (Rocker) + étoile NCO
        _drawRankChevron(canvas, w, h, h * 0.18, h * 0.050, highlight, primary);
        _drawRankChevron(canvas, w, h, h * 0.27, h * 0.050, highlight, primary);
        _drawRankChevron(canvas, w, h, h * 0.36, h * 0.050, highlight, primary);
        _drawRankRocker(canvas, w, h, h * 0.58, h * 0.042, primary);
        _drawFivePointStar(
          canvas: canvas,
          center: Offset(w * 0.50, h * 0.50),
          outerRadius: w * 0.052,
          innerRadius: w * 0.022,
          fillColor: goldAccent,
        );
      case MilitaryRank.e6WarrantOfficer:
        // 3 Chevrons + 2 Rockers + barre d'adjudant
        _drawRankChevron(canvas, w, h, h * 0.17, h * 0.048, highlight, primary);
        _drawRankChevron(canvas, w, h, h * 0.255, h * 0.048, highlight, primary);
        _drawRankChevron(canvas, w, h, h * 0.34, h * 0.048, highlight, primary);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(w * 0.50, h * 0.48),
              width: w * 0.24,
              height: h * 0.042,
            ),
            Radius.circular(w * 0.015),
          ),
          Paint()..color = goldAccent,
        );
        _drawRankRocker(canvas, w, h, h * 0.55, h * 0.038, primary);
        _drawRankRocker(canvas, w, h, h * 0.62, h * 0.038, highlight);
      case MilitaryRank.e7MasterSergeant:
        // 3 Chevrons + 3 Rockers + étoile radiante
        _drawRankChevron(canvas, w, h, h * 0.16, h * 0.045, highlight, primary);
        _drawRankChevron(canvas, w, h, h * 0.24, h * 0.045, highlight, primary);
        _drawRankChevron(canvas, w, h, h * 0.32, h * 0.045, highlight, primary);
        _drawFivePointStar(
          canvas: canvas,
          center: Offset(w * 0.50, h * 0.46),
          outerRadius: w * 0.062,
          innerRadius: w * 0.026,
          fillColor: goldAccent,
        );
        _drawRankRocker(canvas, w, h, h * 0.53, h * 0.034, primary);
        _drawRankRocker(canvas, w, h, h * 0.59, h * 0.034, highlight);
        _drawRankRocker(canvas, w, h, h * 0.65, h * 0.034, primary);
      case MilitaryRank.o1Lieutenant:
        // Barre verticale d'officier Or/Cyan + étoile supérieure
        _drawFivePointStar(
          canvas: canvas,
          center: Offset(w * 0.50, h * 0.21),
          outerRadius: w * 0.055,
          innerRadius: w * 0.024,
          fillColor: highlight,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(w * 0.50, h * 0.46),
              width: w * 0.14,
              height: h * 0.32,
            ),
            Radius.circular(w * 0.03),
          ),
          Paint()..color = goldAccent,
        );
      case MilitaryRank.o2Captain:
        // Double barre jumelée de Capitaine + étoile supérieure
        _drawFivePointStar(
          canvas: canvas,
          center: Offset(w * 0.50, h * 0.20),
          outerRadius: w * 0.055,
          innerRadius: w * 0.024,
          fillColor: highlight,
        );
        final Paint tieBar = Paint()..color = primary;
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(w * 0.50, h * 0.37),
            width: w * 0.34,
            height: h * 0.045,
          ),
          tieBar,
        );
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(w * 0.50, h * 0.53),
            width: w * 0.34,
            height: h * 0.045,
          ),
          tieBar,
        );
        for (final double dx in <double>[0.38, 0.62]) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(w * dx, h * 0.45),
                width: w * 0.11,
                height: h * 0.30,
              ),
              Radius.circular(w * 0.025),
            ),
            Paint()..color = goldAccent,
          );
        }
      case MilitaryRank.o3Major:
        // Couronne de lauriers tactiques + Grande Étoile de Commandement
        _drawLaurelWreath(canvas, w, h, primary);
        _drawRankChevron(canvas, w, h, h * 0.21, h * 0.048, highlight, primary);
        _drawFivePointStar(
          canvas: canvas,
          center: Offset(w * 0.50, h * 0.46),
          outerRadius: w * 0.11,
          innerRadius: w * 0.046,
          fillColor: goldAccent,
        );
      case MilitaryRank.sf1Operator:
        // Ailes SpecOps + Chevron + Dague Commando verticale
        _drawSpecOpsWings(canvas, w, h, primary);
        _drawRankChevron(canvas, w, h, h * 0.28, h * 0.052, highlight, primary);
        _drawCommandoDagger(canvas, w, h, goldAccent);
      case MilitaryRank.sf2TacticalLegend:
        // Couronne d'Or + Ailes SpecOps + Dague Commando + Étoile Suprême
        _drawLaurelWreath(canvas, w, h, goldAccent);
        _drawSpecOpsWings(canvas, w, h, primary);
        _drawCommandoDagger(canvas, w, h, goldAccent);
        _drawFivePointStar(
          canvas: canvas,
          center: Offset(w * 0.50, h * 0.46),
          outerRadius: w * 0.095,
          innerRadius: w * 0.040,
          fillColor: const Color(0xFFFEF08A),
          strokeColor: primary,
        );
    }
  }

  void _drawRankChevron(
    Canvas canvas,
    double w,
    double h,
    double apexY,
    double thickness,
    Color leftColor,
    Color rightColor,
  ) {
    final double cx = w * 0.50;
    final double span = w * 0.22;
    final double wingY = apexY + span * 0.58;

    final Path left = Path()
      ..moveTo(cx, apexY)
      ..lineTo(cx - span, wingY)
      ..lineTo(cx - span, wingY + thickness)
      ..lineTo(cx, apexY + thickness)
      ..close();
    final Path right = Path()
      ..moveTo(cx, apexY)
      ..lineTo(cx + span, wingY)
      ..lineTo(cx + span, wingY + thickness)
      ..lineTo(cx, apexY + thickness)
      ..close();

    canvas.drawPath(left, Paint()..color = leftColor);
    canvas.drawPath(right, Paint()..color = rightColor);
  }

  void _drawRankRocker(
    Canvas canvas,
    double w,
    double h,
    double baseY,
    double thickness,
    Color color,
  ) {
    final double span = w * 0.22;
    final double wingY = baseY - span * 0.34;
    final Path rocker = Path()
      ..moveTo(w * 0.50 - span, wingY)
      ..quadraticBezierTo(w * 0.50, baseY, w * 0.50 + span, wingY)
      ..lineTo(w * 0.50 + span, wingY + thickness)
      ..quadraticBezierTo(
        w * 0.50,
        baseY + thickness,
        w * 0.50 - span,
        wingY + thickness,
      )
      ..close();
    canvas.drawPath(rocker, Paint()..color = color);
  }

  void _drawDiamond(Canvas canvas, Offset center, double radius, Color color) {
    final Path p = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - radius, center.dy)
      ..close();
    canvas.drawPath(p, Paint()..color = color);
  }

  void _drawLaurelWreath(Canvas canvas, double w, double h, Color color) {
    final Paint wreathPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = w * 0.045;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.44),
        width: w * 0.48,
        height: h * 0.42,
      ),
      0.35,
      math.pi - 0.70,
      false,
      wreathPaint,
    );
  }

  void _drawSpecOpsWings(Canvas canvas, double w, double h, Color color) {
    final Path wings = Path()
      ..moveTo(w * 0.18, h * 0.36)
      ..lineTo(w * 0.42, h * 0.42)
      ..lineTo(w * 0.38, h * 0.50)
      ..lineTo(w * 0.22, h * 0.45)
      ..close()
      ..moveTo(w * 0.82, h * 0.36)
      ..lineTo(w * 0.58, h * 0.42)
      ..lineTo(w * 0.62, h * 0.50)
      ..lineTo(w * 0.78, h * 0.45)
      ..close();
    canvas.drawPath(wings, Paint()..color = color);
  }

  void _drawCommandoDagger(Canvas canvas, double w, double h, Color hiltColor) {
    final Path blade = Path()
      ..moveTo(w * 0.50, h * 0.15)
      ..lineTo(w * 0.545, h * 0.45)
      ..lineTo(w * 0.50, h * 0.51)
      ..lineTo(w * 0.455, h * 0.45)
      ..close();
    canvas.drawPath(blade, Paint()..color = const Color(0xFFF8FAFC));
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.45),
        width: w * 0.18,
        height: h * 0.032,
      ),
      Paint()..color = hiltColor,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.53),
        width: w * 0.045,
        height: h * 0.12,
      ),
      Paint()..color = hiltColor,
    );
  }

  @override
  bool shouldRepaint(covariant _MilitaryRankInsigniaPainter oldDelegate) {
    return oldDelegate.rank != rank || oldDelegate.isLocked != isLocked;
  }
}

/// Emblème vectoriel des 5 Familles Biomécaniques (`PUSH`, `PULL`, `LEGS`, `CORE`, `METCON`).
class BiomechanicalFamilyBadge extends StatelessWidget {
  const BiomechanicalFamilyBadge({
    super.key,
    required this.family,
    this.size = 36,
  });

  final BiomechanicalFamily family;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: _BiomechanicalFamilyPainter(family: family),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.76),
            child: Text(
              family.code.substring(0, 2),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: size * 0.21,
                height: 1.0,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BiomechanicalFamilyPainter extends CustomPainter {
  const _BiomechanicalFamilyPainter({required this.family});

  final BiomechanicalFamily family;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Color accent = family.accentColor;
    final Color light = Color.lerp(accent, Colors.white, 0.45)!;

    final RRect frame = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.06, h * 0.06, w * 0.88, h * 0.88),
      Radius.circular(w * 0.22),
    );
    canvas.drawRRect(
      frame,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF1E293B),
            Color(0xFF0A0E14),
          ],
        ).createShader(Offset.zero & size),
    );
    canvas.drawRRect(
      frame,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.5, w * 0.045),
    );

    final Paint vectorPaint = Paint()
      ..color = light
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = w * 0.065;

    switch (family) {
      case BiomechanicalFamily.upperPush:
        // Double chevron de poussée + ligne d'extension pectorale
        final Path p = Path()
          ..moveTo(w * 0.28, h * 0.42)
          ..lineTo(w * 0.50, h * 0.22)
          ..lineTo(w * 0.72, h * 0.42)
          ..moveTo(w * 0.32, h * 0.58)
          ..lineTo(w * 0.50, h * 0.40)
          ..lineTo(w * 0.68, h * 0.58);
        canvas.drawPath(p, vectorPaint);
      case BiomechanicalFamily.noBarPull:
        // Ailes scapulaires convergentes + axe rachidien
        final Path wings = Path()
          ..moveTo(w * 0.24, h * 0.28)
          ..lineTo(w * 0.42, h * 0.42)
          ..lineTo(w * 0.28, h * 0.58)
          ..moveTo(w * 0.76, h * 0.28)
          ..lineTo(w * 0.58, h * 0.42)
          ..lineTo(w * 0.72, h * 0.58);
        canvas.drawPath(wings, vectorPaint);
        canvas.drawLine(
          Offset(w * 0.50, h * 0.22),
          Offset(w * 0.50, h * 0.62),
          Paint()
            ..color = accent
            ..strokeCap = StrokeCap.round
            ..strokeWidth = w * 0.045,
        );
      case BiomechanicalFamily.tacticalLegs:
        // Cinématique articulée Hanche-Genou-Cheville en flexion Pistol/Squat
        final Path leg = Path()
          ..moveTo(w * 0.58, h * 0.22)
          ..lineTo(w * 0.36, h * 0.42)
          ..lineTo(w * 0.58, h * 0.56)
          ..lineTo(w * 0.42, h * 0.64);
        canvas.drawPath(leg, vectorPaint);
        canvas.drawCircle(
          Offset(w * 0.36, h * 0.42),
          w * 0.045,
          Paint()..color = const Color(0xFFFEF08A),
        );
      case BiomechanicalFamily.ironCore:
        // Bouclier hexagonal abdo + anneau anti-rotation
        final Path coreHex = Path()
          ..moveTo(w * 0.50, h * 0.20)
          ..lineTo(w * 0.70, h * 0.30)
          ..lineTo(w * 0.66, h * 0.58)
          ..lineTo(w * 0.50, h * 0.66)
          ..lineTo(w * 0.34, h * 0.58)
          ..lineTo(w * 0.30, h * 0.30)
          ..close();
        canvas.drawPath(
          coreHex,
          Paint()
            ..color = accent.withValues(alpha: 0.40)
            ..style = PaintingStyle.fill,
        );
        canvas.drawPath(coreHex, vectorPaint..strokeWidth = w * 0.045);
      case BiomechanicalFamily.metCon:
        // Onde ECG métabolique haute fréquence + éclair
        final Path ecg = Path()
          ..moveTo(w * 0.20, h * 0.44)
          ..lineTo(w * 0.36, h * 0.44)
          ..lineTo(w * 0.44, h * 0.24)
          ..lineTo(w * 0.55, h * 0.60)
          ..lineTo(w * 0.64, h * 0.36)
          ..lineTo(w * 0.70, h * 0.44)
          ..lineTo(w * 0.80, h * 0.44);
        canvas.drawPath(ecg, vectorPaint..strokeWidth = w * 0.055);
    }
  }

  @override
  bool shouldRepaint(covariant _BiomechanicalFamilyPainter oldDelegate) =>
      oldDelegate.family != family;
}

/// Bannière miniature vectorielle haute précision des 4 Campagnes Opérationnelles 28 Jours.
class CampaignThumbnailBanner extends StatelessWidget {
  const CampaignThumbnailBanner({
    super.key,
    required this.campaign,
    this.height = 96,
  });

  final OperationalCampaignId campaign;
  final double height;

  @override
  Widget build(BuildContext context) {
    final Color accent = campaign.accentColor;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: CustomPaint(
          painter: _CampaignThumbnailBackdropPainter(campaign: campaign),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: <Widget>[
                MakeFitLogoBadge(size: (height * 0.48).clamp(32.0, 48.0)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: accent, width: 1),
                            ),
                            child: Text(
                              '${campaign.code} • 28J',
                              style: TextStyle(
                                color: accent,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                height: 1.1,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              campaign.recommendedTier.shortTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Flexible(
                        child: Text(
                          campaign.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14.5,
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Flexible(
                        child: Text(
                          campaign.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 11,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CampaignThumbnailBackdropPainter extends CustomPainter {
  const _CampaignThumbnailBackdropPainter({required this.campaign});

  final OperationalCampaignId campaign;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Color accent = campaign.accentColor;

    // 1. Fond Carbone OLED + Halo Radial Tactique
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            const Color(0xFF0A0E14),
            const Color(0xFF0F172A),
            accent.withValues(alpha: 0.28),
          ],
          stops: const <double>[0.0, 0.58, 1.0],
        ).createShader(Offset.zero & size),
    );

    // 2. Grille Radar & Topographie Commando
    final Paint gridPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.65)
      ..strokeWidth = 1.0;
    for (double x = w * 0.20; x < w; x += w * 0.20) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    for (double y = h * 0.33; y < h; y += h * 0.33) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Courbes topographiques commando à droite
    final Path topoWave = Path()
      ..moveTo(w * 0.55, h)
      ..cubicTo(w * 0.65, h * 0.55, w * 0.78, h * 0.75, w * 0.92, 0);
    canvas.drawPath(
      topoWave,
      Paint()
        ..color = accent.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // 3. Emblème Vectoriel Spécifique à l'Opération en filigrane droit
    final Offset emblemCenter = Offset(w * 0.88, h * 0.50);
    final double r = h * 0.38;
    canvas.drawCircle(
      emblemCenter,
      r,
      Paint()
        ..color = accent.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    final Paint motifPaint = Paint()
      ..color = accent.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.4;

    switch (campaign) {
      case OperationalCampaignId.op1BasicBootcamp:
        // Chevrons de fondation + barre de gainage
        final Path p = Path()
          ..moveTo(emblemCenter.dx - r * 0.55, emblemCenter.dy + r * 0.15)
          ..lineTo(emblemCenter.dx, emblemCenter.dy - r * 0.35)
          ..lineTo(emblemCenter.dx + r * 0.55, emblemCenter.dy + r * 0.15);
        canvas.drawPath(p, motifPaint);
      case OperationalCampaignId.op2SilentRecon:
        // Onde acoustique furtive 0 dB + balayage radar
        final Path wave = Path()
          ..moveTo(emblemCenter.dx - r * 0.70, emblemCenter.dy)
          ..lineTo(emblemCenter.dx - r * 0.25, emblemCenter.dy)
          ..lineTo(emblemCenter.dx - r * 0.10, emblemCenter.dy - r * 0.35)
          ..lineTo(emblemCenter.dx + r * 0.10, emblemCenter.dy + r * 0.35)
          ..lineTo(emblemCenter.dx + r * 0.25, emblemCenter.dy)
          ..lineTo(emblemCenter.dx + r * 0.70, emblemCenter.dy);
        canvas.drawPath(wave, motifPaint);
      case OperationalCampaignId.op3AirborneConditioning:
        // Double chevron aéroporté haute densité
        for (final double dy in <double>[-0.18, 0.22]) {
          final Path ch = Path()
            ..moveTo(
              emblemCenter.dx - r * 0.55,
              emblemCenter.dy + r * (dy + 0.22),
            )
            ..lineTo(emblemCenter.dx, emblemCenter.dy + r * (dy - 0.22))
            ..lineTo(
              emblemCenter.dx + r * 0.55,
              emblemCenter.dy + r * (dy + 0.22),
            );
          canvas.drawPath(ch, motifPaint);
        }
      case OperationalCampaignId.op4SpecOpsSelection:
        // Pyramide lourde 1->10->1 en barres étagées
        for (int i = -2; i <= 2; i++) {
          final double barHalfW = r * (0.65 - i.abs() * 0.18);
          final double y = emblemCenter.dy + i * (r * 0.24);
          canvas.drawLine(
            Offset(emblemCenter.dx - barHalfW, y),
            Offset(emblemCenter.dx + barHalfW, y),
            motifPaint,
          );
        }
    }

    // 4. Bordure Tactique Biseautée & Barre Latérale Gauche
    final RRect borderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.75, 0.75, w - 1.5, h - 1.5),
      const Radius.circular(14),
    );
    canvas.drawRRect(
      borderRect,
      Paint()
        ..color = accent.withValues(alpha: 0.68)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, h * 0.16, 4.5, h * 0.68),
        const Radius.circular(2),
      ),
      Paint()..color = accent,
    );
  }

  @override
  bool shouldRepaint(covariant _CampaignThumbnailBackdropPainter oldDelegate) =>
      oldDelegate.campaign != campaign;
}

/// Plaques d'identité militaires (Dog Tags — Jetons de Permission Tactique).
class TacticalDogTagIcon extends StatelessWidget {
  const TacticalDogTagIcon({
    super.key,
    required this.activeCount,
    this.maxCount = 2,
  });

  final int activeCount;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(maxCount, (int index) {
        final bool active = index < activeCount;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: SizedBox(
            width: 18,
            height: 22,
            child: CustomPaint(
              painter: _TacticalDogTagPainter(isActive: active),
            ),
          ),
        );
      }),
    );
  }
}

class _TacticalDogTagPainter extends CustomPainter {
  const _TacticalDogTagPainter({required this.isActive});

  final bool isActive;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Color primary =
        isActive ? const Color(0xFFF59E0B) : const Color(0xFF475569);
    final Color light =
        isActive ? const Color(0xFFFEF08A) : const Color(0xFF64748B);

    final RRect tagBody = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.10, w * 0.76, h * 0.84),
      Radius.circular(w * 0.26),
    );

    canvas.drawRRect(
      tagBody,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[light, primary],
        ).createShader(Offset.zero & size),
    );

    canvas.drawRRect(
      tagBody,
      Paint()
        ..color = const Color(0xFF0A0E14)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // Œillet de chaîne supérieur
    canvas.drawCircle(
      Offset(w * 0.50, h * 0.25),
      w * 0.08,
      Paint()..color = const Color(0xFF0A0E14),
    );

    // Chevron embossé au centre de la plaque
    final Path chevron = Path()
      ..moveTo(w * 0.30, h * 0.60)
      ..lineTo(w * 0.50, h * 0.44)
      ..lineTo(w * 0.70, h * 0.60);
    canvas.drawPath(
      chevron,
      Paint()
        ..color = const Color(0xFF0A0E14)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 1.8,
    );
  }

  @override
  bool shouldRepaint(covariant _TacticalDogTagPainter oldDelegate) =>
      oldDelegate.isActive != isActive;
}

void _drawFivePointStar({
  required Canvas canvas,
  required Offset center,
  required double outerRadius,
  required double innerRadius,
  required Color fillColor,
  Color? strokeColor,
}) {
  final Path star = Path();
  for (int i = 0; i < 10; i++) {
    final double angle = -math.pi / 2 + (i * math.pi / 5);
    final double r = i.isEven ? outerRadius : innerRadius;
    final double x = center.dx + math.cos(angle) * r;
    final double y = center.dy + math.sin(angle) * r;
    if (i == 0) {
      star.moveTo(x, y);
    } else {
      star.lineTo(x, y);
    }
  }
  star.close();
  canvas.drawPath(star, Paint()..color = fillColor);
  if (strokeColor != null) {
    canvas.drawPath(
      star,
      Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = outerRadius * 0.14,
    );
  }
}
