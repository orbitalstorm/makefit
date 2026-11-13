import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/makefit_models.dart';

/// Rendu biomécanique procédural 3D/2.5D à 60-120 FPS du Coach Animé MakeFit.
///
/// Caractéristiques techniques (Moteur Impeller, Sound Null Safety strict) :
/// - Rig squelettique et volumétrique 3D complet (19 articulations, 24 volumes
///   anatomiques triés en profondeur par Painter's Algorithm Z-Sorting),
/// - Couverture intégrale et fluide des **25 `MannequinMotionKind`**,
/// - Contraste haute lisibilité sur fond sombre OLED et surbrillance thermique
///   synchronisée au cycle musculaire :
///   - Muscles principaux (`exercise.primaryMuscles`) : Corail Énergétique (`#EF4444` / `#F97316`),
///   - Muscles secondaires (`exercise.secondaryMuscles`) : Ambre Chaud (`#F59E0B`),
/// - Repère spatial 3D au sol (`2m × 2m`) sobre et lisible,
/// - Bandeau épuré de rythme, respiration et cadence synchronisé en temps réel,
/// - Caméra orbitale 3D (`threeQuarterTactical`, `sideProfile`, `frontSymmetry`) et
///   adaptations visuelles temps réel `stealthMode` (sans saut) & `jointMode` (Poignets / Genoux).
class AnatomicalMannequinView extends StatelessWidget {
  const AnatomicalMannequinView({
    super.key,
    required this.exercise,
    required this.animationPhase,
    this.cameraAngle = MannequinCameraAngle.threeQuarterTactical,
    this.stealthMode = false,
    this.jointMode = JointFriendlyMode.standard,
    this.height = 220,
  });

  final TacticalExercise exercise;
  final double animationPhase;
  final MannequinCameraAngle cameraAngle;
  final bool stealthMode;
  final JointFriendlyMode jointMode;
  final double height;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: AnatomicalMannequinPainter(
            exercise: exercise,
            animationPhase: animationPhase,
            cameraAngle: cameraAngle,
            stealthMode: stealthMode,
            jointMode: jointMode,
          ),
        ),
      ),
    );
  }
}

/// Vecteur 3D immuable léger dans le repère métrique de l'espace `2m × 2m`.
/// - `x` : axe sagittal (`-1.0m` arrière/pieds -> `+1.0m` avant/tête)
/// - `y` : élévation verticale au-dessus du tapis (`0.0m` = sol)
/// - `z` : axe médio-latéral (`-z` = côté gauche, `+z` = côté droit)
@immutable
class _Vec3 {
  const _Vec3(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  _Vec3 operator +(_Vec3 o) => _Vec3(x + o.x, y + o.y, z + o.z);
  _Vec3 operator -(_Vec3 o) => _Vec3(x - o.x, y - o.y, z - o.z);
  _Vec3 operator *(double s) => _Vec3(x * s, y * s, z * s);

  double get length => math.sqrt(x * x + y * y + z * z);

  _Vec3 normalized() {
    final double len = length;
    if (len < 1e-6) {
      return const _Vec3(0, 1, 0);
    }
    return _Vec3(x / len, y / len, z / len);
  }

  static _Vec3 lerp(_Vec3 a, _Vec3 b, double t) {
    return _Vec3(
      a.x + (b.x - a.x) * t,
      a.y + (b.y - a.y) * t,
      a.z + (b.z - a.z) * t,
    );
  }
}

/// Point projeté à l'écran avec sa profondeur caméra et son facteur d'échelle perspectif.
@immutable
class _ProjectedPoint {
  const _ProjectedPoint({
    required this.screen,
    required this.depth,
    required this.scale,
  });

  final Offset screen;
  final double depth;
  final double scale;
}

/// Caméra perspective 3D orbitale calibrée pour l'espace `2m × 2m`.
class _Camera3D {
  _Camera3D({
    required this.yaw,
    required this.pitch,
    required this.distance,
    required this.focalLength,
    required this.screenCenter,
    required this.target,
  }) : _cosYaw = math.cos(yaw),
       _sinYaw = math.sin(yaw),
       _cosPitch = math.cos(pitch),
       _sinPitch = math.sin(pitch);

  final double yaw;
  final double pitch;
  final double distance;
  final double focalLength;
  final Offset screenCenter;
  final _Vec3 target;

  final double _cosYaw;
  final double _sinYaw;
  final double _cosPitch;
  final double _sinPitch;

  _ProjectedPoint project(_Vec3 world) {
    final double dx = world.x - target.x;
    final double dy = world.y - target.y;
    final double dz = world.z - target.z;

    // Rotation azimutale autour de Y :
    // yaw = 0 -> vue de profil sagittal (X horizontal à l'écran, Z vers la caméra)
    // yaw = pi/2 -> vue de face coronale (Z horizontal à l'écran, X vers la caméra)
    final double rx = dx * _cosYaw - dz * _sinYaw;
    final double rz = dx * _sinYaw + dz * _cosYaw;

    // Inclinaison de plongée tactique (pitch) autour de l'axe horizontal caméra :
    final double ry = dy * _cosPitch - rz * _sinPitch;
    final double camZ = distance - (dy * _sinPitch + rz * _cosPitch);
    final double safeZ = math.max(0.85, camZ);
    final double s = focalLength / safeZ;

    return _ProjectedPoint(
      screen: Offset(screenCenter.dx + rx * s, screenCenter.dy - ry * s),
      depth: safeZ,
      scale: s,
    );
  }
}

enum _ThermalRole { primary, secondary, structural }

enum _VolumeShape { muscleBelly, torsoCore, cranialHead, deltoidCap, gluteCap }

/// Vecteur de force biomécanique 3D affiché en surimpression tactique.
@immutable
class _ForceVector3D {
  const _ForceVector3D({
    required this.origin,
    required this.tip,
    required this.color,
    this.tag,
  });

  final _Vec3 origin;
  final _Vec3 tip;
  final Color color;
  final String? tag;
}

/// Pose squelettique 3D complète à un instant `t` du cycle biomécanique.
@immutable
class _Pose3D {
  const _Pose3D({
    required this.headCenter,
    required this.headTop,
    required this.gazeDir,
    required this.neck,
    required this.thorax,
    required this.lumbar,
    required this.pelvis,
    required this.shoulderL,
    required this.shoulderR,
    required this.elbowL,
    required this.elbowR,
    required this.wristL,
    required this.wristR,
    required this.hipL,
    required this.hipR,
    required this.kneeL,
    required this.kneeR,
    required this.ankleL,
    required this.ankleR,
    required this.toeL,
    required this.toeR,
    required this.contractionIntensity,
    required this.isHorizontalPosture,
    required this.forces,
    this.propBoxHeight = 0.0,
    this.phaseBadge,
    this.breathingExpansion = 0.0,
  });

  final _Vec3 headCenter;
  final _Vec3 headTop;
  final _Vec3 gazeDir;
  final _Vec3 neck;
  final _Vec3 thorax;
  final _Vec3 lumbar;
  final _Vec3 pelvis;
  final _Vec3 shoulderL;
  final _Vec3 shoulderR;
  final _Vec3 elbowL;
  final _Vec3 elbowR;
  final _Vec3 wristL;
  final _Vec3 wristR;
  final _Vec3 hipL;
  final _Vec3 hipR;
  final _Vec3 kneeL;
  final _Vec3 kneeR;
  final _Vec3 ankleL;
  final _Vec3 ankleR;
  final _Vec3 toeL;
  final _Vec3 toeR;
  final double contractionIntensity;
  final bool isHorizontalPosture;
  final List<_ForceVector3D> forces;
  final double propBoxHeight;
  final String? phaseBadge;
  final double breathingExpansion;
}

/// Segment anatomique volumétrique prêt à être trié par Z-depth.
@immutable
class _VolumePrimitive {
  const _VolumePrimitive({
    required this.p0,
    required this.p1,
    required this.r0,
    required this.r1,
    required this.depth,
    required this.role,
    required this.shape,
    this.gazeOffset = Offset.zero,
  });

  final _ProjectedPoint p0;
  final _ProjectedPoint p1;
  final double r0;
  final double r1;
  final double depth;
  final _ThermalRole role;
  final _VolumeShape shape;
  final Offset gazeOffset;
}

class AnatomicalMannequinPainter extends CustomPainter {
  const AnatomicalMannequinPainter({
    required this.exercise,
    required this.animationPhase,
    required this.cameraAngle,
    required this.stealthMode,
    required this.jointMode,
  });

  final TacticalExercise exercise;
  final double animationPhase;
  final MannequinCameraAngle cameraAngle;
  final bool stealthMode;
  final JointFriendlyMode jointMode;

  static const Color _primaryRed = Color(0xFFEF4444);
  static const Color _primaryCoral = Color(0xFFF97316);
  static const Color _primaryHotCore = Color(0xFFFED7AA);
  static const Color _secondaryAmber = Color(0xFFF59E0B);
  static const Color _secondaryWarmCore = Color(0xFFFDE68A);
  static const Color _carbonDark = Color(0xFF283548);
  static const Color _carbonMid = Color(0xFF475569);
  static const Color _carbonLight = Color(0xFF94A3B8);
  static const Color _titaniumRim = Color(0xFFCBD5E1);
  static const Color _breathInhaleCyan = Color(0xFF06B6D4);
  static const Color _breathExhaleEmerald = Color(0xFF10B981);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || size.width <= 0 || size.height <= 0) {
      return;
    }

    final Rect bounds = Offset.zero & size;
    final RRect clipRRect = RRect.fromRectAndRadius(
      bounds,
      const Radius.circular(16),
    );
    canvas.save();
    canvas.clipRRect(clipRRect);

    // 1. Fond sombre OLED à haut contraste & halo ambiant subtil
    _paintTacticalBackdrop(canvas, size, bounds);

    // 2. Calcul cinématique 3D fluide 60-120 FPS selon les 25 MannequinMotionKind
    final double normalizedPhase =
        ((animationPhase % 1.0) + 1.0) % 1.0;
    final _Pose3D pose = _computePoseForExercise(normalizedPhase);

    // 3. Construction de la caméra perspective 3D selon cameraAngle
    final _Camera3D camera = _buildCamera(size, pose);

    // 4. Repère 3D de l'espace 2m × 2m au sol + ombre portée douce
    _paintFloorGrid2m(canvas, size, camera, pose);
    if (pose.propBoxHeight > 0.01) {
      _paintInclineSupportBlock(canvas, camera, pose.propBoxHeight);
    }
    _paintGroundContactShadow(canvas, camera, pose);

    // 5. Halo respiratoire guidé si exercice de cohérence respiratoire actif
    if (exercise.motionKind == MannequinMotionKind.boxBreathingH2f) {
      _paintBoxBreathingAura(canvas, camera, pose, normalizedPhase);
    }

    // 6. Assemblage, projection et Z-Sorting strict des 24 volumes anatomiques
    final double pulse =
        (0.50 + 0.50 * pose.contractionIntensity).clamp(0.0, 1.0);
    final List<_VolumePrimitive> primitives = _buildSortedVolumes(
      camera,
      pose,
    );
    for (final _VolumePrimitive prim in primitives) {
      _paintVolumePrimitive(canvas, prim, pulse);
    }

    // 7. Articulations nettes & indicateurs de confort Poignets / Genoux
    _paintArticulatedJoints(canvas, camera, pose);

    // 8. Flèches directionnelles du geste (épurées pour la lisibilité)
    _paintBiomechanicalForces(canvas, size, camera, pose, pulse);

    // 9. Bandeau épuré de rythme, respiration, cadence & zones musculaires actives
    _paintTelemetryHudAndLegend(canvas, size, pose, normalizedPhase);

    // Bordure tactique subtile
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = exercise.family.accentColor.withValues(alpha: 0.28);
    canvas.drawRRect(clipRRect.deflate(0.5), borderPaint);

    canvas.restore();
  }

  void _paintTacticalBackdrop(Canvas canvas, Size size, Rect bounds) {
    final Paint bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0xFF0E1623),
          Color(0xFF090E17),
          Color(0xFF060A10),
        ],
        stops: <double>[0.0, 0.62, 1.0],
      ).createShader(bounds);
    canvas.drawRect(bounds, bgPaint);

    // Halo ambiant discret aux couleurs de la famille biomécanique
    final Paint glowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.15),
        radius: 0.78,
        colors: <Color>[
          exercise.family.accentColor.withValues(alpha: 0.10),
          const Color(0x00000000),
        ],
      ).createShader(bounds);
    canvas.drawRect(bounds, glowPaint);

    // Trame télémétrique arrière-plan ultra-fine
    final Paint fineGrid = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.26)
      ..strokeWidth = 0.75;
    const double step = 26.0;
    for (double x = step; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), fineGrid);
    }
    for (double y = step; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), fineGrid);
    }
  }

  _Camera3D _buildCamera(Size size, _Pose3D pose) {
    final (double yaw, double pitch) = switch (cameraAngle) {
      MannequinCameraAngle.sideProfile => (
        0.06,
        pose.isHorizontalPosture ? 0.17 : 0.13,
      ),
      MannequinCameraAngle.threeQuarterTactical => (
        0.66,
        pose.isHorizontalPosture ? 0.32 : 0.24,
      ),
      MannequinCameraAngle.frontSymmetry => (
        1.51,
        pose.isHorizontalPosture ? 0.40 : 0.20,
      ),
    };

    final _Vec3 target = pose.isHorizontalPosture
        ? const _Vec3(0.0, 0.34, 0.0)
        : const _Vec3(0.0, 0.78, 0.0);

    final double minDim = math.min(size.width * 0.85, size.height);
    final double focal = pose.isHorizontalPosture
        ? minDim * 1.92
        : minDim * 1.72;
    final double verticalAnchor = pose.isHorizontalPosture ? 0.56 : 0.52;

    return _Camera3D(
      yaw: yaw,
      pitch: pitch,
      distance: 3.55,
      focalLength: focal,
      screenCenter: Offset(size.width * 0.50, size.height * verticalAnchor),
      target: target,
    );
  }

  void _paintFloorGrid2m(
    Canvas canvas,
    Size size,
    _Camera3D camera,
    _Pose3D pose,
  ) {
    const double halfSpan = 1.0; // Espace 2.0m × 2.0m (-1.0m .. +1.0m)
    const int divisions = 8; // Pas de 0.25m

    final Paint minorLinePaint = Paint()
      ..color = const Color(0xFF334155).withValues(alpha: 0.38)
      ..strokeWidth = 0.85;
    final Paint axisLinePaint = Paint()
      ..color = exercise.family.accentColor.withValues(alpha: 0.36)
      ..strokeWidth = 1.25;
    final Paint borderPaint = Paint()
      ..color = exercise.family.accentColor.withValues(alpha: 0.52)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= divisions; i++) {
      final double v = -halfSpan + (2.0 * halfSpan * i / divisions);
      final bool isCenter = i == divisions ~/ 2;
      final bool isOuter = i == 0 || i == divisions;
      if (isOuter) {
        continue;
      }
      final Paint p = isCenter ? axisLinePaint : minorLinePaint;
      final Offset a1 = camera.project(_Vec3(v, 0.0, -halfSpan)).screen;
      final Offset a2 = camera.project(_Vec3(v, 0.0, halfSpan)).screen;
      canvas.drawLine(a1, a2, p);

      final Offset b1 = camera.project(_Vec3(-halfSpan, 0.0, v)).screen;
      final Offset b2 = camera.project(_Vec3(halfSpan, 0.0, v)).screen;
      canvas.drawLine(b1, b2, p);
    }

    // Périmètre 2m × 2m en perspective
    final Offset c00 = camera.project(const _Vec3(-halfSpan, 0, -halfSpan)).screen;
    final Offset c10 = camera.project(const _Vec3(halfSpan, 0, -halfSpan)).screen;
    final Offset c11 = camera.project(const _Vec3(halfSpan, 0, halfSpan)).screen;
    final Offset c01 = camera.project(const _Vec3(-halfSpan, 0, halfSpan)).screen;

    final Path perimeter = Path()
      ..moveTo(c00.dx, c00.dy)
      ..lineTo(c10.dx, c10.dy)
      ..lineTo(c11.dx, c11.dy)
      ..lineTo(c01.dx, c01.dy)
      ..close();

    canvas.drawPath(
      perimeter,
      Paint()
        ..color = const Color(0xFF0F172A).withValues(alpha: 0.36)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(perimeter, borderPaint);

    // Équerres télémétriques lumineuses aux 4 coins du carré 2m × 2m
    final Paint cornerPaint = Paint()
      ..color = exercise.family.accentColor.withValues(alpha: 0.85)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    const double bracketLen = 0.22;
    final List<(_Vec3, _Vec3, _Vec3)> corners = <(_Vec3, _Vec3, _Vec3)>[
      (
        const _Vec3(-halfSpan, 0, -halfSpan),
        const _Vec3(-halfSpan + bracketLen, 0, -halfSpan),
        const _Vec3(-halfSpan, 0, -halfSpan + bracketLen),
      ),
      (
        const _Vec3(halfSpan, 0, -halfSpan),
        const _Vec3(halfSpan - bracketLen, 0, -halfSpan),
        const _Vec3(halfSpan, 0, -halfSpan + bracketLen),
      ),
      (
        const _Vec3(halfSpan, 0, halfSpan),
        const _Vec3(halfSpan - bracketLen, 0, halfSpan),
        const _Vec3(halfSpan, 0, halfSpan - bracketLen),
      ),
      (
        const _Vec3(-halfSpan, 0, halfSpan),
        const _Vec3(-halfSpan + bracketLen, 0, halfSpan),
        const _Vec3(-halfSpan, 0, halfSpan - bracketLen),
      ),
    ];
    for (final (_Vec3 o, _Vec3 ax, _Vec3 az) in corners) {
      final Offset po = camera.project(o).screen;
      canvas.drawLine(po, camera.project(ax).screen, cornerPaint);
      canvas.drawLine(po, camera.project(az).screen, cornerPaint);
    }
  }

  void _paintInclineSupportBlock(
    Canvas canvas,
    _Camera3D camera,
    double blockHeight,
  ) {
    const double x0 = 0.42;
    const double x1 = 0.78;
    const double z0 = -0.36;
    const double z1 = 0.36;

    final Offset b00 = camera.project(const _Vec3(x0, 0, z0)).screen;
    final Offset b11 = camera.project(const _Vec3(x1, 0, z1)).screen;
    final Offset b01 = camera.project(const _Vec3(x0, 0, z1)).screen;

    final Offset t00 = camera.project(_Vec3(x0, blockHeight, z0)).screen;
    final Offset t10 = camera.project(_Vec3(x1, blockHeight, z0)).screen;
    final Offset t11 = camera.project(_Vec3(x1, blockHeight, z1)).screen;
    final Offset t01 = camera.project(_Vec3(x0, blockHeight, z1)).screen;

    final Path frontFace = Path()
      ..moveTo(b01.dx, b01.dy)
      ..lineTo(b11.dx, b11.dy)
      ..lineTo(t11.dx, t11.dy)
      ..lineTo(t01.dx, t01.dy)
      ..close();
    final Path sideFace = Path()
      ..moveTo(b00.dx, b00.dy)
      ..lineTo(b01.dx, b01.dy)
      ..lineTo(t01.dx, t01.dy)
      ..lineTo(t00.dx, t00.dy)
      ..close();
    final Path topFace = Path()
      ..moveTo(t00.dx, t00.dy)
      ..lineTo(t10.dx, t10.dy)
      ..lineTo(t11.dx, t11.dy)
      ..lineTo(t01.dx, t01.dy)
      ..close();

    canvas.drawPath(
      sideFace,
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.78),
    );
    canvas.drawPath(
      frontFace,
      Paint()..color = const Color(0xFF0F172A).withValues(alpha: 0.85),
    );
    canvas.drawPath(
      topFace,
      Paint()..color = const Color(0xFF334155).withValues(alpha: 0.85),
    );
    final Paint edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = _secondaryAmber.withValues(alpha: 0.55);
    canvas.drawPath(topFace, edge);
  }

  void _paintGroundContactShadow(
    Canvas canvas,
    _Camera3D camera,
    _Pose3D pose,
  ) {
    final _Vec3 com = _Vec3(
      (pose.thorax.x + pose.pelvis.x) * 0.5,
      0.0,
      (pose.thorax.z + pose.pelvis.z) * 0.5,
    );
    final double minFootY = math.min(pose.ankleL.y, pose.ankleR.y);
    final double airHeight = pose.isHorizontalPosture
        ? 0.0
        : math.max(0.0, minFootY - 0.08);
    final double shrink = (1.0 - airHeight * 1.4).clamp(0.45, 1.0);

    final double spanX = (pose.isHorizontalPosture ? 0.72 : 0.34) * shrink;
    final double spanZ = (pose.isHorizontalPosture ? 0.28 : 0.32) * shrink;

    final Path shadowPath = Path();
    const int samples = 16;
    for (int i = 0; i < samples; i++) {
      final double ang = (i / samples) * 2.0 * math.pi;
      final _Vec3 pt = _Vec3(
        com.x + math.cos(ang) * spanX,
        0.002,
        com.z + math.sin(ang) * spanZ,
      );
      final Offset sp = camera.project(pt).screen;
      if (i == 0) {
        shadowPath.moveTo(sp.dx, sp.dy);
      } else {
        shadowPath.lineTo(sp.dx, sp.dy);
      }
    }
    shadowPath.close();

    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.44 * shrink)
        ..style = PaintingStyle.fill,
    );
  }

  void _paintBoxBreathingAura(
    Canvas canvas,
    _Camera3D camera,
    _Pose3D pose,
    double phase,
  ) {
    final _ProjectedPoint center = camera.project(pose.thorax);
    final int quad = (phase * 4.0).floor().clamp(0, 3);
    final double localT = (phase * 4.0) - quad;
    final (double radiusFactor, Color ringColor) = switch (quad) {
      0 => (0.62 + 0.38 * localT, const Color(0xFF06B6D4)), // Inspire 4s
      1 => (1.00, const Color(0xFF10B981)), // Garde plein 4s
      2 => (1.00 - 0.38 * localT, const Color(0xFFF59E0B)), // Expire 4s
      _ => (0.62, const Color(0xFF8B5CF6)), // Garde vide 4s
    };

    final double baseR = 0.34 * center.scale * radiusFactor;
    canvas.drawCircle(
      center.screen,
      baseR,
      Paint()
        ..color = ringColor.withValues(alpha: 0.14)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center.screen,
      baseR,
      Paint()
        ..color = ringColor.withValues(alpha: 0.68)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(
      center.screen,
      baseR * 0.72,
      Paint()
        ..color = ringColor.withValues(alpha: 0.32)
        ..strokeWidth = 1.1
        ..style = PaintingStyle.stroke,
    );
  }

  _ThermalRole _resolveRole(List<MuscleGroup> groups) {
    for (final MuscleGroup g in groups) {
      if (exercise.primaryMuscles.contains(g)) {
        return _ThermalRole.primary;
      }
    }
    for (final MuscleGroup g in groups) {
      if (exercise.secondaryMuscles.contains(g)) {
        return _ThermalRole.secondary;
      }
    }
    return _ThermalRole.structural;
  }

  List<_VolumePrimitive> _buildSortedVolumes(_Camera3D camera, _Pose3D pose) {
    final List<_VolumePrimitive> list = <_VolumePrimitive>[];

    void addSegment(
      _Vec3 a,
      _Vec3 b,
      double rA,
      double rB,
      List<MuscleGroup> groups, {
      _VolumeShape shape = _VolumeShape.muscleBelly,
      _Vec3? gazeVec,
    }) {
      final _ProjectedPoint p0 = camera.project(a);
      final _ProjectedPoint p1 = camera.project(b);
      final Offset gazeOff = gazeVec != null
          ? camera.project(a + gazeVec * 0.12).screen - p0.screen
          : Offset.zero;
      list.add(
        _VolumePrimitive(
          p0: p0,
          p1: p1,
          r0: rA * p0.scale,
          r1: rB * p1.scale,
          depth: (p0.depth + p1.depth) * 0.5,
          role: _resolveRole(groups),
          shape: shape,
          gazeOffset: gazeOff,
        ),
      );
    }

    // Vecteur antéro-postérieur local du tronc pour séparer en 3D les loges
    // musculaires antérieures (Pectoraux, Grand Droit, Quads, Biceps) et
    // postérieures (Rhomboïdes/Omoplates, Érecteurs, Ischios, Triceps).
    final _Vec3 spineAxis = (pose.neck - pose.pelvis).normalized();
    final _Vec3 lateralAxis = (pose.shoulderR - pose.shoulderL).normalized();
    final _Vec3 torsoFront = _cross(lateralAxis, spineAxis).normalized();
    final double breathScale = 1.0 + 0.08 * pose.breathingExpansion;

    // 1. Colonne vertébrale & Érecteurs du rachis
    addSegment(
      pose.pelvis - torsoFront * 0.045,
      pose.neck - torsoFront * 0.035,
      0.052,
      0.046,
      const <MuscleGroup>[MuscleGroup.erectorSpinae],
      shape: _VolumeShape.torsoCore,
    );

    // 2. Cage thoracique structurelle
    addSegment(
      pose.lumbar,
      pose.neck,
      0.102 * breathScale,
      0.118 * breathScale,
      const <MuscleGroup>[],
      shape: _VolumeShape.torsoCore,
    );

    // 3. Pectoraux (plaques sternales gauche & droite en face antérieure)
    addSegment(
      pose.thorax + torsoFront * 0.058 - lateralAxis * 0.02,
      pose.shoulderL + torsoFront * 0.035,
      0.064 * breathScale,
      0.046,
      const <MuscleGroup>[MuscleGroup.pectorals],
    );
    addSegment(
      pose.thorax + torsoFront * 0.058 + lateralAxis * 0.02,
      pose.shoulderR + torsoFront * 0.035,
      0.064 * breathScale,
      0.046,
      const <MuscleGroup>[MuscleGroup.pectorals],
    );

    // 4. Omoplates, Rhomboïdes & Trapèzes (face dorsale haute)
    addSegment(
      pose.thorax - torsoFront * 0.062 - lateralAxis * 0.015,
      pose.shoulderL - torsoFront * 0.038,
      0.058,
      0.045,
      const <MuscleGroup>[MuscleGroup.rhomboidsTraps],
    );
    addSegment(
      pose.thorax - torsoFront * 0.062 + lateralAxis * 0.015,
      pose.shoulderR - torsoFront * 0.038,
      0.058,
      0.045,
      const <MuscleGroup>[MuscleGroup.rhomboidsTraps],
    );

    // 5. Grand Dorsal (ailes latéro-dorsales en V)
    addSegment(
      pose.shoulderL - torsoFront * 0.025,
      pose.lumbar - lateralAxis * 0.075 - torsoFront * 0.02,
      0.052,
      0.038,
      const <MuscleGroup>[MuscleGroup.latissimusDorsi],
    );
    addSegment(
      pose.shoulderR - torsoFront * 0.025,
      pose.lumbar + lateralAxis * 0.075 - torsoFront * 0.02,
      0.052,
      0.038,
      const <MuscleGroup>[MuscleGroup.latissimusDorsi],
    );

    // 6. Grand Droit & Transverse (bouclier abdominal antérieur)
    addSegment(
      pose.thorax + torsoFront * 0.052,
      pose.pelvis + torsoFront * 0.045,
      0.068 * breathScale,
      0.058,
      const <MuscleGroup>[MuscleGroup.rectusAbdominis],
    );

    // 7. Obliques Anti-Rotation (flancs gauche & droit)
    addSegment(
      pose.thorax - lateralAxis * 0.088,
      pose.hipL + torsoFront * 0.015,
      0.044,
      0.042,
      const <MuscleGroup>[MuscleGroup.obliques],
    );
    addSegment(
      pose.thorax + lateralAxis * 0.088,
      pose.hipR + torsoFront * 0.015,
      0.044,
      0.042,
      const <MuscleGroup>[MuscleGroup.obliques],
    );

    // 8. Complexe Fessier (Grand & Moyen Fessiers)
    addSegment(
      pose.pelvis - torsoFront * 0.035 - lateralAxis * 0.05,
      pose.hipL - torsoFront * 0.03,
      0.074,
      0.068,
      const <MuscleGroup>[MuscleGroup.glutes],
      shape: _VolumeShape.gluteCap,
    );
    addSegment(
      pose.pelvis - torsoFront * 0.035 + lateralAxis * 0.05,
      pose.hipR - torsoFront * 0.03,
      0.074,
      0.068,
      const <MuscleGroup>[MuscleGroup.glutes],
      shape: _VolumeShape.gluteCap,
    );

    // 9. Coiffes Deltoïdiennes 3D (Antérieur, Moyen, Postérieur)
    final List<MuscleGroup> deltoidGroups = <MuscleGroup>[
      MuscleGroup.anteriorDeltoid,
      MuscleGroup.lateralDeltoid,
      MuscleGroup.posteriorDeltoid,
    ];
    final _Vec3 armDirL = (pose.elbowL - pose.shoulderL).normalized();
    final _Vec3 armDirR = (pose.elbowR - pose.shoulderR).normalized();
    addSegment(
      pose.shoulderL,
      pose.shoulderL + armDirL * 0.09,
      0.058,
      0.048,
      deltoidGroups,
      shape: _VolumeShape.deltoidCap,
    );
    addSegment(
      pose.shoulderR,
      pose.shoulderR + armDirR * 0.09,
      0.058,
      0.048,
      deltoidGroups,
      shape: _VolumeShape.deltoidCap,
    );

    // 10. Bras Supérieurs : séparation Triceps (loge postérieure) / Biceps (loge antérieure)
    addSegment(
      pose.shoulderL - torsoFront * 0.016,
      pose.elbowL - torsoFront * 0.012,
      0.044,
      0.036,
      const <MuscleGroup>[MuscleGroup.triceps],
    );
    addSegment(
      pose.shoulderR - torsoFront * 0.016,
      pose.elbowR - torsoFront * 0.012,
      0.044,
      0.036,
      const <MuscleGroup>[MuscleGroup.triceps],
    );
    addSegment(
      pose.shoulderL + torsoFront * 0.016,
      pose.elbowL + torsoFront * 0.012,
      0.042,
      0.035,
      const <MuscleGroup>[MuscleGroup.bicepsForearms],
    );
    addSegment(
      pose.shoulderR + torsoFront * 0.016,
      pose.elbowR + torsoFront * 0.012,
      0.042,
      0.035,
      const <MuscleGroup>[MuscleGroup.bicepsForearms],
    );

    // 11. Avant-bras (Coude -> Poignet)
    addSegment(
      pose.elbowL,
      pose.wristL,
      0.040,
      0.028,
      const <MuscleGroup>[MuscleGroup.bicepsForearms],
    );
    addSegment(
      pose.elbowR,
      pose.wristR,
      0.040,
      0.028,
      const <MuscleGroup>[MuscleGroup.bicepsForearms],
    );

    // 12. Cuisses : Quadriceps Fémoral (antérieur) & Ischio-Jambiers (postérieur)
    final _Vec3 thighFrontL = _limbAnteriorNormal(pose.hipL, pose.kneeL, pose.ankleL, torsoFront);
    final _Vec3 thighFrontR = _limbAnteriorNormal(pose.hipR, pose.kneeR, pose.ankleR, torsoFront);

    addSegment(
      pose.hipL + thighFrontL * 0.022,
      pose.kneeL + thighFrontL * 0.016,
      0.068,
      0.050,
      const <MuscleGroup>[MuscleGroup.quadriceps],
    );
    addSegment(
      pose.hipR + thighFrontR * 0.022,
      pose.kneeR + thighFrontR * 0.016,
      0.068,
      0.050,
      const <MuscleGroup>[MuscleGroup.quadriceps],
    );
    addSegment(
      pose.hipL - thighFrontL * 0.022,
      pose.kneeL - thighFrontL * 0.016,
      0.062,
      0.046,
      const <MuscleGroup>[MuscleGroup.hamstrings],
    );
    addSegment(
      pose.hipR - thighFrontR * 0.022,
      pose.kneeR - thighFrontR * 0.016,
      0.062,
      0.046,
      const <MuscleGroup>[MuscleGroup.hamstrings],
    );

    // 13. Jambe inférieure : Triceps Sural / Mollets & Pieds
    addSegment(
      pose.kneeL,
      pose.ankleL,
      0.050,
      0.031,
      const <MuscleGroup>[MuscleGroup.calves],
    );
    addSegment(
      pose.kneeR,
      pose.ankleR,
      0.050,
      0.031,
      const <MuscleGroup>[MuscleGroup.calves],
    );
    addSegment(
      pose.ankleL,
      pose.toeL,
      0.032,
      0.022,
      const <MuscleGroup>[],
      shape: _VolumeShape.torsoCore,
    );
    addSegment(
      pose.ankleR,
      pose.toeR,
      0.032,
      0.022,
      const <MuscleGroup>[],
      shape: _VolumeShape.torsoCore,
    );

    // 14. Tête & Visière Cranio-Cervicale Tactique
    addSegment(
      pose.headCenter,
      pose.headTop,
      0.095,
      0.088,
      const <MuscleGroup>[],
      shape: _VolumeShape.cranialHead,
      gazeVec: pose.gazeDir,
    );

    // Tri strict Painter's Algorithm : du plus éloigné (depth max) au plus proche (depth min)
    list.sort((_VolumePrimitive a, _VolumePrimitive b) => b.depth.compareTo(a.depth));
    return list;
  }

  _Vec3 _cross(_Vec3 a, _Vec3 b) {
    return _Vec3(
      a.y * b.z - a.z * b.y,
      a.z * b.x - a.x * b.z,
      a.x * b.y - a.y * b.x,
    );
  }

  _Vec3 _limbAnteriorNormal(
    _Vec3 hip,
    _Vec3 knee,
    _Vec3 ankle,
    _Vec3 fallbackFront,
  ) {
    final _Vec3 femur = (knee - hip).normalized();
    final _Vec3 tibia = (ankle - knee).normalized();
    // Le genou fléchit anatomiquement vers l'avant (femur - tibia pointe vers la rotule)
    final _Vec3 bend = femur - tibia;
    if (bend.length > 0.18) {
      return bend.normalized();
    }
    return fallbackFront;
  }

  void _paintVolumePrimitive(
    Canvas canvas,
    _VolumePrimitive prim,
    double pulse,
  ) {
    if (prim.shape == _VolumeShape.cranialHead) {
      _paintCranialHead(canvas, prim);
      return;
    }

    final Offset a = prim.p0.screen;
    final Offset b = prim.p1.screen;
    final Offset delta = b - a;
    final double len = delta.distance;
    final double r0 = math.max(2.0, prim.r0);
    final double r1 = math.max(1.8, prim.r1);

    if (len < 1.5) {
      final double rAvg = (r0 + r1) * 0.55;
      _paintSphericalCap(canvas, a, rAvg, prim.role, pulse);
      return;
    }

    final Offset dir = delta / len;
    final Offset norm = Offset(-dir.dy, dir.dx);
    final double bellyBoost = prim.shape == _VolumeShape.muscleBelly ? 1.18 : 1.04;
    final double rMid = ((r0 + r1) * 0.5) * bellyBoost;
    final Offset mid = Offset((a.dx + b.dx) * 0.5, (a.dy + b.dy) * 0.5);

    // Aura thermique externe pulsante sur les muscles actifs (0 MaskFilter coûteux)
    if (prim.role != _ThermalRole.structural) {
      final Color glowColor = prim.role == _ThermalRole.primary
          ? _primaryRed
          : _secondaryAmber;
      final double glowAlpha = prim.role == _ThermalRole.primary
          ? (0.16 + 0.18 * pulse)
          : (0.10 + 0.12 * pulse);
      final Path auraPath = _buildSculptedMusclePath(
        a,
        b,
        mid,
        dir,
        norm,
        r0 * 1.42,
        rMid * 1.48,
        r1 * 1.42,
      );
      canvas.drawPath(
        auraPath,
        Paint()
          ..color = glowColor.withValues(alpha: glowAlpha)
          ..style = PaintingStyle.fill,
      );
    }

    final Path bodyPath = _buildSculptedMusclePath(
      a,
      b,
      mid,
      dir,
      norm,
      r0,
      rMid,
      r1,
    );

    final Offset gStart = mid - norm * rMid;
    final Offset gEnd = mid + norm * rMid;
    final List<Color> gradientColors = switch (prim.role) {
      _ThermalRole.primary => <Color>[
        Color.lerp(const Color(0xFF991B1B), _primaryRed, pulse)!,
        Color.lerp(_primaryRed, _primaryCoral, pulse)!,
        Color.lerp(_primaryCoral, _primaryHotCore, 0.45 * pulse)!,
        const Color(0xFF7F1D1D),
      ],
      _ThermalRole.secondary => <Color>[
        const Color(0xFF78350F),
        Color.lerp(const Color(0xFFD97706), _secondaryAmber, pulse)!,
        Color.lerp(_secondaryAmber, _secondaryWarmCore, 0.35 * pulse)!,
        const Color(0xFF78350F),
      ],
      _ThermalRole.structural => const <Color>[
        _carbonDark,
        _carbonMid,
        _carbonLight,
        _carbonDark,
      ],
    };

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
        stops: const <double>[0.0, 0.42, 0.72, 1.0],
      ).createShader(Rect.fromPoints(gStart, gEnd));
    canvas.drawPath(bodyPath, fillPaint);

    // Striation longitudinale subtile des fibres musculaires actives
    if (prim.role != _ThermalRole.structural && len > 10.0) {
      final Color fiberColor = prim.role == _ThermalRole.primary
          ? _primaryHotCore.withValues(alpha: 0.34 + 0.28 * pulse)
          : _secondaryWarmCore.withValues(alpha: 0.26 + 0.20 * pulse);
      final Paint fiberPaint = Paint()
        ..color = fiberColor
        ..strokeWidth = 1.15
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final Path ridge = Path()
        ..moveTo(a.dx + dir.dx * 3, a.dy + dir.dy * 3)
        ..quadraticBezierTo(
          mid.dx + norm.dx * (rMid * 0.24),
          mid.dy + norm.dy * (rMid * 0.24),
          b.dx - dir.dx * 3,
          b.dy - dir.dy * 3,
        );
      canvas.drawPath(ridge, fiberPaint);
    }

    // Contour rim-light 3D net à contraste élevé sur fond sombre
    final Color rimColor = switch (prim.role) {
      _ThermalRole.primary => _primaryCoral.withValues(alpha: 0.92),
      _ThermalRole.secondary => _secondaryAmber.withValues(alpha: 0.84),
      _ThermalRole.structural => _titaniumRim.withValues(alpha: 0.60),
    };
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = rimColor
        ..strokeWidth = prim.role == _ThermalRole.structural ? 0.95 : 1.30
        ..style = PaintingStyle.stroke,
    );
  }

  Path _buildSculptedMusclePath(
    Offset a,
    Offset b,
    Offset mid,
    Offset dir,
    Offset norm,
    double r0,
    double rMid,
    double r1,
  ) {
    final Offset aCap = a - dir * (r0 * 0.55);
    final Offset bCap = b + dir * (r1 * 0.55);
    final Offset aL = a + norm * r0;
    final Offset aR = a - norm * r0;
    final Offset mL = mid + norm * rMid;
    final Offset mR = mid - norm * rMid;
    final Offset bL = b + norm * r1;
    final Offset bR = b - norm * r1;

    return Path()
      ..moveTo(aL.dx, aL.dy)
      ..quadraticBezierTo(mL.dx, mL.dy, bL.dx, bL.dy)
      ..quadraticBezierTo(bCap.dx, bCap.dy, bR.dx, bR.dy)
      ..quadraticBezierTo(mR.dx, mR.dy, aR.dx, aR.dy)
      ..quadraticBezierTo(aCap.dx, aCap.dy, aL.dx, aL.dy)
      ..close();
  }

  void _paintSphericalCap(
    Canvas canvas,
    Offset center,
    double radius,
    _ThermalRole role,
    double pulse,
  ) {
    if (role != _ThermalRole.structural) {
      canvas.drawCircle(
        center,
        radius * 1.45,
        Paint()
          ..color = (role == _ThermalRole.primary ? _primaryRed : _secondaryAmber)
              .withValues(alpha: 0.22 * pulse),
      );
    }
    final Color fill = switch (role) {
      _ThermalRole.primary => Color.lerp(_primaryRed, _primaryCoral, pulse)!,
      _ThermalRole.secondary => _secondaryAmber,
      _ThermalRole.structural => _carbonMid,
    };
    canvas.drawCircle(center, radius, Paint()..color = fill);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = _titaniumRim.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );
  }

  void _paintCranialHead(Canvas canvas, _VolumePrimitive prim) {
    final Offset c = Offset(
      (prim.p0.screen.dx + prim.p1.screen.dx) * 0.5,
      (prim.p0.screen.dy + prim.p1.screen.dy) * 0.5,
    );
    final double r = math.max(5.5, prim.r0 * 0.96);

    final Rect headRect = Rect.fromCircle(center: c, radius: r);
    final Paint headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.35),
        radius: 0.95,
        colors: <Color>[Color(0xFF94A3B8), Color(0xFF475569), Color(0xFF1E293B)],
      ).createShader(headRect);
    canvas.drawOval(
      Rect.fromCenter(center: c, width: r * 1.78, height: r * 2.08),
      headPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: c, width: r * 1.78, height: r * 2.08),
      Paint()
        ..color = const Color(0xFFCBD5E1).withValues(alpha: 0.72)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1,
    );

    // Visière tactique indiquant l'orientation de la nuque/regard
    final double gazeLen = prim.gazeOffset.distance;
    final Offset visorShift = gazeLen > 0.5
        ? (prim.gazeOffset / gazeLen) * (r * 0.42)
        : Offset(r * 0.25, 0);
    final Offset visorCenter = c + visorShift;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: visorCenter,
          width: r * 0.95,
          height: math.max(2.6, r * 0.34),
        ),
        const Radius.circular(3),
      ),
      Paint()..color = exercise.family.accentColor.withValues(alpha: 0.90),
    );
  }

  void _paintArticulatedJoints(
    Canvas canvas,
    _Camera3D camera,
    _Pose3D pose,
  ) {
    final List<_Vec3> coreJoints = <_Vec3>[
      pose.shoulderL,
      pose.shoulderR,
      pose.elbowL,
      pose.elbowR,
      pose.hipL,
      pose.hipR,
      pose.kneeL,
      pose.kneeR,
      pose.ankleL,
      pose.ankleR,
    ];

    final Paint ringFill = Paint()..color = const Color(0xFF0F172A);
    final Paint ringStroke = Paint()
      ..color = const Color(0xFFE2E8F0).withValues(alpha: 0.85)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    for (final _Vec3 j in coreJoints) {
      final _ProjectedPoint pj = camera.project(j);
      final double r = (0.022 * pj.scale).clamp(2.2, 4.6);
      canvas.drawCircle(pj.screen, r, ringFill);
      canvas.drawCircle(pj.screen, r, ringStroke);
    }

    // Mains / Poings tactiques (mise en évidence du mode Protection Poignets)
    final bool fistGuard = jointMode == JointFriendlyMode.wristFriendly;
    for (final _Vec3 w in <_Vec3>[pose.wristL, pose.wristR]) {
      final _ProjectedPoint pw = camera.project(w);
      final double r = (fistGuard ? 0.036 : 0.026) * pw.scale;
      canvas.drawCircle(
        pw.screen,
        r.clamp(2.6, 6.2),
        Paint()
          ..color = fistGuard
              ? const Color(0xFF10B981)
              : const Color(0xFFCBD5E1),
      );
    }

    // Anneaux de protection rotulienne si Knee-Friendly actif
    if (jointMode == JointFriendlyMode.kneeFriendly) {
      final Paint kneeShield = Paint()
        ..color = const Color(0xFF10B981).withValues(alpha: 0.85)
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke;
      for (final _Vec3 k in <_Vec3>[pose.kneeL, pose.kneeR]) {
        final _ProjectedPoint pk = camera.project(k);
        canvas.drawCircle(pk.screen, (0.048 * pk.scale).clamp(5.0, 9.5), kneeShield);
      }
    }
  }

  void _paintBiomechanicalForces(
    Canvas canvas,
    Size size,
    _Camera3D camera,
    _Pose3D pose,
    double pulse,
  ) {
    bool tagPainted = false;
    for (final _ForceVector3D fv in pose.forces) {
      final Offset p0 = camera.project(fv.origin).screen;
      final Offset p1 = camera.project(fv.tip).screen;
      final Offset d = p1 - p0;
      final double len = d.distance;
      if (len < 6.0) {
        continue;
      }
      final Offset dir = d / len;
      final Offset perp = Offset(-dir.dy, dir.dx);

      final Paint shaftPaint = Paint()
        ..color = fv.color.withValues(alpha: 0.72 + 0.25 * pulse)
        ..strokeWidth = 2.1
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(p0, p1, shaftPaint);

      const double headLen = 6.8;
      const double headHalfW = 3.8;
      final Offset base = p1 - dir * headLen;
      final Path arrowHead = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(base.dx + perp.dx * headHalfW, base.dy + perp.dy * headHalfW)
        ..lineTo(base.dx - perp.dx * headHalfW, base.dy - perp.dy * headHalfW)
        ..close();
      canvas.drawPath(
        arrowHead,
        Paint()..color = fv.color.withValues(alpha: 0.92),
      );

      // Un seul repère court si la hauteur le permet afin d'éviter toute surcharge visuelle
      if (!tagPainted && fv.tag != null && size.height >= 175) {
        _paintMicroTag(canvas, p1 + const Offset(4, -8), fv.tag!, fv.color);
        tagPainted = true;
      }
    }
  }

  void _paintMicroTag(Canvas canvas, Offset pos, String text, Color accent) {
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Roboto',
          color: accent,
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    final Rect pill = Rect.fromLTWH(
      pos.dx - 4,
      pos.dy - 2,
      tp.width + 8,
      tp.height + 4,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(pill, const Radius.circular(4)),
      Paint()..color = const Color(0xFF090E17).withValues(alpha: 0.86),
    );
    tp.paint(canvas, pos);
  }

  (String, Color) _resolveBreathingAndCadenceCue(double normalizedPhase) {
    switch (exercise.motionKind) {
      case MannequinMotionKind.boxBreathingH2f:
        final int quad = (normalizedPhase * 4.0).floor().clamp(0, 3);
        return switch (quad) {
          0 => ('INSPIRE DOUCEMENT • 4S', _breathInhaleCyan),
          1 => ('GARDE POUMONS PLEINS • 4S', _breathExhaleEmerald),
          2 => ('EXPIRE LONGTEMPS • 4S', _secondaryAmber),
          _ => ('PAUSE POUMONS VIDES • 4S', const Color(0xFF8B5CF6)),
        };
      case MannequinMotionKind.rampMobility:
        return normalizedPhase < 0.5
            ? ('INSPIRE • OUVRE LA CAGE', _breathInhaleCyan)
            : ('EXPIRE • MOBILITÉ DOUCE', _breathExhaleEmerald);
      case MannequinMotionKind.rkcPlank:
      case MannequinMotionKind.hollowBodyHold:
      case MannequinMotionKind.floorLSit:
        return normalizedPhase < 0.5
            ? ('INSPIRE CALMEMENT • GAINE', _breathInhaleCyan)
            : ('EXPIRE • SERRE LES ABDOS', _breathExhaleEmerald);
      default:
        break;
    }

    if (normalizedPhase < 0.5) {
      return switch (exercise.family) {
        BiomechanicalFamily.upperPush => (
          'INSPIRE • CONTRÔLE LA DESCENTE',
          _breathInhaleCyan,
        ),
        BiomechanicalFamily.noBarPull => (
          'INSPIRE • OUVRE LES ÉPAULES',
          _breathInhaleCyan,
        ),
        BiomechanicalFamily.tacticalLegs => (
          'INSPIRE • DESCENDS SOUPLEMENT',
          _breathInhaleCyan,
        ),
        BiomechanicalFamily.ironCore => (
          'INSPIRE • GARDE LE DOS PLAQUÉ',
          _breathInhaleCyan,
        ),
        BiomechanicalFamily.metCon => (
          'INSPIRE • RYTHME RÉGULIER',
          _breathInhaleCyan,
        ),
      };
    }

    return switch (exercise.family) {
      BiomechanicalFamily.upperPush => (
        'EXPIRE • POUSSE FLUIDE',
        _breathExhaleEmerald,
      ),
      BiomechanicalFamily.noBarPull => (
        'EXPIRE • SERRE LE HAUT DU DOS',
        _breathExhaleEmerald,
      ),
      BiomechanicalFamily.tacticalLegs => (
        'EXPIRE • REMONTE TALONS ANCRÉS',
        _breathExhaleEmerald,
      ),
      BiomechanicalFamily.ironCore => (
        'EXPIRE • ENGAGE LE GAINAGE',
        _breathExhaleEmerald,
      ),
      BiomechanicalFamily.metCon => (
        'EXPIRE • CADENCE FLUIDE',
        _breathExhaleEmerald,
      ),
    };
  }

  void _paintTelemetryHudAndLegend(
    Canvas canvas,
    Size size,
    _Pose3D pose,
    double normalizedPhase,
  ) {
    if (size.height < 115 || size.width < 160) {
      return;
    }

    // Bandeau haut-gauche : Guide synchronisé Respiration & Rythme
    final (String breathLabel, Color breathColor) =
        _resolveBreathingAndCadenceCue(normalizedPhase);
    _paintHudChip(
      canvas,
      offset: const Offset(10, 8),
      label: breathLabel,
      accent: breathColor,
      maxWidth: size.width * 0.58,
      leadingDotColor: breathColor,
    );

    // Sous-pastille haut-gauche : Confort articulaire ou mode sans saut (évite le bouton Caméra haut-droite)
    if (stealthMode || jointMode != JointFriendlyMode.standard) {
      final String modeLabel = jointMode == JointFriendlyMode.wristFriendly
          ? 'POIGNETS PROTÉGÉS'
          : jointMode == JointFriendlyMode.kneeFriendly
          ? 'GENOUX MÉNAGÉS'
          : 'MODE SANS SAUT';
      _paintHudChip(
        canvas,
        offset: const Offset(10, 31),
        label: modeLabel,
        accent: _breathExhaleEmerald,
        maxWidth: size.width * 0.54,
        leadingDotColor: _breathExhaleEmerald,
      );
    }

    // Bandeau bas épuré : Zones musculaires actives + barre fluide de cadence 60 FPS
    if (size.height >= 145) {
      final List<String> activeZones = <String>[
        ...exercise.primaryMuscles.take(2).map(_shortMuscleLabel),
        ...exercise.secondaryMuscles.take(1).map(_shortMuscleLabel),
      ];
      final String zonesText = activeZones.join(' · ');

      const double barH = 26.0;
      final double barY = size.height - barH - 6.0;
      final Rect legendRect = Rect.fromLTWH(10, barY, size.width - 20, barH);
      canvas.drawRRect(
        RRect.fromRectAndRadius(legendRect, const Radius.circular(8)),
        Paint()..color = const Color(0xFF090E17).withValues(alpha: 0.86),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(legendRect, const Radius.circular(8)),
        Paint()
          ..color = const Color(0xFF334155).withValues(alpha: 0.55)
          ..strokeWidth = 0.85
          ..style = PaintingStyle.stroke,
      );

      final TextPainter legendTp = TextPainter(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 10.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          children: <InlineSpan>[
            const TextSpan(
              text: 'Zones actives : ',
              style: TextStyle(
                color: _primaryCoral,
                fontSize: 10.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextSpan(
              text: zonesText,
              style: const TextStyle(color: Color(0xFFF8FAFC)),
            ),
          ],
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: size.width - 36);

      legendTp.paint(canvas, Offset(18, barY + 4.0));

      // Piste horizontale de cadence fluide (0..100 % du cycle du mouvement)
      final double trackLeft = 18.0;
      final double trackWidth = math.max(24.0, size.width - 36.0);
      final double trackY = barY + barH - 5.5;
      final RRect trackBg = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, trackWidth, 3.0),
        const Radius.circular(2),
      );
      canvas.drawRRect(
        trackBg,
        Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.90),
      );

      final double fillW = (trackWidth * normalizedPhase).clamp(3.0, trackWidth);
      final RRect trackFill = RRect.fromRectAndRadius(
        Rect.fromLTWH(trackLeft, trackY, fillW, 3.0),
        const Radius.circular(2),
      );
      canvas.drawRRect(
        trackFill,
        Paint()..color = breathColor.withValues(alpha: 0.92),
      );
      canvas.drawCircle(
        Offset(trackLeft + fillW, trackY + 1.5),
        2.6,
        Paint()..color = const Color(0xFFF8FAFC),
      );
    }
  }

  void _paintHudChip(
    Canvas canvas, {
    required Offset offset,
    required String label,
    required Color accent,
    required double maxWidth,
    bool alignRight = false,
    Color? leadingDotColor,
  }) {
    final double dotSpace = leadingDotColor != null ? 10.0 : 0.0;
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontFamily: 'Roboto',
          color: Color(0xFFF8FAFC),
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.45,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: math.max(40, maxWidth - 16 - dotSpace));

    final double boxW = tp.width + 14 + dotSpace;
    final double boxH = tp.height + 6;
    final double left = alignRight ? offset.dx - boxW : offset.dx;
    final Rect r = Rect.fromLTWH(left, offset.dy, boxW, boxH);

    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(6)),
      Paint()..color = const Color(0xFF090E17).withValues(alpha: 0.88),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(6)),
      Paint()
        ..color = accent.withValues(alpha: 0.62)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke,
    );
    if (leadingDotColor != null) {
      canvas.drawCircle(
        Offset(left + 8.5, offset.dy + boxH * 0.5),
        3.0,
        Paint()..color = leadingDotColor,
      );
    }
    tp.paint(canvas, Offset(left + 7 + dotSpace, offset.dy + 3.0));
  }

  String _shortMuscleLabel(MuscleGroup m) {
    return switch (m) {
      MuscleGroup.pectorals => 'Pectoraux',
      MuscleGroup.anteriorDeltoid => 'Épaules avant',
      MuscleGroup.lateralDeltoid => 'Épaules',
      MuscleGroup.posteriorDeltoid => 'Arrière d\'épaule',
      MuscleGroup.triceps => 'Triceps',
      MuscleGroup.bicepsForearms => 'Biceps & avant-bras',
      MuscleGroup.rhomboidsTraps => 'Haut du dos',
      MuscleGroup.latissimusDorsi => 'Grand dorsal',
      MuscleGroup.erectorSpinae => 'Lombaires',
      MuscleGroup.rectusAbdominis => 'Abdos',
      MuscleGroup.obliques => 'Obliques',
      MuscleGroup.glutes => 'Fessiers',
      MuscleGroup.quadriceps => 'Cuisses',
      MuscleGroup.hamstrings => 'Arrière des cuisses',
      MuscleGroup.calves => 'Mollets',
    };
  }

  // ===========================================================================
  // MOTEUR CINÉMATIQUE EXHAUSTIF DES 25 MOUVEMENTS SANS MATÉRIEL (60-120 FPS)
  // ===========================================================================

  _Pose3D _computePoseForExercise(double phase) {
    // Onde sinusoïdale douce 0 -> 1 -> 0 (0 = position initiale, 1 = pic d'amplitude)
    final double wave = 0.5 - 0.5 * math.cos(phase * 2.0 * math.pi);
    final bool sideRight = phase >= 0.5;
    final double halfPhase = (phase * 2.0) % 1.0;
    final double halfWave = 0.5 - 0.5 * math.cos(halfPhase * 2.0 * math.pi);
    final double fistLift = jointMode == JointFriendlyMode.wristFriendly
        ? 0.035
        : 0.0;
    final double kneeDepthScale = jointMode == JointFriendlyMode.kneeFriendly
        ? 0.58
        : 1.0;

    return switch (exercise.motionKind) {
      // -----------------------------------------------------------------------
      // FAMILLE 1 : UPPER PUSH (5 ÉCHELONS)
      // -----------------------------------------------------------------------
      MannequinMotionKind.pushupIncline => _posePushup(
        wave: wave,
        inclineHeight: jointMode == JointFriendlyMode.kneeFriendly ? 0.44 : 0.34,
        fistLift: fistLift,
        badge: 'POMPE INCLINÉE',
      ),
      MannequinMotionKind.pushupStrict => _posePushup(
        wave: wave,
        inclineHeight: 0.0,
        fistLift: fistLift,
        badge: 'GAINAGE ALIGNÉ',
      ),
      MannequinMotionKind.pushupPike => _posePikePushup(
        wave: wave,
        fistLift: fistLift,
      ),
      MannequinMotionKind.pushupArcher => _poseArcherPushup(
        wave: halfWave,
        activeRight: sideRight,
        fistLift: fistLift,
      ),
      MannequinMotionKind.pushupOneArm => _poseOneArmPushup(
        wave: wave,
        fistLift: fistLift,
      ),

      // -----------------------------------------------------------------------
      // FAMILLE 2 : NO-BAR PULL & SCAPULA (5 ÉCHELONS)
      // -----------------------------------------------------------------------
      MannequinMotionKind.proneCobra => _poseProneCobra(wave: wave),
      MannequinMotionKind.proneIytw => _poseProneIytw(phase: phase),
      MannequinMotionKind.supineElbowPress => _poseSupineElbowPress(wave: wave),
      MannequinMotionKind.slidingFloorPull => _poseSlidingFloorPull(wave: wave),
      MannequinMotionKind.thoracicBridge => _poseThoracicBridge(
        wave: halfWave,
        activeRight: sideRight,
      ),

      // -----------------------------------------------------------------------
      // FAMILLE 3 : TACTICAL LEGS (4 CINÉMATIQUES COUVRANT T1..T5)
      // -----------------------------------------------------------------------
      MannequinMotionKind.airSquat => _poseAirSquat(
        wave: wave,
        depthScale: kneeDepthScale,
      ),
      MannequinMotionKind.reverseLunge => _poseReverseLunge(
        wave: halfWave,
        stepRightBack: sideRight,
        depthScale: kneeDepthScale,
      ),
      MannequinMotionKind.cossackSquat => _poseCossackSquat(
        wave: halfWave,
        shiftRight: sideRight,
        depthScale: kneeDepthScale,
      ),
      MannequinMotionKind.pistolSquat => _posePistolSquat(
        wave: wave,
        depthScale: kneeDepthScale,
      ),

      // -----------------------------------------------------------------------
      // FAMILLE 4 : IRON CORE (5 ÉCHELONS)
      // -----------------------------------------------------------------------
      MannequinMotionKind.deadBug => _poseDeadBug(
        wave: halfWave,
        extendRightArmLeftLeg: sideRight,
      ),
      MannequinMotionKind.rkcPlank => _poseRkcPlank(phase: phase, wave: wave),
      MannequinMotionKind.hollowBodyHold => _poseHollowBodyHold(wave: wave),
      MannequinMotionKind.tacticalVUp => _poseTacticalVUp(wave: wave),
      MannequinMotionKind.floorLSit => _poseFloorLSit(
        wave: wave,
        fistLift: fistLift,
      ),

      // -----------------------------------------------------------------------
      // FAMILLE 5 : METCON & PROTOCOLES RAMP / H2F (6 CINÉMATIQUES)
      // -----------------------------------------------------------------------
      MannequinMotionKind.stepJacks => _poseStepJacks(
        wave: halfWave,
        stepRight: sideRight,
      ),
      MannequinMotionKind.jumpingJacks =>
        stealthMode
            ? _poseStepJacks(
                wave: halfWave,
                stepRight: sideRight,
                badgeOverride: 'PAS SANS IMPACT',
              )
            : _poseJumpingJacks(wave: wave),
      MannequinMotionKind.militaryBurpee => _poseMilitaryBurpee(
        phase: phase,
        fistLift: fistLift,
      ),
      MannequinMotionKind.sealBodybuilder => _poseSealBodybuilder(
        phase: phase,
        fistLift: fistLift,
      ),
      MannequinMotionKind.rampMobility => _poseRampMobility(
        wave: halfWave,
        openRight: sideRight,
      ),
      MannequinMotionKind.boxBreathingH2f => _poseBoxBreathingH2f(phase: phase),
    };
  }

  _Pose3D _buildSpineRig({
    required _Vec3 pelvis,
    required _Vec3 neck,
    required double shoulderHalfWidth,
    required double hipHalfWidth,
    required _Vec3 shoulderShiftL,
    required _Vec3 shoulderShiftR,
    required _Vec3 elbowL,
    required _Vec3 elbowR,
    required _Vec3 wristL,
    required _Vec3 wristR,
    required _Vec3 kneeL,
    required _Vec3 kneeR,
    required _Vec3 ankleL,
    required _Vec3 ankleR,
    required _Vec3 toeL,
    required _Vec3 toeR,
    required _Vec3 gazeDir,
    required double contraction,
    required bool isHorizontal,
    required List<_ForceVector3D> forces,
    double lumbarSag = 0.0,
    double propBoxHeight = 0.0,
    String? phaseBadge,
    double breathingExpansion = 0.0,
  }) {
    final _Vec3 spineDir = (neck - pelvis).normalized();
    final _Vec3 lumbar =
        _Vec3.lerp(pelvis, neck, 0.36) + _Vec3(0, lumbarSag, 0);
    final _Vec3 thorax =
        _Vec3.lerp(pelvis, neck, 0.72) + _Vec3(0, lumbarSag * 0.5, 0);
    final _Vec3 headCenter = neck + spineDir * 0.13;
    final _Vec3 headTop = neck + spineDir * 0.24;

    return _Pose3D(
      headCenter: headCenter,
      headTop: headTop,
      gazeDir: gazeDir.normalized(),
      neck: neck,
      thorax: thorax,
      lumbar: lumbar,
      pelvis: pelvis,
      shoulderL: _Vec3(neck.x, neck.y, neck.z - shoulderHalfWidth) + shoulderShiftL,
      shoulderR: _Vec3(neck.x, neck.y, neck.z + shoulderHalfWidth) + shoulderShiftR,
      elbowL: elbowL,
      elbowR: elbowR,
      wristL: wristL,
      wristR: wristR,
      hipL: _Vec3(pelvis.x, pelvis.y, pelvis.z - hipHalfWidth),
      hipR: _Vec3(pelvis.x, pelvis.y, pelvis.z + hipHalfWidth),
      kneeL: kneeL,
      kneeR: kneeR,
      ankleL: ankleL,
      ankleR: ankleR,
      toeL: toeL,
      toeR: toeR,
      contractionIntensity: contraction.clamp(0.0, 1.0),
      isHorizontalPosture: isHorizontal,
      forces: forces,
      propBoxHeight: propBoxHeight,
      phaseBadge: phaseBadge,
      breathingExpansion: breathingExpansion,
    );
  }

  // --- 1 & 2. Push-up Incline & Military Strict Push-up ---
  _Pose3D _posePushup({
    required double wave,
    required double inclineHeight,
    required double fistLift,
    required String badge,
  }) {
    final double handY = inclineHeight + 0.04 + fistLift;
    final double shoulderTopY = handY + 0.50;
    final double shoulderBottomY = handY + 0.16;
    final double shoulderY =
        shoulderTopY - (shoulderTopY - shoulderBottomY) * wave;

    const double ankleX = -0.80;
    const double ankleY = 0.09;
    const double neckX = 0.56;
    final _Vec3 pelvis = _Vec3(
      -0.14,
      ankleY + (shoulderY - ankleY) * 0.48,
      0.0,
    );
    final _Vec3 neck = _Vec3(neckX, shoulderY, 0.0);
    final _Vec3 kneeMid = _Vec3.lerp(
      const _Vec3(ankleX, ankleY, 0.0),
      pelvis,
      0.52,
    );

    // Coudes orientés à 45° vers l'arrière (doctrine FM 7-22)
    final double elbowFlareZ = 0.25 + 0.06 * wave;
    final double elbowBackX = 0.52 - 0.18 * wave;
    final double elbowY = handY + 0.26 - 0.09 * wave;

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.12,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(elbowBackX, elbowY, -elbowFlareZ),
      elbowR: _Vec3(elbowBackX, elbowY, elbowFlareZ),
      wristL: _Vec3(0.56, handY, -0.22),
      wristR: _Vec3(0.56, handY, 0.22),
      kneeL: _Vec3(kneeMid.x, kneeMid.y, -0.10),
      kneeR: _Vec3(kneeMid.x, kneeMid.y, 0.10),
      ankleL: const _Vec3(ankleX, ankleY, -0.09),
      ankleR: const _Vec3(ankleX, ankleY, 0.09),
      toeL: const _Vec3(ankleX - 0.06, 0.02, -0.09),
      toeR: const _Vec3(ankleX - 0.06, 0.02, 0.09),
      gazeDir: const _Vec3(0.45, -0.85, 0),
      contraction: wave,
      isHorizontal: true,
      propBoxHeight: inclineHeight,
      phaseBadge: badge,
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: _Vec3(0.56, shoulderY + 0.04, 0.0),
          tip: _Vec3(0.56, shoulderY + 0.28, 0.0),
          color: _primaryCoral,
          tag: 'POUSSÉE FLUIDE',
        ),
      ],
    );
  }

  // --- 3. Pike Push-up (Triangle équilatéral Tête-Mains) ---
  _Pose3D _posePikePushup({required double wave, required double fistLift}) {
    final double handY = 0.04 + fistLift;
    final _Vec3 pelvis = _Vec3(-0.08, 0.84 - 0.08 * wave, 0.0);
    // Le sommet du crâne plonge EN AVANT des mains pour former un triangle
    final _Vec3 neck = _Vec3(
      0.34 + 0.14 * wave,
      0.46 - 0.24 * wave,
      0.0,
    );
    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.12,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(0.32 - 0.05 * wave, 0.28 - 0.10 * wave, -0.23),
      elbowR: _Vec3(0.32 - 0.05 * wave, 0.28 - 0.10 * wave, 0.23),
      wristL: _Vec3(0.38, handY, -0.21),
      wristR: _Vec3(0.38, handY, 0.21),
      kneeL: const _Vec3(-0.34, 0.46, -0.11),
      kneeR: const _Vec3(-0.34, 0.46, 0.11),
      ankleL: const _Vec3(-0.56, 0.12, -0.11),
      ankleR: const _Vec3(-0.56, 0.12, 0.11),
      toeL: const _Vec3(-0.50, 0.02, -0.11),
      toeR: const _Vec3(-0.50, 0.02, 0.11),
      gazeDir: const _Vec3(-0.55, -0.75, 0),
      contraction: wave,
      isHorizontal: true,
      phaseBadge: 'ÉPAULES EN V',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: neck,
          tip: neck + const _Vec3(-0.10, 0.28, 0.0),
          color: _primaryCoral,
          tag: 'ÉPAULES',
        ),
      ],
    );
  }

  // --- 4. Archer Push-up (Transfert latéral 75 % unilatéral, bras guide tendu) ---
  _Pose3D _poseArcherPushup({
    required double wave,
    required bool activeRight,
    required double fistLift,
  }) {
    final double handY = 0.04 + fistLift;
    final double shiftZ = (activeRight ? 0.22 : -0.22) * wave;
    final double shoulderY = 0.54 - 0.34 * wave;
    final _Vec3 pelvis = _Vec3(-0.14, 0.31 - 0.15 * wave, shiftZ * 0.55);
    final _Vec3 neck = _Vec3(0.55, shoulderY, shiftZ);

    final _Vec3 elbowL = activeRight
        ? _Vec3(0.55, (shoulderY + handY) * 0.52, -0.34) // Bras gauche tendu
        : _Vec3(0.38, handY + 0.16, -0.50); // Bras gauche fléchi
    final _Vec3 elbowR = activeRight
        ? _Vec3(0.38, handY + 0.16, 0.50) // Bras droit fléchi
        : _Vec3(0.55, (shoulderY + handY) * 0.52, 0.34); // Bras droit tendu

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.13,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: elbowL,
      elbowR: elbowR,
      wristL: _Vec3(0.55, handY, -0.46),
      wristR: _Vec3(0.55, handY, 0.46),
      kneeL: _Vec3(-0.48, 0.20 - 0.07 * wave, -0.16),
      kneeR: _Vec3(-0.48, 0.20 - 0.07 * wave, 0.16),
      ankleL: const _Vec3(-0.80, 0.09, -0.18),
      ankleR: const _Vec3(-0.80, 0.09, 0.18),
      toeL: const _Vec3(-0.85, 0.02, -0.18),
      toeR: const _Vec3(-0.85, 0.02, 0.18),
      gazeDir: const _Vec3(0.4, -0.9, 0),
      contraction: wave,
      isHorizontal: true,
      phaseBadge: activeRight ? 'APPUI DROIT' : 'APPUI GAUCHE',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: _Vec3(0.55, shoulderY, shiftZ),
          tip: _Vec3(0.55, shoulderY + 0.26, shiftZ),
          color: _primaryCoral,
          tag: 'TRANSFERT LATÉRAL',
        ),
      ],
    );
  }

  // --- 5. Strict One-Arm Push-up (Main sous sternum, main libre au lombaire) ---
  _Pose3D _poseOneArmPushup({required double wave, required double fistLift}) {
    final double handY = 0.04 + fistLift;
    final double shoulderY = 0.54 - 0.34 * wave;
    final _Vec3 pelvis = _Vec3(-0.14, 0.31 - 0.15 * wave, 0.0);
    final _Vec3 neck = _Vec3(0.55, shoulderY, 0.0);
    final _Vec3 lumbarBack = _Vec3(-0.02, pelvis.y + 0.12, 0.02);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.15,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      // Bras droit en appui sous le sternum, bras gauche verrouillé dans le dos
      elbowL: _Vec3(0.20, shoulderY + 0.05, -0.26),
      elbowR: _Vec3(0.39, handY + 0.20 - 0.08 * wave, 0.16),
      wristL: lumbarBack,
      wristR: _Vec3(0.54, handY, 0.02),
      kneeL: _Vec3(-0.48, 0.20 - 0.07 * wave, -0.24),
      kneeR: _Vec3(-0.48, 0.20 - 0.07 * wave, 0.24),
      ankleL: const _Vec3(-0.80, 0.09, -0.32),
      ankleR: const _Vec3(-0.80, 0.09, 0.32),
      toeL: const _Vec3(-0.85, 0.02, -0.32),
      toeR: const _Vec3(-0.85, 0.02, 0.32),
      gazeDir: const _Vec3(0.45, -0.85, 0),
      contraction: wave,
      isHorizontal: true,
      phaseBadge: 'GAINAGE ANTI-ROTATION',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: _Vec3(0.54, handY + 0.04, 0.02),
          tip: _Vec3(0.54, shoulderY + 0.24, 0.02),
          color: _primaryRed,
          tag: 'APPUI UNILATÉRAL',
        ),
      ],
    );
  }

  // --- 6. Prone Cobra & Scapular Pinch ---
  _Pose3D _poseProneCobra({required double wave}) {
    final double chestLift = 0.10 + 0.18 * wave;
    final _Vec3 pelvis = const _Vec3(-0.12, 0.07, 0.0);
    final _Vec3 neck = _Vec3(0.54, chestLift, 0.0);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.19,
      hipHalfWidth: 0.12,
      shoulderShiftL: _Vec3(-0.02 * wave, 0.03 * wave, 0.03 * wave),
      shoulderShiftR: _Vec3(-0.02 * wave, 0.03 * wave, -0.03 * wave),
      elbowL: _Vec3(0.24, 0.11 + 0.14 * wave, -0.24),
      elbowR: _Vec3(0.24, 0.11 + 0.14 * wave, 0.24),
      wristL: _Vec3(-0.04, 0.12 + 0.18 * wave, -0.26),
      wristR: _Vec3(-0.04, 0.12 + 0.18 * wave, 0.26),
      kneeL: const _Vec3(-0.48, 0.06, -0.10),
      kneeR: const _Vec3(-0.48, 0.06, 0.10),
      ankleL: const _Vec3(-0.82, 0.06, -0.09),
      ankleR: const _Vec3(-0.82, 0.06, 0.09),
      toeL: const _Vec3(-0.90, 0.02, -0.09),
      toeR: const _Vec3(-0.90, 0.02, 0.09),
      gazeDir: const _Vec3(0.35, -0.92, 0), // Menton rentré, nuque longue
      contraction: wave,
      isHorizontal: true,
      lumbarSag: -0.04 * wave,
      phaseBadge: 'OUVERTURE DU BUSTE',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: _Vec3(0.34, chestLift, 0.0),
          tip: _Vec3(0.28, chestLift + 0.22, 0.0),
          color: const Color(0xFF06B6D4),
          tag: 'OMOPLATES',
        ),
      ],
    );
  }

  // --- 7. Prone I-Y-T-W Scapular Raises (4 lettres séquentielles) ---
  _Pose3D _poseProneIytw({required double phase}) {
    final int stage = (phase * 4.0).floor().clamp(0, 3);
    final double local = (phase * 4.0) - stage;
    final double lift = math.sin(local * math.pi);
    final double chestY = 0.12 + 0.10 * lift;

    final (String letter, _Vec3 elL, _Vec3 wrL) = switch (stage) {
      0 => (
        'LETTRE I',
        _Vec3(0.76, chestY + 0.06 * lift, -0.17),
        _Vec3(0.96, chestY + 0.12 * lift, -0.15),
      ),
      1 => (
        'LETTRE Y',
        _Vec3(0.70, chestY + 0.07 * lift, -0.32),
        _Vec3(0.86, chestY + 0.14 * lift, -0.46),
      ),
      2 => (
        'LETTRE T',
        _Vec3(0.54, chestY + 0.08 * lift, -0.42),
        _Vec3(0.54, chestY + 0.14 * lift, -0.64),
      ),
      _ => (
        'TIRAGE EN W',
        _Vec3(0.32, chestY + 0.10 * lift, -0.34),
        _Vec3(0.52, chestY + 0.14 * lift, -0.44),
      ),
    };

    return _buildSpineRig(
      pelvis: const _Vec3(-0.14, 0.07, 0.0),
      neck: _Vec3(0.52, chestY, 0.0),
      shoulderHalfWidth: 0.19,
      hipHalfWidth: 0.12,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: elL,
      elbowR: _Vec3(elL.x, elL.y, -elL.z),
      wristL: wrL,
      wristR: _Vec3(wrL.x, wrL.y, -wrL.z),
      kneeL: const _Vec3(-0.48, 0.06, -0.10),
      kneeR: const _Vec3(-0.48, 0.06, 0.10),
      ankleL: const _Vec3(-0.82, 0.06, -0.09),
      ankleR: const _Vec3(-0.82, 0.06, 0.09),
      toeL: const _Vec3(-0.90, 0.02, -0.09),
      toeR: const _Vec3(-0.90, 0.02, 0.09),
      gazeDir: const _Vec3(0.3, -0.95, 0),
      contraction: 0.35 + 0.65 * lift,
      isHorizontal: true,
      phaseBadge: letter,
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: _Vec3(elL.x, elL.y, 0.0),
          tip: _Vec3(elL.x - 0.12, elL.y + 0.22, 0.0),
          color: const Color(0xFF06B6D4),
          tag: letter,
        ),
      ],
    );
  }

  // --- 8. Supine Elbow Press ---
  _Pose3D _poseSupineElbowPress({required double wave}) {
    // Décubitus dorsal, genoux fléchis, poussée des coudes au sol qui décolle le buste
    final double thoraxLift = 0.09 + 0.24 * wave;
    final _Vec3 pelvis = const _Vec3(-0.10, 0.08, 0.0);
    final _Vec3 neck = _Vec3(0.50, thoraxLift, 0.0);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.13,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      // Coudes plantés au sol à 45°, poings dressés vers le plafond
      elbowL: const _Vec3(0.36, 0.05, -0.32),
      elbowR: const _Vec3(0.36, 0.05, 0.32),
      wristL: const _Vec3(0.36, 0.32, -0.30),
      wristR: const _Vec3(0.36, 0.32, 0.30),
      kneeL: const _Vec3(-0.42, 0.38, -0.14),
      kneeR: const _Vec3(-0.42, 0.38, 0.14),
      ankleL: const _Vec3(-0.66, 0.05, -0.14),
      ankleR: const _Vec3(-0.66, 0.05, 0.14),
      toeL: const _Vec3(-0.76, 0.02, -0.14),
      toeR: const _Vec3(-0.76, 0.02, 0.14),
      gazeDir: const _Vec3(-0.25, 0.95, 0), // Regard plafond
      contraction: wave,
      isHorizontal: true,
      phaseBadge: 'POUSSÉE COUDES AU SOL',
      forces: <_ForceVector3D>[
        const _ForceVector3D(
          origin: _Vec3(0.36, 0.18, -0.32),
          tip: _Vec3(0.36, 0.01, -0.32),
          color: _secondaryAmber,
        ),
        _ForceVector3D(
          origin: _Vec3(0.32, thoraxLift, 0.0),
          tip: _Vec3(0.32, thoraxLift + 0.25, 0.0),
          color: _primaryCoral,
          tag: 'HAUT DU DOS',
        ),
      ],
    );
  }

  // --- 9. Prone Forearm Sliding Floor Pull-up ---
  _Pose3D _poseSlidingFloorPull({required double wave}) {
    // Le corps glisse vers l'avant (slideX) pendant que les avant-bras restent ancrés au sol
    final double slideX = -0.22 + 0.34 * wave;
    final _Vec3 pelvis = _Vec3(-0.18 + slideX, 0.08, 0.0);
    final _Vec3 neck = _Vec3(0.46 + slideX, 0.15 + 0.07 * wave, 0.0);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.12,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: const _Vec3(0.56, 0.05, -0.26),
      elbowR: const _Vec3(0.56, 0.05, 0.26),
      wristL: const _Vec3(0.80, 0.03, -0.24),
      wristR: const _Vec3(0.80, 0.03, 0.24),
      kneeL: _Vec3(-0.52 + slideX, 0.06, -0.11),
      kneeR: _Vec3(-0.52 + slideX, 0.06, 0.11),
      ankleL: _Vec3(-0.80 + slideX, 0.14, -0.11),
      ankleR: _Vec3(-0.80 + slideX, 0.14, 0.11),
      toeL: _Vec3(-0.86 + slideX, 0.20, -0.11),
      toeR: _Vec3(-0.86 + slideX, 0.20, 0.11),
      gazeDir: const _Vec3(0.5, -0.85, 0),
      contraction: wave,
      isHorizontal: true,
      phaseBadge: 'TIRAGE GLISSÉ',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: _Vec3(0.18 + slideX, 0.22, 0.0),
          tip: _Vec3(0.46 + slideX, 0.22, 0.0),
          color: _primaryCoral,
          tag: 'TIRAGE AU SOL',
        ),
      ],
    );
  }

  // --- 10. Single-Arm Sliding Pull & Thoracic Bridge ---
  _Pose3D _poseThoracicBridge({
    required double wave,
    required bool activeRight,
  }) {
    // Pont thoracique unilatéral : hanches hautes, 1 bras pilier au sol, l'autre en arc d'ouverture
    final double hipY = 0.26 + 0.34 * wave;
    final double neckY = 0.38 + 0.28 * wave;
    final _Vec3 pelvis = _Vec3(-0.08, hipY, 0.0);
    final _Vec3 neck = _Vec3(0.42, neckY, 0.0);

    final _Vec3 supportElbow = _Vec3(0.46, (neckY + 0.04) * 0.5, activeRight ? 0.22 : -0.22);
    final _Vec3 supportWrist = _Vec3(0.48, 0.04, activeRight ? 0.24 : -0.24);
    final _Vec3 reachElbow = _Vec3(
      0.52 + 0.10 * wave,
      neckY + 0.18 * wave,
      activeRight ? -0.22 : 0.22,
    );
    final _Vec3 reachWrist = _Vec3(
      0.66 + 0.14 * wave,
      neckY + 0.28 * wave,
      activeRight ? -0.12 : 0.12,
    );

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.19,
      hipHalfWidth: 0.13,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: activeRight ? reachElbow : supportElbow,
      elbowR: activeRight ? supportElbow : reachElbow,
      wristL: activeRight ? reachWrist : supportWrist,
      wristR: activeRight ? supportWrist : reachWrist,
      kneeL: _Vec3(-0.38, 0.38 + 0.10 * wave, -0.16),
      kneeR: _Vec3(-0.38, 0.38 + 0.10 * wave, 0.16),
      ankleL: const _Vec3(-0.56, 0.05, -0.16),
      ankleR: const _Vec3(-0.56, 0.05, 0.16),
      toeL: const _Vec3(-0.68, 0.02, -0.16),
      toeR: const _Vec3(-0.68, 0.02, 0.16),
      gazeDir: const _Vec3(0.2, 0.95, 0),
      contraction: wave,
      isHorizontal: true,
      lumbarSag: 0.06 * wave,
      phaseBadge: 'PONT D\'OUVERTURE',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: pelvis,
          tip: pelvis + const _Vec3(0, 0.26, 0),
          color: _primaryCoral,
          tag: 'OUVERTURE DU DOS',
        ),
      ],
    );
  }

  // --- 11. Air Squat / Pause Squat ---
  _Pose3D _poseAirSquat({required double wave, required double depthScale}) {
    final double d = wave * depthScale;
    final _Vec3 pelvis = _Vec3(-0.22 * d, 0.92 - 0.42 * d, 0.0);
    final _Vec3 neck = _Vec3(-0.04 * d + 0.05, 1.44 - 0.36 * d, 0.0);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.14,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(0.18 * d + 0.04, 1.16 - 0.22 * d, -0.22),
      elbowR: _Vec3(0.18 * d + 0.04, 1.16 - 0.22 * d, 0.22),
      wristL: _Vec3(0.42 * d + 0.10, 1.12 - 0.12 * d, -0.16),
      wristR: _Vec3(0.42 * d + 0.10, 1.12 - 0.12 * d, 0.16),
      kneeL: _Vec3(0.18 * d + 0.02, 0.50 - 0.04 * d, -0.20 - 0.04 * d),
      kneeR: _Vec3(0.18 * d + 0.02, 0.50 - 0.04 * d, 0.20 + 0.04 * d),
      ankleL: const _Vec3(0.0, 0.07, -0.18),
      ankleR: const _Vec3(0.0, 0.07, 0.18),
      toeL: const _Vec3(0.14, 0.02, -0.21),
      toeR: const _Vec3(0.14, 0.02, 0.21),
      gazeDir: const _Vec3(1.0, 0.04, 0),
      contraction: wave,
      isHorizontal: false,
      phaseBadge: jointMode == JointFriendlyMode.kneeFriendly
          ? 'AMPLITUDE DOUCE'
          : 'FLEXION COMPLÈTE',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: pelvis,
          tip: pelvis + const _Vec3(0, 0.34, 0),
          color: _primaryCoral,
          tag: 'CUISSES & FESSIERS',
        ),
      ],
    );
  }

  // --- 12. Tactical Reverse Lunge (Tibia avant vertical, genou arrière à 2 cm) ---
  _Pose3D _poseReverseLunge({
    required double wave,
    required bool stepRightBack,
    required double depthScale,
  }) {
    final double d = wave * depthScale;
    final _Vec3 pelvis = _Vec3(-0.16 * d, 0.92 - 0.34 * d, 0.0);
    final _Vec3 neck = _Vec3(-0.12 * d + 0.02, 1.44 - 0.32 * d, 0.0);

    final _Vec3 frontKnee = _Vec3(0.14, 0.50, stepRightBack ? -0.15 : 0.15);
    final _Vec3 frontAnkle = _Vec3(0.12, 0.07, stepRightBack ? -0.15 : 0.15);
    final _Vec3 frontToe = _Vec3(0.26, 0.02, stepRightBack ? -0.15 : 0.15);

    final _Vec3 backKnee = _Vec3(
      -0.02 - 0.28 * d,
      0.50 - 0.41 * d,
      stepRightBack ? 0.15 : -0.15,
    );
    final _Vec3 backAnkle = _Vec3(
      -0.02 - 0.64 * d,
      0.07 + 0.05 * d,
      stepRightBack ? 0.15 : -0.15,
    );
    final _Vec3 backToe = _Vec3(
      0.10 - 0.60 * d,
      0.02,
      stepRightBack ? 0.15 : -0.15,
    );

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.14,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(-0.08 * d, 1.15 - 0.28 * d, -0.23),
      elbowR: _Vec3(0.08 * d, 1.15 - 0.28 * d, 0.23),
      wristL: _Vec3(0.18 * d + 0.06, 1.18 - 0.24 * d, -0.18),
      wristR: _Vec3(0.10, 1.06 - 0.28 * d, 0.20),
      kneeL: stepRightBack ? frontKnee : backKnee,
      kneeR: stepRightBack ? backKnee : frontKnee,
      ankleL: stepRightBack ? frontAnkle : backAnkle,
      ankleR: stepRightBack ? backAnkle : frontAnkle,
      toeL: stepRightBack ? frontToe : backToe,
      toeR: stepRightBack ? backToe : frontToe,
      gazeDir: const _Vec3(1.0, 0.02, 0),
      contraction: wave,
      isHorizontal: false,
      phaseBadge: 'FENTE 90°/90°',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: frontAnkle,
          tip: frontAnkle + const _Vec3(0, 0.36, 0),
          color: _primaryCoral,
          tag: 'TALON AVANT',
        ),
      ],
    );
  }

  // --- 13. Cossack Squat (Squat latéral profond, jambe libre tendue orteils haut) ---
  _Pose3D _poseCossackSquat({
    required double wave,
    required bool shiftRight,
    required double depthScale,
  }) {
    final double d = wave * depthScale;
    final double latZ = (shiftRight ? 0.34 : -0.34) * d;
    final _Vec3 pelvis = _Vec3(-0.14 * d, 0.88 - 0.40 * d, latZ);
    final _Vec3 neck = _Vec3(0.02, 1.38 - 0.34 * d, latZ * 0.88);

    final _Vec3 bentKnee = _Vec3(0.18 * d, 0.48 - 0.04 * d, shiftRight ? 0.48 : -0.48);
    final _Vec3 straightKnee = _Vec3(0.02, 0.46 - 0.18 * d, shiftRight ? -0.22 : 0.22);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.14,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(0.16 * d, 1.12 - 0.24 * d, latZ - 0.20),
      elbowR: _Vec3(0.16 * d, 1.12 - 0.24 * d, latZ + 0.20),
      wristL: _Vec3(0.36 * d + 0.06, 1.08 - 0.20 * d, latZ - 0.10),
      wristR: _Vec3(0.36 * d + 0.06, 1.08 - 0.20 * d, latZ + 0.10),
      kneeL: shiftRight ? straightKnee : bentKnee,
      kneeR: shiftRight ? bentKnee : straightKnee,
      ankleL: const _Vec3(0.0, 0.07, -0.48),
      ankleR: const _Vec3(0.0, 0.07, 0.48),
      toeL: _Vec3(
        shiftRight ? 0.04 : 0.14,
        shiftRight ? 0.16 * d + 0.02 : 0.02,
        -0.52,
      ),
      toeR: _Vec3(
        shiftRight ? 0.14 : 0.04,
        shiftRight ? 0.02 : 0.16 * d + 0.02,
        0.52,
      ),
      gazeDir: const _Vec3(1.0, 0.0, 0),
      contraction: wave,
      isHorizontal: false,
      phaseBadge: 'FLEXION LATÉRALE',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: pelvis,
          tip: pelvis + const _Vec3(0, 0.30, 0),
          color: _primaryCoral,
          tag: 'HANCHES & CUISSES',
        ),
      ],
    );
  }

  // --- 14. Strict Pistol Squat (Équilibre 1 pied, jambe libre tendue horizontale) ---
  _Pose3D _posePistolSquat({required double wave, required double depthScale}) {
    final double d = wave * depthScale;
    final _Vec3 pelvis = _Vec3(-0.20 * d, 0.90 - 0.52 * d, 0.06);
    final _Vec3 neck = _Vec3(0.06 * d + 0.02, 1.40 - 0.44 * d, 0.06);

    // Jambe droite porteuse, jambe gauche tendue devant parallèlement au sol
    final double freeLegY = 0.46 - 0.22 * d;
    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.19,
      hipHalfWidth: 0.13,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(0.24 * d + 0.08, 1.14 - 0.32 * d, -0.14),
      elbowR: _Vec3(0.24 * d + 0.08, 1.14 - 0.32 * d, 0.24),
      wristL: _Vec3(0.50 * d + 0.16, 1.08 - 0.28 * d, -0.10),
      wristR: _Vec3(0.50 * d + 0.16, 1.08 - 0.28 * d, 0.20),
      kneeL: _Vec3(0.24 + 0.12 * d, freeLegY + 0.04, -0.10),
      kneeR: _Vec3(0.20 * d + 0.02, 0.48 - 0.06 * d, 0.14),
      ankleL: _Vec3(0.54 + 0.16 * d, freeLegY, -0.10),
      ankleR: const _Vec3(0.0, 0.07, 0.12),
      toeL: _Vec3(0.66 + 0.16 * d, freeLegY + 0.08, -0.10),
      toeR: const _Vec3(0.15, 0.02, 0.12),
      gazeDir: const _Vec3(1.0, 0.0, 0),
      contraction: wave,
      isHorizontal: false,
      phaseBadge: 'SQUAT SUR 1 JAMBE',
      forces: <_ForceVector3D>[
        const _ForceVector3D(
          origin: _Vec3(0.0, 0.12, 0.12),
          tip: _Vec3(0.0, 0.48, 0.12),
          color: _primaryRed,
          tag: 'ÉQUILIBRE 1 PIED',
        ),
      ],
    );
  }

  // --- 15. Dead Bug Strict (Lombaires plaquées, extension controlatérale) ---
  _Pose3D _poseDeadBug({
    required double wave,
    required bool extendRightArmLeftLeg,
  }) {
    final _Vec3 pelvis = const _Vec3(-0.08, 0.07, 0.0);
    final _Vec3 neck = const _Vec3(0.48, 0.11, 0.0);

    final double armR = extendRightArmLeftLeg ? wave : 0.0;
    final double armL = extendRightArmLeftLeg ? 0.0 : wave;
    final double legL = extendRightArmLeftLeg ? wave : 0.0;
    final double legR = extendRightArmLeftLeg ? 0.0 : wave;

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.19,
      hipHalfWidth: 0.13,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(0.46 + 0.24 * armL, 0.36 - 0.18 * armL, -0.20),
      elbowR: _Vec3(0.46 + 0.24 * armR, 0.36 - 0.18 * armR, 0.20),
      wristL: _Vec3(0.46 + 0.44 * armL, 0.58 - 0.42 * armL, -0.20),
      wristR: _Vec3(0.46 + 0.44 * armR, 0.58 - 0.42 * armR, 0.20),
      kneeL: _Vec3(-0.10 - 0.36 * legL, 0.44 - 0.28 * legL, -0.14),
      kneeR: _Vec3(-0.10 - 0.36 * legR, 0.44 - 0.28 * legR, 0.14),
      ankleL: _Vec3(-0.42 - 0.38 * legL, 0.44 - 0.30 * legL, -0.14),
      ankleR: _Vec3(-0.42 - 0.38 * legR, 0.44 - 0.30 * legR, 0.14),
      toeL: _Vec3(-0.44 - 0.44 * legL, 0.52 - 0.34 * legL, -0.14),
      toeR: _Vec3(-0.44 - 0.44 * legR, 0.52 - 0.34 * legR, 0.14),
      gazeDir: const _Vec3(0.0, 1.0, 0),
      contraction: 0.45 + 0.55 * wave,
      isHorizontal: true,
      lumbarSag: -0.02, // Lombaires plaquées au sol
      phaseBadge: 'GAINAGE DOS PLAQUÉ',
      forces: <_ForceVector3D>[
        const _ForceVector3D(
          origin: _Vec3(0.18, 0.26, 0.0),
          tip: _Vec3(0.18, 0.04, 0.0),
          color: Color(0xFF8B5CF6),
          tag: 'LOMBAIRES PLAQUÉES',
        ),
      ],
    );
  }

  // --- 16. Gainage Actif sur Coudes ---
  _Pose3D _poseRkcPlank({required double phase, required double wave}) {
    final double microTremor = 0.008 * math.sin(phase * 12.0 * math.pi);
    final _Vec3 pelvis = _Vec3(-0.16, 0.29 + microTremor, 0.0);
    final _Vec3 neck = _Vec3(0.50, 0.31 + microTremor, 0.0);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.19,
      hipHalfWidth: 0.12,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: const _Vec3(0.50, 0.05, -0.20),
      elbowR: const _Vec3(0.50, 0.05, 0.20),
      wristL: const _Vec3(0.68, 0.04, -0.06),
      wristR: const _Vec3(0.68, 0.04, 0.06),
      kneeL: const _Vec3(-0.48, 0.19, -0.10),
      kneeR: const _Vec3(-0.48, 0.19, 0.10),
      ankleL: const _Vec3(-0.80, 0.09, -0.09),
      ankleR: const _Vec3(-0.80, 0.09, 0.09),
      toeL: const _Vec3(-0.84, 0.02, -0.09),
      toeR: const _Vec3(-0.84, 0.02, 0.09),
      gazeDir: const _Vec3(0.3, -0.95, 0),
      contraction: 0.65 + 0.35 * wave,
      isHorizontal: true,
      lumbarSag: 0.02,
      phaseBadge: 'GAINAGE ACTIF',
      forces: <_ForceVector3D>[
        const _ForceVector3D(
          origin: _Vec3(0.46, 0.12, 0.0),
          tip: _Vec3(0.18, 0.12, 0.0),
          color: _primaryCoral,
          tag: 'ABDOS SERRÉS',
        ),
        const _ForceVector3D(
          origin: _Vec3(-0.72, 0.12, 0.0),
          tip: _Vec3(-0.44, 0.12, 0.0),
          color: _primaryCoral,
        ),
      ],
    );
  }

  // --- 17. Gainage Tonique Dos Plaqué ---
  _Pose3D _poseHollowBodyHold({required double wave}) {
    final double rock = 0.03 * wave;
    final _Vec3 pelvis = const _Vec3(-0.04, 0.07, 0.0);
    final _Vec3 neck = _Vec3(0.50, 0.22 + rock, 0.0);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.18,
      hipHalfWidth: 0.12,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(0.70, 0.32 + rock, -0.17),
      elbowR: _Vec3(0.70, 0.32 + rock, 0.17),
      wristL: _Vec3(0.90, 0.42 + rock, -0.15),
      wristR: _Vec3(0.90, 0.42 + rock, 0.15),
      kneeL: _Vec3(-0.40, 0.20 - rock * 0.5, -0.09),
      kneeR: _Vec3(-0.40, 0.20 - rock * 0.5, 0.09),
      ankleL: _Vec3(-0.76, 0.34 - rock, -0.08),
      ankleR: _Vec3(-0.76, 0.34 - rock, 0.08),
      toeL: _Vec3(-0.88, 0.38 - rock, -0.08),
      toeR: _Vec3(-0.88, 0.38 - rock, 0.08),
      gazeDir: const _Vec3(-0.45, 0.88, 0),
      contraction: 0.60 + 0.40 * wave,
      isHorizontal: true,
      lumbarSag: -0.06, // Courbe concave lombaires au tapis
      phaseBadge: 'GAINAGE TONIQUE',
      forces: <_ForceVector3D>[
        const _ForceVector3D(
          origin: _Vec3(0.20, 0.26, 0.0),
          tip: _Vec3(0.20, 0.05, 0.0),
          color: _primaryCoral,
          tag: 'DOS PLAQUÉ',
        ),
      ],
    );
  }

  // --- 18. Fermeture Abdominale en V ---
  _Pose3D _poseTacticalVUp({required double wave}) {
    final _Vec3 pelvis = const _Vec3(0.0, 0.08, 0.0);
    final double angle = 0.32 + 0.78 * wave;
    final _Vec3 neck = _Vec3(
      0.54 * math.cos(angle),
      0.08 + 0.54 * math.sin(angle),
      0.0,
    );
    final _Vec3 ankleMid = _Vec3(
      -0.78 * math.cos(angle),
      0.08 + 0.78 * math.sin(angle),
      0.0,
    );
    final _Vec3 kneeMid = _Vec3.lerp(pelvis, ankleMid, 0.50);
    final _Vec3 reachTarget = _Vec3.lerp(
      const _Vec3(0.88, 0.32, 0.0),
      ankleMid + const _Vec3(0.08, 0.02, 0.0),
      wave,
    );

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.18,
      hipHalfWidth: 0.12,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3.lerp(neck, reachTarget, 0.52) + const _Vec3(0, 0, -0.18),
      elbowR: _Vec3.lerp(neck, reachTarget, 0.52) + const _Vec3(0, 0, 0.18),
      wristL: reachTarget + const _Vec3(0, 0, -0.13),
      wristR: reachTarget + const _Vec3(0, 0, 0.13),
      kneeL: kneeMid + const _Vec3(0, 0, -0.10),
      kneeR: kneeMid + const _Vec3(0, 0, 0.10),
      ankleL: ankleMid + const _Vec3(0, 0, -0.09),
      ankleR: ankleMid + const _Vec3(0, 0, 0.09),
      toeL: ankleMid + const _Vec3(-0.08, 0.08, -0.09),
      toeR: ankleMid + const _Vec3(-0.08, 0.08, 0.09),
      gazeDir: const _Vec3(-0.7, 0.7, 0),
      contraction: wave,
      isHorizontal: true,
      phaseBadge: 'FERMETURE EN V',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: const _Vec3(0.0, 0.18, 0.0),
          tip: _Vec3(0.0, 0.44 + 0.14 * wave, 0.0),
          color: _primaryCoral,
          tag: 'ABDOS PROFONDS',
        ),
      ],
    );
  }

  // --- 19. Équerre Tonique au Sol ---
  _Pose3D _poseFloorLSit({required double wave, required double fistLift}) {
    final double handY = 0.04 + fistLift;
    final double lift = 0.14 + 0.07 * wave;
    final _Vec3 pelvis = _Vec3(-0.08, lift, 0.0);
    final _Vec3 neck = _Vec3(-0.06, lift + 0.54, 0.0);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.19,
      hipHalfWidth: 0.12,
      shoulderShiftL: const _Vec3(0, -0.03, 0), // Dépression scapulaire active
      shoulderShiftR: const _Vec3(0, -0.03, 0),
      elbowL: _Vec3(-0.03, (neck.y + handY) * 0.50, -0.22),
      elbowR: _Vec3(-0.03, (neck.y + handY) * 0.50, 0.22),
      wristL: _Vec3(0.02, handY, -0.22),
      wristR: _Vec3(0.02, handY, 0.22),
      kneeL: _Vec3(0.32, lift + 0.02, -0.10),
      kneeR: _Vec3(0.32, lift + 0.02, 0.10),
      ankleL: _Vec3(0.70, lift + 0.04, -0.09),
      ankleR: _Vec3(0.70, lift + 0.04, 0.09),
      toeL: _Vec3(0.82, lift + 0.09, -0.09),
      toeR: _Vec3(0.82, lift + 0.09, 0.09),
      gazeDir: const _Vec3(1.0, 0.0, 0),
      contraction: 0.70 + 0.30 * wave,
      isHorizontal: true,
      phaseBadge: 'ÉQUERRE AU SOL',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: pelvis,
          tip: pelvis + const _Vec3(0, 0.26, 0),
          color: _primaryRed,
          tag: 'MAINTIEN HAUT',
        ),
      ],
    );
  }

  // --- 20. Pas Toniques Sans Impact ---
  _Pose3D _poseStepJacks({
    required double wave,
    required bool stepRight,
    String badgeOverride = 'PAS TONIQUE SANS SAUT',
  }) {
    final double stepOut = 0.32 * wave;
    final double bodyShiftZ = (stepRight ? 0.10 : -0.10) * wave;
    final _Vec3 pelvis = _Vec3(0.0, 0.90 - 0.06 * wave, bodyShiftZ);
    final _Vec3 neck = _Vec3(0.02, 1.44 - 0.05 * wave, bodyShiftZ);

    final double armAngle = -1.25 + 2.55 * wave; // Bas -> Grand arc au-dessus de la tête
    final double elZ = 0.20 + 0.26 * math.cos(armAngle * 0.5);
    final double elY = neck.y - 0.10 + 0.22 * math.sin(armAngle);
    final double wrZ = 0.18 + 0.38 * math.cos(armAngle * 0.65);
    final double wrY = neck.y - 0.14 + 0.44 * math.sin(armAngle);

    final double leftZ = stepRight ? -0.14 : (-0.14 - stepOut);
    final double rightZ = stepRight ? (0.14 + stepOut) : 0.14;

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.14,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(0.02, elY, bodyShiftZ - elZ),
      elbowR: _Vec3(0.02, elY, bodyShiftZ + elZ),
      wristL: _Vec3(0.04, wrY, bodyShiftZ - wrZ),
      wristR: _Vec3(0.04, wrY, bodyShiftZ + wrZ),
      kneeL: _Vec3(0.04, 0.49, (bodyShiftZ - 0.14 + leftZ) * 0.5),
      kneeR: _Vec3(0.04, 0.49, (bodyShiftZ + 0.14 + rightZ) * 0.5),
      ankleL: _Vec3(0.0, 0.07, leftZ),
      ankleR: _Vec3(0.0, 0.07, rightZ),
      toeL: _Vec3(0.13, 0.02, leftZ - 0.02),
      toeR: _Vec3(0.13, 0.02, rightZ + 0.02),
      gazeDir: const _Vec3(1.0, 0.05, 0),
      contraction: wave,
      isHorizontal: false,
      phaseBadge: badgeOverride,
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: _Vec3(0.02, neck.y + 0.06, bodyShiftZ),
          tip: _Vec3(0.02, neck.y + 0.32, bodyShiftZ),
          color: _primaryCoral,
          tag: 'CARDIO SANS IMPACT',
        ),
      ],
    );
  }

  // --- 21. Sauts d'Écart Toniques ---
  _Pose3D _poseJumpingJacks({required double wave}) {
    final double airY = 0.11 * math.sin(wave * math.pi);
    final double spreadZ = 0.13 + 0.28 * wave;
    final _Vec3 pelvis = _Vec3(0.0, 0.91 + airY, 0.0);
    final _Vec3 neck = _Vec3(0.02, 1.45 + airY, 0.0);

    final double armAngle = -1.30 + 2.65 * wave;
    final double elY = neck.y - 0.08 + 0.23 * math.sin(armAngle);
    final double wrY = neck.y - 0.12 + 0.46 * math.sin(armAngle);
    final double wrZ = 0.14 + 0.36 * math.sin(wave * math.pi * 0.85);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.14,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(0.02, elY, -0.32),
      elbowR: _Vec3(0.02, elY, 0.32),
      wristL: _Vec3(0.04, wrY, -wrZ),
      wristR: _Vec3(0.04, wrY, wrZ),
      kneeL: _Vec3(0.03, 0.50 + airY, -spreadZ * 0.72),
      kneeR: _Vec3(0.03, 0.50 + airY, spreadZ * 0.72),
      ankleL: _Vec3(0.0, 0.07 + airY, -spreadZ),
      ankleR: _Vec3(0.0, 0.07 + airY, spreadZ),
      toeL: _Vec3(0.13, 0.02 + airY, -spreadZ - 0.03),
      toeR: _Vec3(0.13, 0.02 + airY, spreadZ + 0.03),
      gazeDir: const _Vec3(1.0, 0.04, 0),
      contraction: wave,
      isHorizontal: false,
      phaseBadge: 'SAUT TONIQUE FLUIDE',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: _Vec3(0.0, 0.12 + airY, 0.0),
          tip: _Vec3(0.0, 0.42 + airY, 0.0),
          color: _primaryRed,
          tag: 'APPUIS SOUPLES',
        ),
      ],
    );
  }

  // --- 22. Burpee Complet Contrôlé ---
  _Pose3D _poseMilitaryBurpee({
    required double phase,
    required double fistLift,
  }) {
    // 0.00..0.18 Squat mains au sol -> 0.18..0.62 Planche + Pompe -> 0.62..0.80 Retour Squat -> 0.80..1.00 Extension verticale
    if (phase < 0.18 || (phase >= 0.62 && phase < 0.80)) {
      final double crouchT = phase < 0.18
          ? (phase / 0.18)
          : (1.0 - (phase - 0.62) / 0.18);
      return _poseBurpeeCrouch(crouchT, fistLift, 'FLEXION MAINS AU SOL');
    } else if (phase >= 0.18 && phase < 0.62) {
      final double pushPhase = (phase - 0.18) / 0.44;
      final double pushWave = 0.5 - 0.5 * math.cos(pushPhase * 2.0 * math.pi);
      return _posePushup(
        wave: pushWave,
        inclineHeight: 0.0,
        fistLift: fistLift,
        badge: 'POMPE CONTRÔLÉE',
      );
    } else {
      final double extT = (phase - 0.80) / 0.20;
      final double extWave = math.sin(extT * math.pi);
      final double jumpY = stealthMode ? 0.0 : 0.16 * extWave;
      return _poseVerticalExtension(
        extWave: extWave,
        jumpY: jumpY,
        badge: stealthMode ? 'EXTENSION POINTES' : 'EXTENSION COMPLÈTE',
      );
    }
  }

  // --- 23. Enchaînement Complet Corps Entier ---
  _Pose3D _poseSealBodybuilder({
    required double phase,
    required double fistLift,
  }) {
    if (phase < 0.14) {
      return _poseBurpeeCrouch(phase / 0.14, fistLift, '1 • FLEXION');
    } else if (phase < 0.44) {
      final double p = (phase - 0.14) / 0.30;
      final double w = 0.5 - 0.5 * math.cos(p * 2.0 * math.pi);
      return _posePushup(
        wave: w,
        inclineHeight: 0.0,
        fistLift: fistLift,
        badge: '2 • POMPE',
      );
    } else if (phase < 0.70) {
      final double jackT = (phase - 0.44) / 0.26;
      final double jackWave = math.sin(jackT * math.pi);
      final double handY = 0.04 + fistLift;
      final double footZ = 0.10 + 0.34 * jackWave;
      return _buildSpineRig(
        pelvis: const _Vec3(-0.14, 0.31, 0.0),
        neck: const _Vec3(0.56, 0.54, 0.0),
        shoulderHalfWidth: 0.20,
        hipHalfWidth: 0.13,
        shoulderShiftL: const _Vec3(0, 0, 0),
        shoulderShiftR: const _Vec3(0, 0, 0),
        elbowL: _Vec3(0.54, handY + 0.25, -0.22),
        elbowR: _Vec3(0.54, handY + 0.25, 0.22),
        wristL: _Vec3(0.56, handY, -0.22),
        wristR: _Vec3(0.56, handY, 0.22),
        kneeL: _Vec3(-0.48, 0.20, -footZ * 0.65),
        kneeR: _Vec3(-0.48, 0.20, footZ * 0.65),
        ankleL: _Vec3(-0.80, 0.09, -footZ),
        ankleR: _Vec3(-0.80, 0.09, footZ),
        toeL: _Vec3(-0.85, 0.02, -footZ),
        toeR: _Vec3(-0.85, 0.02, footZ),
        gazeDir: const _Vec3(0.45, -0.85, 0),
        contraction: 0.65 + 0.35 * jackWave,
        isHorizontal: true,
        phaseBadge: stealthMode
            ? '3 • PAS LATÉRAL'
            : '3 • OUVERTURE PIEDS',
        forces: <_ForceVector3D>[
          _ForceVector3D(
            origin: const _Vec3(-0.78, 0.12, 0.0),
            tip: _Vec3(-0.78, 0.12, footZ + 0.08),
            color: _primaryCoral,
            tag: 'GAINAGE DYNAMIQUE',
          ),
        ],
      );
    } else if (phase < 0.84) {
      return _poseBurpeeCrouch(
        1.0 - (phase - 0.70) / 0.14,
        fistLift,
        '4 • RETOUR PIEDS',
      );
    } else {
      final double extWave = math.sin(((phase - 0.84) / 0.16) * math.pi);
      return _poseVerticalExtension(
        extWave: extWave,
        jumpY: stealthMode ? 0.0 : 0.12 * extWave,
        badge: '5 • REDRESSEMENT',
      );
    }
  }

  _Pose3D _poseBurpeeCrouch(double t, double fistLift, String badge) {
    final double handY = 0.04 + fistLift;
    final _Vec3 pelvis = _Vec3(-0.16, 0.82 - 0.44 * t, 0.0);
    final _Vec3 neck = _Vec3(0.18 * t + 0.04, 1.32 - 0.66 * t, 0.0);
    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.14,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(0.24 * t + 0.04, 0.96 - 0.62 * t, -0.22),
      elbowR: _Vec3(0.24 * t + 0.04, 0.96 - 0.62 * t, 0.22),
      wristL: _Vec3(0.32 * t + 0.08, 0.72 - (0.72 - handY) * t, -0.21),
      wristR: _Vec3(0.32 * t + 0.08, 0.72 - (0.72 - handY) * t, 0.21),
      kneeL: _Vec3(0.16, 0.46 - 0.08 * t, -0.22),
      kneeR: _Vec3(0.16, 0.46 - 0.08 * t, 0.22),
      ankleL: const _Vec3(-0.04, 0.07, -0.20),
      ankleR: const _Vec3(-0.04, 0.07, 0.20),
      toeL: const _Vec3(0.10, 0.02, -0.22),
      toeR: const _Vec3(0.10, 0.02, 0.22),
      gazeDir: const _Vec3(0.8, -0.5, 0),
      contraction: 0.55 + 0.45 * t,
      isHorizontal: false,
      phaseBadge: badge,
      forces: const <_ForceVector3D>[],
    );
  }

  _Pose3D _poseVerticalExtension({
    required double extWave,
    required double jumpY,
    required String badge,
  }) {
    final double heelLift = stealthMode ? 0.06 * extWave : jumpY;
    final _Vec3 pelvis = _Vec3(0.0, 0.92 + heelLift, 0.0);
    final _Vec3 neck = _Vec3(0.02, 1.46 + heelLift, 0.0);
    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.14,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: _Vec3(0.04, neck.y + 0.18 * extWave, -0.24),
      elbowR: _Vec3(0.04, neck.y + 0.18 * extWave, 0.24),
      wristL: _Vec3(0.06, neck.y + 0.40 * extWave, -0.20),
      wristR: _Vec3(0.06, neck.y + 0.40 * extWave, 0.20),
      kneeL: _Vec3(0.02, 0.50 + heelLift, -0.15),
      kneeR: _Vec3(0.02, 0.50 + heelLift, 0.15),
      ankleL: _Vec3(0.0, 0.07 + heelLift, -0.15),
      ankleR: _Vec3(0.0, 0.07 + heelLift, 0.15),
      toeL: _Vec3(0.13, 0.02 + jumpY, -0.15),
      toeR: _Vec3(0.13, 0.02 + jumpY, 0.15),
      gazeDir: const _Vec3(1.0, 0.15, 0),
      contraction: extWave,
      isHorizontal: false,
      phaseBadge: badge,
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: pelvis,
          tip: pelvis + const _Vec3(0, 0.36, 0),
          color: _primaryCoral,
          tag: stealthMode ? 'SANS SAUT' : 'EXTENSION HAUTE',
        ),
      ],
    );
  }

  // --- 24. Réveil Articulaire & Ouverture du Buste ---
  _Pose3D _poseRampMobility({required double wave, required bool openRight}) {
    final _Vec3 pelvis = const _Vec3(-0.08, 0.42, 0.0);
    final _Vec3 neck = _Vec3(0.36, 0.62 + 0.06 * wave, 0.0);

    // Main d'appui au sol + rotation thoracique du bras opposé vers le plafond
    final double reachY = 0.18 + 0.82 * wave;
    final double reachZ = (openRight ? 0.34 : -0.34) * (0.4 + 0.6 * wave);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.19,
      hipHalfWidth: 0.14,
      shoulderShiftL: const _Vec3(0, 0, 0),
      shoulderShiftR: const _Vec3(0, 0, 0),
      elbowL: openRight
          ? const _Vec3(0.36, 0.30, -0.20)
          : _Vec3(0.36, (neck.y + reachY) * 0.52, reachZ * 0.65),
      elbowR: openRight
          ? _Vec3(0.36, (neck.y + reachY) * 0.52, reachZ * 0.65)
          : const _Vec3(0.36, 0.30, 0.20),
      wristL: openRight
          ? const _Vec3(0.38, 0.04, -0.20)
          : _Vec3(0.34, reachY, reachZ),
      wristR: openRight
          ? _Vec3(0.34, reachY, reachZ)
          : const _Vec3(0.38, 0.04, 0.20),
      kneeL: openRight
          ? const _Vec3(-0.46, 0.20, -0.14)
          : const _Vec3(0.42, 0.44, -0.22),
      kneeR: openRight
          ? const _Vec3(0.42, 0.44, 0.22)
          : const _Vec3(-0.46, 0.20, 0.14),
      ankleL: openRight
          ? const _Vec3(-0.80, 0.09, -0.14)
          : const _Vec3(0.40, 0.06, -0.22),
      ankleR: openRight
          ? const _Vec3(0.40, 0.06, 0.22)
          : const _Vec3(-0.80, 0.09, 0.14),
      toeL: openRight
          ? const _Vec3(-0.86, 0.02, -0.14)
          : const _Vec3(0.54, 0.02, -0.22),
      toeR: openRight
          ? const _Vec3(0.54, 0.02, 0.22)
          : const _Vec3(-0.86, 0.02, 0.14),
      gazeDir: _Vec3(0.4, 0.7 * wave, openRight ? 0.5 : -0.5),
      contraction: 0.35 + 0.65 * wave,
      isHorizontal: true,
      phaseBadge: 'MOBILITÉ HANCHES & DOS',
      forces: <_ForceVector3D>[
        _ForceVector3D(
          origin: _Vec3(0.36, neck.y, 0.0),
          tip: _Vec3(0.34, reachY, reachZ),
          color: const Color(0xFF10B981),
          tag: 'OUVERTURE THORACIQUE',
        ),
      ],
    );
  }

  // --- 25. Retour au Calme & Respiration Guidée (4-4-4-4) ---
  _Pose3D _poseBoxBreathingH2f({required double phase}) {
    final int quad = (phase * 4.0).floor().clamp(0, 3);
    final double local = (phase * 4.0) - quad;
    final (double breath, String label) = switch (quad) {
      0 => (local, 'INSPIRE 4S'),
      1 => (1.0, 'PLEIN 4S'),
      2 => (1.0 - local, 'EXPIRE 4S'),
      _ => (0.0, 'VIDE 4S'),
    };

    // Posture assise droite & relâchée, mains posées sur les genoux
    final _Vec3 pelvis = const _Vec3(0.0, 0.10, 0.0);
    final _Vec3 neck = _Vec3(0.02, 0.68 + 0.03 * breath, 0.0);

    return _buildSpineRig(
      pelvis: pelvis,
      neck: neck,
      shoulderHalfWidth: 0.20,
      hipHalfWidth: 0.14,
      shoulderShiftL: _Vec3(0, 0.015 * breath, 0),
      shoulderShiftR: _Vec3(0, 0.015 * breath, 0),
      elbowL: const _Vec3(0.06, 0.38, -0.26),
      elbowR: const _Vec3(0.06, 0.38, 0.26),
      wristL: const _Vec3(0.24, 0.22, -0.28),
      wristR: const _Vec3(0.24, 0.22, 0.28),
      kneeL: const _Vec3(0.26, 0.14, -0.34),
      kneeR: const _Vec3(0.26, 0.14, 0.34),
      ankleL: const _Vec3(0.18, 0.05, 0.08),
      ankleR: const _Vec3(0.22, 0.05, -0.08),
      toeL: const _Vec3(0.20, 0.03, 0.16),
      toeR: const _Vec3(0.24, 0.03, -0.16),
      gazeDir: const _Vec3(1.0, 0.0, 0),
      contraction: 0.30 + 0.55 * breath,
      isHorizontal: true,
      phaseBadge: 'RESPIRATION • $label',
      breathingExpansion: breath,
      forces: const <_ForceVector3D>[],
    );
  }

  @override
  bool shouldRepaint(covariant AnatomicalMannequinPainter oldDelegate) {
    return oldDelegate.exercise.id != exercise.id ||
        (oldDelegate.animationPhase - animationPhase).abs() > 0.0005 ||
        oldDelegate.cameraAngle != cameraAngle ||
        oldDelegate.stealthMode != stealthMode ||
        oldDelegate.jointMode != jointMode;
  }
}
