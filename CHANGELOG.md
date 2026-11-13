# Changelog — MakeFit (`cloud.orbital8.makefit`)

## [v1.0.0] (`1.0.0+1`) - 2026-11-13

### Added

- **Recherche Scientifique, Biomécanique & Comportementale (`ORB-82` `@Spartan` & `ORB-83` `@Athena`)** :
  - Référentiel complet `docs/research/MILITARY_CALISTHENICS_CURRICULUM.md` : matrice des **25 exercices 100 % sans matériel (`5 familles × 5 échelons`)**, incluant le tirage au sol sans barre (*Prone Cobra*, *Prone I-Y-T-W*, *Supine Elbow Press / Floor Back Widows*, *Sliding Floor Pull-ups*, *Thoracic Bridge*), les variantes **Mode Silencieux Appartement (`0 saut`)**, les variantes **Wrist/Knee-Friendly**, le **Test PT Initial de 6 min (`IAO` sur 100)** et l'**Algorithme d'Auto-Régulation RPE (`1 à 5`)**.
  - Spécification comportementale `docs/research/TACTICAL_GAMIFICATION_AND_HABITS.md` : formule déterministe des **TXP**, barème des **12 Grades Militaires (`E-1` à `SF-2`)**, **4 Examens PT de Promotion**, découpage jour par jour des **4 Campagnes de 28 Jours**, **Streak Résilient à Double Bouclier** (*Mobilité H2F 5 min* + *Jetons de Permission Tactique*), **Audio Ducking `-12 dB`** et protocoles **RAMP (3 min) / Box Breathing H2F `4-4-4-4` (2 min)**.
- **Identité Visuelle Store-Ready, Logo Officiel, Miniatures & Insignes Vectoriels (`ORB-84` — `@Leonardo`)** :
  - Logo officiel `assets/branding/makefit_logo.svg` & `makefit_logo_1024.png` (`1024×1024`), icônes natives Android (`mipmap-mdpi` à `mipmap-xxxhdpi` + adaptive icons API 26+) et iOS (`AppIcon.appiconset`).
  - Bannière Store `assets/branding/makefit_feature_graphic_1024x500.png` et **5 Miniatures HD (`800×450`)** des Campagnes 28J & Routines Rapides (`assets/branding/thumbnails/*.png`).
  - 18 fichiers `<svg>` (`assets/vectors/*.svg`) et peintres vectoriels `CustomPainter` dans `lib/painters/makefit_vector_assets.dart` (`MakeFitLogoBadge`, `MilitaryRankBadge`, `BiomechanicalFamilyBadge`, `CampaignThumbnailBanner`, `TacticalDogTagIcon`).
- **Mannequin Anatomique 3D/2.5D 60 FPS, Moteur RPE/TXP/IAO & Packaging Store-Ready (`ORB-85` — `@Carbon`)** :
  - Rendu biomécanique procédural 3D/2.5D `AnatomicalMannequinPainter` (`lib/painters/anatomical_mannequin_painter.dart`) animant les **25 mouvements sans matériel** avec surbrillance thermique (`#EF4444` / `#F59E0B`) des muscles primaires et secondaires sous 3 angles de caméra (`3/4 Tactique`, `Profil`, `Face`).
  - Moteur `MakeFitEngine` (`lib/engine/makefit_engine.dart`), catalogue `MakeFitCatalog` (`lib/data/makefit_catalog.dart`), et configuration native Store-Ready Android/iOS (`cloud.orbital8.makefit`, Portrait verrouillé, WakeLock, Audio Ducking `-12 dB` & Vibrator).
- **Interface Mobile Tactical RPG, HUD Séance 2m & Game Juice 60/120 FPS (`ORB-86` — `@Miyamoto`)** :
  - Composants *Game Juice* (`lib/ui/makefit_juicy_widgets.dart`) : `JuicyTactical3DButton` à Squash & Stretch `0.94`, `InterpolatedTxpCounter` sous `RepaintBoundary`, `BoxBreathingRing` `4-4-4-4` et `RpeSelectorBar`.
  - Écrans `CommandCenterTab`, `WorkoutPlayerModal` (HUD géant lisible à 2m + Zone Sans Contact `112dp` anti-rebond `650 ms` + Modale de Victoire/Debriefing à rebond `Curves.elasticOut`), `SkillTreeAndCodexTab` (25 nœuds) et `BarracksAndTrialsTab` (12 Grades, 4 Examens PT, Calibrateur IAO 6 min, Équilibre Push/Pull & Medical Disclaimer).
