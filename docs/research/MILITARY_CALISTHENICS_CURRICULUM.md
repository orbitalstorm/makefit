# MAKEFIT (`v1.0.0`) — Référentiel Scientifique & Biomécanique : Programme Military Calisthenics 100 % Sans Matériel

**Projet :** [MakeFit](/ORB/projects/makefit) (`cloud.orbital8.makefit`)  
**Issue :** [ORB-82](/ORB/issues/ORB-82) — Parent : [ORB-81](/ORB/issues/ORB-81)  
**Auteur :** [@Spartan](agent://542e5fe3-eff4-4a5c-bec2-9567abff2eac) (*Docteur en Biomécanique & Spécialiste Préparation Physique Militaire — Zero-Equipment Calisthenics*)  
**Doctrines de Référence :** US Army *FM 7-22 Holistic Health and Fitness (H2F)*, US Navy SEAL *Naval Special Warfare Physical Training Guide (NSW PTG)*, USMC *PFT/CFT*, Légion Étrangère, Biomécanique Calisthénique Sans Charge Externe.

---

## 1. Principes Fondamentaux & Équilibre Articulaire "Zero-Equipment"

### 1.1. Contrainte Majeure du Domicile (`2m × 2m`, Zéro Équipement)
Un programme d'entraînement au poids du corps réellement **100 % sans matériel** (sans barre de traction, sans anneaux, sans haltères, sans bandes élastiques et sans mobilier fragile) doit résoudre deux défis biomécaniques critiques :
1. **La prévention du conflit sous-acromial et de la cyphose thoracique** : 90 % des programmes "sans matériel" saturent le grand pectoral et le deltoïde antérieur (excès de pompes) en négligeant les fixateurs d'omoplates (rhomboïdes, trapèzes moyens et inférieurs), les rotateurs externes de la coiffe (infra-épineux, petit rond) et le grand dorsal. **MakeFit impose un ratio obligatoire `1:1` entre les volumes de Poussée (*Upper Push*) et de Tirage au Sol / Rétraction Scapulaire (*No-Bar Floor Pull*)** en utilisant la friction du sol, la gravité en procubitus et la poussée verticale des coudes en décubitus dorsal.
2. **La modulation de l'intensité mécanique sans poids additionnel** : En l'absence d'haltères, la surcharge progressive s'opère sur **5 leviers biomécaniques** :
   - **Bras de levier momentané** (inclinaison du buste, éloignement du centre de masse),
   - **Répartition unilatérale** (transfert progressif de 50 % à 100 % du poids corporel sur un seul membre),
   - **Temps sous tension (*Time Under Tension — TUT*)** par tempos excentriques ralentis (`3-1-1-0`, `4-2-1-0`) et pauses isométriques à l'angle de contrainte maximale,
   - **Déficit d'amplitude ou instabilité contrôlée**,
   - **Vitesse d'exécution et cycle étirement-raccourcissement (pliométrie)** avec alternative isométrique/concentrique explosive sans saut en **Mode Silencieux Appartement (*Stealth Mode*)**.

---

## 2. Matrice Complète des 25 Exercices Sans Matériel (5 Familles × 5 Échelons)

### Vue Synthétique de l'Arbre de Compétences Biomécaniques (`5 × 5`)

| Famille Biomécanique | Code | Tier 1 — Recrue (*Débutant*) | Tier 2 — Soldat (*Standard*) | Tier 3 — Sous-Officier (*Intermédiaire*) | Tier 4 — Officier (*Avancé*) | Tier 5 — SpecOps (*Élite*) |
| :--- | :---: | :--- | :--- | :--- | :--- | :--- |
| **1. Poussée (*Upper Push*)** | `PUSH` | `EX_PUSH_T1`<br>**Incline / Knee Tactical Push-up** | `EX_PUSH_T2`<br>**Military Strict Push-up (45°)** | `EX_PUSH_T3`<br>**Diamond & Pike Push-up** | `EX_PUSH_T4`<br>**Archer & Pseudo-Planche Push-up** | `EX_PUSH_T5`<br>**Strict One-Arm / Wall Handstand Push-up** |
| **2. Tirage au Sol & Scapula (*No-Bar Pull*)** | `PULL` | `EX_PULL_T1`<br>**Prone Cobra & Scapular Pinch** | `EX_PULL_T2`<br>**Prone I-Y-T-W Scapular Raises** | `EX_PULL_T3`<br>**Supine Elbow Press (*Floor Back Widow*)** | `EX_PULL_T4`<br>**Prone Forearm Sliding Floor Pull-up** | `EX_PULL_T5`<br>**Single-Arm Sliding Pull & Thoracic Bridge** |
| **3. Membres Inférieurs (*Tactical Legs*)** | `LEGS` | `EX_LEGS_T1`<br>**Assisted Tempo Squat & Glute Bridge** | `EX_LEGS_T2`<br>**Military Air Squat & Reverse Lunge** | `EX_LEGS_T3`<br>**Pause Squat (3-2-1) & Single-Leg Bridge** | `EX_LEGS_T4`<br>**Cossack Squat & Hamstring Walkout** | `EX_LEGS_T5`<br>**Strict Pistol Squat & Shrimp Squat** |
| **4. Gainage Tactique (*Iron Core*)** | `CORE` | `EX_CORE_T1`<br>**Dead Bug Strict & McGill Curl-up** | `EX_CORE_T2`<br>**RKC Plank & 4-Count Flutter Kicks** | `EX_CORE_T3`<br>**Hollow Body Hold & Plank Shoulder Taps** | `EX_CORE_T4`<br>**Hollow Body Rocks & Tactical V-Ups** | `EX_CORE_T5`<br>**Floor L-Sit Hold & Shoulder-Anchored Dragon Flag** |
| **5. Cardio Métabolique (*MetCon*)** | `METCON` | `EX_METCON_T1`<br>**Step-Jacks & Squat-to-Reach** | `EX_METCON_T2`<br>**Military Jumping Jacks & Mountain Climbers** | `EX_METCON_T3`<br>**6-Count Military Burpee & Bear Crawl** | `EX_METCON_T4`<br>**8-Count Navy SEAL Bodybuilder** | `EX_METCON_T5`<br>**Devil Burpee (Double Push-up + Tuck) & Speed Crawl** |

---

### 2.1. Famille 1 : Poussée Horizontale & Verticale (*Upper Push*)

#### `EX_PUSH_T1` — Tier 1 (Recrue) : Incline / Knee Tactical Push-up
* **Muscles ciblés** :
  * *Agonistes primaires* : Grand pectoral faisceau sternal (`55 %`), Triceps brachial (`25 %`).
  * *Synergistes & Stabilisateurs* : Deltoïde antérieur (`10 %`), Dentelé antérieur & Transverse de l'abdomen (`10 %`).
* **Consignes biomécaniques d'exécution** :
  1. Placer les mains largeur d'épaules (surélevées sur un mur/rebord stable ou genoux au sol avec bassin en rétroversion stricte aligné genoux-hanches-épaules).
  2. Visser les paumes dans le sol (rotation externe humérale) pour abaisser les épaules loin des oreilles.
  3. Descendre en gardant les coudes à `45°` du buste jusqu'à effleurer le support avec le sternum, puis repousser jusqu'à l'extension complète avec protraction scapulaire en haut.
  * *HUD Cues (2m)* : `"Coudes à 45°"` · `"Bassin verrouillé"` · `"Poitrine au sol"`
* **Tempo recommandé** : `3-1-1-0` (3s descente contrôlée, 1s pause en bas sans relâcher la tension, 1s poussée, 0s repos en haut).
* **Erreur fréquente à éviter** : Cambrure lombaire (antéversion du bassin) ou coudes ouverts à `90°` en "T" qui écrasent la bourse sous-acromiale.
* **Variante Mode Silencieux Appartement (0 saut)** : Identique (mouvement intrinsèquement silencieux, `0 dB`).
* **Variante Wrist/Knee-Friendly** :
  * *Poignets sensibles* : Exécution sur les poings fermés (poignets neutres alignés avec le radius) sur tapis/serviette pliée, ou Wall Push-up debout.
  * *Genoux sensibles* : Privilégier la variante **Incline Push-up debout** (mains contre mur) pour supprimer tout appui patellaire au sol.

#### `EX_PUSH_T2` — Tier 2 (Soldat) : Military Strict Push-up (Standard FM 7-22)
* **Muscles ciblés** :
  * *Agonistes primaires* : Grand pectoral (`50 %`), Triceps brachial (`30 %`).
  * *Synergistes & Stabilisateurs* : Deltoïde antérieur (`10 %`), Dentelé antérieur, Grand droit et Fessiers en isométrie (`10 %`).
* **Consignes biomécaniques d'exécution** :
  1. Position de planche haute, pieds joints ou écartés largeur de hanches (standard US Army *Hand-Release / Strict Push-up*), index pointés vers l'avant, doigts écartés.
  2. Contracter simultanément les quadriceps et les fessiers pour transformer le corps en poutre rigide.
  3. Fléchir les coudes à `45°` vers l'arrière jusqu'à `2 cm` du sol, nuque neutre (regard à `50 cm` devant les mains), puis pousser explosivement jusqu'au verrouillage complet des coudes.
  * *HUD Cues (2m)* : `"Corps en planche"` · `"Coudes à 45°"` · `"Extension complète"`
* **Tempo recommandé** : `2-1-1-0` (Standard) ou `3-1-1-0` (Hypertrophie).
* **Erreur fréquente à éviter** : "Worming" (soulever les épaules avant le bassin) ou tête qui plonge vers le sol pour simuler l'amplitude complète.
* **Variante Mode Silencieux Appartement (0 saut)** : Identique (`0 saut`).
* **Variante Wrist/Knee-Friendly** : Exécution sur les **poings neutres (*Knuckle Push-ups*)** ou en décalant légèrement la paume vers l'extérieur (`15°`) avec appui prédominant sur l'éminence hypothénar pour réduire l'hyperextension du carpe.

#### `EX_PUSH_T3` — Tier 3 (Sous-Officier) : Diamond & Pike Push-up
* **Muscles ciblés** :
  * *Agonistes primaires* : Triceps brachial chef latéral/médial (`40 %`), Deltoïde antérieur et moyen (`35 %`), Grand pectoral faisceau claviculaire (`15 %`).
  * *Synergistes & Stabilisateurs* : Trapèze supérieur/inférieur, Dentelé antérieur (`10 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Diamond Push-up* : Mains rapprochées sous le sternum (pouces et index à `3–5 cm` d'écart pour respecter l'axe anatomique du coude), descente coudes collés aux côtes.
  2. *Pike Push-up* : Bassin fléchi en "V" inversé (angle tronc-cuisses `~90°`), talons décollés, descente du sommet du crâne en avant des mains pour former un **triangle équilatéral** entre les deux mains et la tête en position basse.
  * *HUD Cues (2m)* : `"Triangle Tête-Mains"` · `"Coudes serrés"` · `"Poussée verticale"`
* **Tempo recommandé** : `2-1-1-1` (1s de protraction scapulaire active en haut).
* **Erreur fréquente à éviter** : Descendre la tête entre les mains (ligne droite) au lieu de devant les mains en Pike Push-up, ce qui transforme le mouvement en flexion cervicale dangereuse.
* **Variante Mode Silencieux Appartement (0 saut)** : Identique (`0 saut`).
* **Variante Wrist/Knee-Friendly** : Remplacer le Diamond strict par des **Close-Grip Push-ups largeur bi-acromiale sur les poings** (supprime la déviation ulnaire forcée du poignet).

#### `EX_PUSH_T4` — Tier 4 (Officier) : Archer & Pseudo-Planche Push-up
* **Muscles ciblés** :
  * *Agonistes primaires* : Grand pectoral unilatéral (`45 %`), Deltoïde antérieur fortement étiré (`30 %`), Triceps (`15 %`).
  * *Synergistes & Stabilisateurs* : Biceps brachial (stabilisation tendon du long chef en Pseudo-Planche) et Obliques anti-rotation (`10 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Archer Push-up* : Mains écartées à `1.5×` la largeur d'épaules, doigts orientés à `45°` vers l'extérieur. Fléchir le bras gauche en portant 75 % du poids dessus tandis que le bras droit reste intégralement tendu en simple stabilisateur latéral. Alterner ou travailler en séries unilatérales.
  2. *Pseudo-Planche Push-up* : Mains placées à hauteur du nombril (doigts tournés à `45°–90°` sur les côtés), avancer les épaules de `15 à 20 cm` en avant des poignets, maintenir la protraction scapulaire ("dos rond haut") tout au long de la poussée.
  * *HUD Cues (2m)* : `"Bras d'appui 75%"` · `"Bras guide tendu"` · `"Épaules en avant"`
* **Tempo recommandé** : `3-1-1-1`.
* **Erreur fréquente à éviter** : Rotation du bassin vers le bras tendu lors de l'Archer Push-up ou perte de la protraction scapulaire en Pseudo-Planche.
* **Variante Mode Silencieux Appartement (0 saut)** : Remplace intégralement toute variante de *Clap Push-up* pliométrique par l'**Archer Push-up tempo `3-2-1-0`** (zéro impact au sol, tension mécanique supérieure).
* **Variante Wrist/Knee-Friendly** : Orienter les doigts à `90°` (vers l'extérieur) ou `135°` (vers l'arrière) en Pseudo-Planche pour supprimer le pincement dorsal du poignet, et limiter l'avancée des épaules à un angle de `75°`.

#### `EX_PUSH_T5` — Tier 5 (SpecOps) : Strict One-Arm Push-up / Wall Handstand Push-up (HSPU)
* **Muscles ciblés** :
  * *Agonistes primaires* : Grand pectoral / Deltoïde antérieur & moyen (`50 %`), Triceps brachial (`30 %`).
  * *Synergistes & Stabilisateurs* : Chaîne croisée antérieure (oblique interne homolatéral + oblique externe controlatéral + moyen fessier, `20 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Strict One-Arm Push-up* : Pieds écartés à `1.2×` largeur d'épaules, main d'appui placée sous l'axe médian du sternum, main libre verrouillée dans le bas du dos. Maintenir la ligne des deux épaules strictement parallèle au sol (`0°` de vrille thoracique), descendre le menton et la poitrine au sol, remonter en poussant le sol loin de soi.
  2. *Wall HSPU* : En appui tendu renversé face au mur (ventre au mur pour imposer le gainage *Hollow Body*), descendre la tête en triangle en avant des mains, repousser jusqu'à l'élévation scapulaire complète.
  * *HUD Cues (2m)* : `"Épaules parallèles"` · `"Gainage maximal"` · `"Verrouillage haut"`
* **Tempo recommandé** : `3-1-1-0`.
* **Erreur fréquente à éviter** : Vriller le buste à `45°` et écarter le coude à `90°` sur le One-Arm Push-up, ce qui cisaille la capsule gléno-humérale.
* **Variante Mode Silencieux Appartement (0 saut)** : Pour le Wall HSPU, montée et descente contrôlées en **Wall Walk silencieux** (sans jamais lancer les pieds violemment contre le mur).
* **Variante Wrist/Knee-Friendly** : **One-Arm Push-up sur le poing neutre** ou **Archer Push-up avec pause isométrique de 3 secondes en bas** pour réduire le couple de torsion sur le complexe fibro-cartilagineux triangulaire (TFCC) du poignet.

---

### 2.2. Famille 2 : Chaîne Postérieure, Rétraction Scapulaire & Tirage Sans Barre (*No-Bar Pull & Scapula*)

> [!IMPORTANT]
> Cette famille est la clé de voûte scientifique de **MakeFit** : elle permet de développer le dos, les rhomboïdes, la coiffe des rotateurs et le grand dorsal **sans aucune barre de traction ni table**, uniquement grâce à la gravité en procubitus et au levier des coudes/avant-bras au sol.

#### `EX_PULL_T1` — Tier 1 (Recrue) : Prone Cobra Hold & Scapular Pinch
* **Muscles ciblés** :
  * *Agonistes primaires* : Rhomboïdes majeur/mineur (`40 %`), Trapèzes moyen et inférieur (`35 %`).
  * *Synergistes & Stabilisateurs* : Érecteurs du rachis thoracique, Infra-épineux et Grand fessier (`25 %`).
* **Consignes biomécaniques d'exécution** :
  1. Allongé sur le ventre (procubitus), front à `3 cm` du sol (menton rentré en double-menton pour allonger la nuque), pieds joints, fessiers contractés pour protéger le rachis lombaire.
  2. Décoller les bras le long du corps, tourner les pouces vers le plafond (rotation externe complète de l'humérus) et serrer puissamment les omoplates vers l'arrière et vers le bas (direction les poches de pantalon).
  3. Maintenir la contraction maximale pendant `3 secondes` à chaque répétition avant de redescendre sans poser.
  * *HUD Cues (2m)* : `"Pouces au plafond"` · `"Omoplates serrées"` · `"Nuque longue"`
* **Tempo recommandé** : `1-0-1-3` (montée 1s, maintien isométrique haut 3s, descente 1s).
* **Erreur fréquente à éviter** : Hausser les épaules vers les oreilles (sur-activation du trapèze supérieur) ou casser la nuque en regardant devant soi.
* **Variante Mode Silencieux Appartement (0 saut)** : Identique (`0 dB`).
* **Variante Wrist/Knee-Friendly** : `100 %` sans appui sur les poignets ni flexion des genoux. En cas de sensibilité lombaire, garder le sternum posé au sol et ne décoller que les bras et les épaules.

#### `EX_PULL_T2` — Tier 2 (Soldat) : Prone I-Y-T-W Scapular Raises & Hand-Release Superman Pulls
* **Muscles ciblés** :
  * *Agonistes primaires* : Trapèze inférieur (fibres en `Y`), Trapèze moyen & Rhomboïdes (fibres en `T`), Coiffe des rotateurs & Grand dorsal (fibres en `W`, `70 %` du total).
  * *Synergistes & Stabilisateurs* : Deltoïde postérieur (`20 %`), Érecteurs du rachis (`10 %`).
* **Consignes biomécaniques d'exécution** :
  1. Allongé face au sol, fessiers verrouillés, exécuter séquentiellement sans reposer les mains au sol :
     * **I** : Bras tendus devant soi, pouces vers le haut, élévation par dépression scapulaire.
     * **Y** : Bras à `45°`, pouces vers le haut (cible spécifiquement le trapèze inférieur).
     * **T** : Bras à `90°`, pouces vers le haut (rétraction pure des rhomboïdes).
     * **W** : Tirage coudes vers les côtes en serrant les omoplates et en décollant la poitrine (*Superman Pull*).
  * *HUD Cues (2m)* : `"Séquence I-Y-T-W"` · `"Coudes aux côtes"` · `"Zéro élan"`
* **Tempo recommandé** : `2-0-1-2` (2s de contraction isométrique à chaque lettre).
* **Erreur fréquente à éviter** : Utiliser l'élan balistique lombaire au lieu d'isoler le glissement des omoplates sur la cage thoracique.
* **Variante Mode Silencieux Appartement (0 saut)** : Identique (`0 dB`).
* **Variante Wrist/Knee-Friendly** : Aucune charge sur les poignets ou les genoux. Exécutable debout dos au mur (*Wall Angels*) si la position ventrale est inconfortable.

#### `EX_PULL_T3` — Tier 3 (Sous-Officier) : Supine Elbow Press (*Floor Back Widows*) & Prone Swimmers
* **Muscles ciblés** :
  * *Agonistes primaires* : Grand dorsal (`35 %`), Rhomboïdes & Trapèze moyen (`35 %`), Deltoïde postérieur (`20 %`).
  * *Synergistes & Stabilisateurs* : Érecteurs thoraciques et fléchisseurs profonds du cou (`10 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Supine Elbow Press (Back Widow)* : Allongé sur le dos, genoux fléchis pieds à plat, coudes placés au sol à `45°` des côtes, avant-bras verticaux poings serrés vers le plafond.
  2. Pousser verticalement et violemment les coudes dans le sol pour **décoller intégralement le haut du dos et les omoplates du tapis** (seuls le bassin, les coudes et l'arrière du crâne léger ou décollé touchent le sol).
  3. Contracter le dos à fond en haut pendant `2s`, puis redescendre en contrôle.
  * *HUD Cues (2m)* : `"Pousse dans les coudes"` · `"Décolle les omoplates"` · `"Poitrine haute"`
* **Tempo recommandé** : `2-0-1-2`.
* **Erreur fréquente à éviter** : Pousser avec la tête dans le sol (pont cervical) au lieu de générer toute la force par la rétro-pulsion des humérus et des coudes.
* **Variante Mode Silencieux Appartement (0 saut)** : Identique (`0 dB`).
* **Variante Wrist/Knee-Friendly** : Zéro contrainte sur les poignets (appui sur l'olécrane/humérus distal ; placer une serviette pliée sous les coudes sur sol dur).

#### `EX_PULL_T4` — Tier 4 (Officier) : Prone Forearm Sliding Floor Pull-up & Reverse Plank
* **Muscles ciblés** :
  * *Agonistes primaires* : Grand dorsal (adduction et extension de l'épaule contre friction, `50 %`), Grand rond (`20 %`).
  * *Synergistes & Stabilisateurs* : Biceps brachial / Brachio-radial (`15 %`), Rhomboïdes et Chaîne postérieure complète en Reverse Plank (`15 %`).
* **Consignes biomécaniques d'exécution** :
  1. Allongé sur le ventre sur sol lisse (ou avec une serviette sous le bassin/cuisses), placer les avant-bras et les paumes à plat loin devant soi.
  2. Presser fortement les paumes et avant-bras dans le sol, abaisser les épaules et **tirer son propre corps vers l'avant** par l'action exclusive des dorsaux jusqu'à ce que les coudes arrivent au niveau des côtes.
  3. Repousser doucement ou replacer les bras loin devant et répéter. Compléter par le **Reverse Plank** (planche inversée jambes tendues, ouverture thoracique maximale).
  * *HUD Cues (2m)* : `"Écrase le sol"` · `"Tire avec les dorsaux"` · `"Épaules basses"`
* **Tempo recommandé** : `3-1-2-1` (phase concentrique de traction de 2s contre friction maximale).
* **Erreur fréquente à éviter** : S'aider avec les orteils au sol pour pousser avec les jambes au lieu de tracter avec les bras (garder les genoux fléchis ou les cous-de-pieds posés au sol).
* **Variante Mode Silencieux Appartement (0 saut)** : Glissement continu sans bruit (`< 25 dB`).
* **Variante Wrist/Knee-Friendly** : En *Sliding Floor Pull-up*, l'appui se fait sur toute la surface de l'avant-bras (poignet plat). En *Reverse Plank*, appuyer sur les avant-bras au lieu des mains tendues si les poignets sont sensibles.

#### `EX_PULL_T5` — Tier 5 (SpecOps) : Single-Arm Sliding Floor Pull & Pont Thoracique (*Thoracic Bridge*)
* **Muscles ciblés** :
  * *Agonistes primaires* : Grand dorsal unilatéral (`55 %`), Deltoïde postérieur & Trapèze inférieur (`25 %`).
  * *Synergistes & Stabilisateurs* : Obliques anti-rotation, Érecteurs du rachis et Fessiers (`20 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Single-Arm Sliding Floor Pull* : En procubitus, une main placée dans le bas du dos, l'autre bras tendu devant soi. Presser la main/avant-bras dans le sol et tracter l'ensemble du poids du corps avec un seul grand dorsal en empêchant toute rotation des épaules.
  2. *Thoracic Bridge* : Depuis la position quadrupédique inversée, pousser sur un bras et les deux pieds pour ouvrir la cage thoracique face au plafond, en engageant massivement toute la chaîne postérieure et la stabilité scapulaire unilatérale.
  * *HUD Cues (2m)* : `"Traction 1 Bras"` · `"Anti-rotation stricte"` · `"Ouverture thoracique"`
* **Tempo recommandé** : `3-1-2-1`.
* **Erreur fréquente à éviter** : Hyperextension lombaire compensatoire lors du Thoracic Bridge (concentrer l'extension dans le rachis thoracique T1–T12 en verrouillant les fessiers).
* **Variante Mode Silencieux Appartement (0 saut)** : Identique (`0 saut`).
* **Variante Wrist/Knee-Friendly** : Exécuter le *Single-Arm Floor Pull* sur l'avant-bras complet + *Supine Elbow Press Unilatéral* (1 seul coude au sol) pour une intensité maximale sans aucune pression sur le carpe.

---

### 2.3. Famille 3 : Membres Inférieurs & Puissance Locomotrice (*Tactical Legs*)

#### `EX_LEGS_T1` — Tier 1 (Recrue) : Assisted Tempo Squat & Bilateral Glute Bridge
* **Muscles ciblés** :
  * *Agonistes primaires* : Quadriceps fémoral (`45 %`), Grand fessier (`35 %`).
  * *Synergistes & Stabilisateurs* : Ischio-jambiers (`10 %`), Triceps sural et Érecteurs (`10 %`).
* **Consignes biomécaniques d'exécution** :
  1. Pieds largeur d'épaules, pointes ouvertes à `15°–30°`. Ancrer le trépied plantaire (talon, base du 1er et du 5e métatarsien).
  2. Initier le mouvement par un recul simultané des hanches et une flexion des genoux en poussant les genoux dans l'axe du 2e/3e orteil, descendre jusqu'à la parallèle (ou sur repère boîte/mur), remonter en contractant les fessiers.
  3. Enchaîner au sol avec le *Glute Bridge* (poussée dans les talons, rétroversion pelvienne en haut pendant `2s`).
  * *HUD Cues (2m)* : `"Genoux dans l'axe"` · `"Talons ancrés"` · `"Buste fier"`
* **Tempo recommandé** : `3-1-1-1`.
* **Erreur fréquente à éviter** : Valgus dynamique du genou (genoux qui rentrent vers l'intérieur) ou décollement des talons.
* **Variante Mode Silencieux Appartement (0 saut)** : Identique (`0 saut`).
* **Variante Wrist/Knee-Friendly** : En cas de syndrome fémoro-patellaire, effectuer un **Box Squat tibia vertical** (recul maximal des hanches pour transférer le moment de force des genoux vers la chaîne postérieure/fessiers) + *Glute Bridge isométrique*.

#### `EX_LEGS_T2` — Tier 2 (Soldat) : Military Air Squat Strict & Tactical Reverse Lunge
* **Muscles ciblés** :
  * *Agonistes primaires* : Quadriceps (`45 %`), Grand et Moyen fessiers (`35 %`).
  * *Synergistes & Stabilisateurs* : Ischio-jambiers (`10 %`), Adducteurs et Tibial antérieur (`10 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Military Air Squat* : Creux inguinal descendant sous le sommet de la rotule (*below parallel*), colonne vertébrale neutre sans rétroversion excessive (*butt wink*), remontée explosive contrôlée.
  2. *Tactical Reverse Lunge* : Reculer un pied d'un grand pas, descendre verticalement jusqu'à ce que les deux genoux forment un angle de `90°` (genou arrière effleurant le sol à `1 cm` sans choc), pousser dans le talon avant pour revenir pieds joints.
  * *HUD Cues (2m)* : `"Sous la parallèle"` · `"Deux angles à 90°"` · `"Pousse talon avant"`
* **Tempo recommandé** : `2-1-1-0`.
* **Erreur fréquente à éviter** : Poser violemment la rotule arrière au sol lors de la fente ou laisser le genou avant s'effondrer en médial.
* **Variante Mode Silencieux Appartement (0 saut)** : Posé du pied arrière amorti ("pas de félin") sans jamais heurter le sol avec le genou.
* **Variante Wrist/Knee-Friendly** : La **Fente Arrière (*Reverse Lunge*)** est déjà 40 % moins contraignante sur le tendon rotulien que la fente avant car le tibia avant reste quasi vertical. Pour une protection maximale : **Split Squat statique à amplitude contrôlée (`70°`)**.

#### `EX_LEGS_T3` — Tier 3 (Sous-Officier) : Tempo Pause Squat (`3-2-1-0`) & Single-Leg Glute Bridge
* **Muscles ciblés** :
  * *Agonistes primaires* : Quadriceps vaste médial/latéral (`40 %`), Grand fessier unilatéral (`35 %`), Ischio-jambiers (`15 %`).
  * *Synergistes & Stabilisateurs* : Moyen fessier (anti-chute pelvienne en unilatéral, `10 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Pause Squat* : Descente en `3 secondes`, arrêt total de `2 secondes` en bas du squat (en maintenant 100 % de la tension musculaire active, sans s'affaisser passivement sur les ménisques), remontée explosive en `1 seconde`.
  2. *Single-Leg Glute Bridge* : Sur le dos, une jambe fléchie contre la poitrine, pousser dans le talon d'appui pour aligner genou-hanche-épaule sans laisser la hanche libre vriller vers le bas.
  * *HUD Cues (2m)* : `"Pause active 2s"` · `"Bassin horizontal"` · `"Zéro rebond"`
* **Tempo recommandé** : `3-2-1-0` (Pause Squat) / `2-0-1-2` (Single-Leg Bridge).
* **Erreur fréquente à éviter** : Rebond balistique en bas du squat ou cambrure lombaire remplaçant l'extension de hanche sur le pont unilatéral.
* **Variante Mode Silencieux Appartement (0 saut)** : Remplace les *Jumping Lunges* ou *Jump Squats* par l'accélération concentrique maximale pieds collés au sol (**Speed Pause Squat**).
* **Variante Wrist/Knee-Friendly** : **Wall Sit (Chaise Romaine) unilatérale alternée** + **Single-Leg Glute Bridge** (stimulation maximale sans cisaillement articulaire dynamique).

#### `EX_LEGS_T4` — Tier 4 (Officier) : Cossack Squat & Isometric Hamstring Walkout
* **Muscles ciblés** :
  * *Agonistes primaires* : Quadriceps & Grand fessier de la jambe fléchie (`35 %`), Ischio-jambiers en contraction excentrique/isométrique (`35 %`), Adducteurs (`20 %`).
  * *Synergistes & Stabilisateurs* : Cheville (dorsiflexion complète) et stabilisateurs lombo-pelviens (`10 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Cossack Squat* : Pieds écartés à `2×` la largeur d'épaules. Descendre en squat complet sur la jambe gauche (talon gauche intégralement plaqué au sol) tandis que la jambe droite reste tendue, orteils droits pivotés vers le plafond. Transférer d'un côté à l'autre en restant bas.
  2. *Isometric Hamstring Walkout* : Depuis un Glute Bridge bassin haut, marcher sur les talons à petits pas de `10 cm` vers l'avant jusqu'à l'extension quasi complète des jambes (fessiers toujours décollés du sol), maintenir `2s`, puis revenir à petits pas sous les genoux.
  * *HUD Cues (2m)* : `"Talon d'appui au sol"` · `"Orteils opposés haut"` · `"Ischios sous tension"`
* **Tempo recommandé** : `3-1-2-0`.
* **Erreur fréquente à éviter** : Décoller le talon de la jambe porteuse en Cossack Squat ou laisser tomber les fessiers au sol pendant le Hamstring Walkout.
* **Variante Mode Silencieux Appartement (0 saut)** : Pas glissés/posés sur les talons sans aucun bruit d'impact.
* **Variante Wrist/Knee-Friendly** : Réduire la profondeur du Cossack Squat à `90°` de flexion et privilégier le **Hamstring Walkout** (qui renforce la chaîne postérieure protectrice du ligament croisé antérieur — LCA).

#### `EX_LEGS_T5` — Tier 5 (SpecOps) : Strict Pistol Squat & Shrimp Squat
* **Muscles ciblés** :
  * *Agonistes primaires* : Quadriceps unilatéral (`50 %`), Grand et Moyen fessiers (`30 %`).
  * *Synergistes & Stabilisateurs* : Fléchisseurs de hanche (psoas-iliaque et droit fémoral de la jambe libre en isométrie, `10 %`), Stabilisateurs de cheville (`10 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Strict Pistol Squat* : En équilibre sur un pied, tendre la jambe libre devant soi parallèle au sol. Descendre en `3 secondes` en gardant le talon d'appui collé au sol et le genou aligné sur les orteils jusqu'à la flexion complète, marquer `1s` de contrôle, puis remonter sans toucher le sol avec le pied libre.
  2. *Shrimp Squat* : Jambe libre fléchie derrière soi (tibias parallèles), descendre jusqu'à ce que le genou arrière effleure le sol derrière le talon avant, puis remonter.
  * *HUD Cues (2m)* : `"Jambe libre tendue"` · `"Talon verrouillé"` · `"Contrôle total"`
* **Tempo recommandé** : `3-1-1-1`.
* **Erreur fréquente à éviter** : Effondrement en valgus du genou au point bas du Pistol Squat ou chute libre sur les derniers `15 cm` d'amplitude.
* **Variante Mode Silencieux Appartement (0 saut)** : `100 %` silencieux (force lente pure).
* **Variante Wrist/Knee-Friendly** : **Touchdown Squat lent (excentrique 4s)** depuis une marche/support bas ou **Iso-Hold Split Squat unilatéral** (`45s` à `90°` de flexion) pour éliminer la compression méniscale en flexion extrême.

---

### 2.4. Famille 4 : Gainage Tactique & Anti-Rotation (*Iron Core*)

> [!NOTE]
> Conformément à la révision doctrinale **US Army FM 7-22 (H2F)** qui a aboli les sit-ups rapides pieds bloqués responsables de hernies discales L4-L5/L5-S1, la famille *Iron Core* privilégie l'anti-extension, l'anti-rotation et la flexion contrôlée du tronc.

#### `EX_CORE_T1` — Tier 1 (Recrue) : Dead Bug Strict & McGill Curl-up
* **Muscles ciblés** :
  * *Agonistes primaires* : Transverse de l'abdomen (`40 %`), Grand droit de l'abdomen (`35 %`).
  * *Synergistes & Stabilisateurs* : Obliques internes/externes (`15 %`), Fléchisseurs de hanche contrôlés (`10 %`).
* **Consignes biomécaniques d'exécution** :
  1. Sur le dos, bras tendus vers le plafond, hanches et genoux fléchis à `90°` (*tabletop*).
  2. **Écraser volontairement les lombaires contre le sol** (zéro espace entre le bas du dos et le tapis) en expirant fortement.
  3. Tendre lentement le bras droit derrière la tête et la jambe gauche à `5 cm` du sol sans jamais perdre le contact lombaire, revenir au centre et alterner.
  * *HUD Cues (2m)* : `"Lombaires plaquées"` · `"Expiration longue"` · `"Mouvement lent"`
* **Tempo recommandé** : `3-2-2-0` (3s extension, 2s maintien bas lombaires collées, 2s retour).
* **Erreur fréquente à éviter** : Laisser le bas du dos se cambrer lorsque la jambe s'allonge.
* **Variante Mode Silencieux Appartement (0 saut)** : Identique (`0 dB`).
* **Variante Wrist/Knee-Friendly** : Zéro appui sur les poignets ou les genoux (décubitus dorsal pur).

#### `EX_CORE_T2` — Tier 2 (Soldat) : RKC Plank & 4-Count Military Flutter Kicks
* **Muscles ciblés** :
  * *Agonistes primaires* : Grand droit et Transverse (`45 %`), Obliques (`20 %`).
  * *Synergistes & Stabilisateurs* : Grand dorsal (traction coudes), Quadriceps, Fessiers et Psoas-iliaque (`35 %`).
* **Consignes biomécaniques d'exécution** :
  1. *RKC Plank (Russian Kettlebell Challenge Plank)* : Sur les avant-bras, coudes sous les épaules, poings serrés. Tirer isométriquement les coudes vers les pointes de pieds et les pointes de pieds vers les coudes tout en contractant **à 100 %** les fessiers, les quadriceps et les abdominaux (tremblement neuromusculaire recherché dès `20s`).
  2. *4-Count Flutter Kicks* : Sur le dos, mains sous le sacrum ou décollant légèrement les omoplates (lombaires collées), jambes tendues battant alternativement de `15 à 45 cm` du sol sur 4 temps commandés (`1-2-3-1`).
  * *HUD Cues (2m)* : `"Tire coudes vers pieds"` · `"Fessiers à 100%"` · `"Lombaires au sol"`
* **Tempo recommandé** : `ISO` (RKC Plank par blocs de `20s–45s` de tension maximale) / `CADENCE 1-2-3-1` (Flutter Kicks).
* **Erreur fréquente à éviter** : Planche passive relâchée sur les ligaments lombaires ou Flutter Kicks jambes trop basses avec lordose lombaire marquée.
* **Variante Mode Silencieux Appartement (0 saut)** : Identique (`0 dB`, talons ne touchant jamais le sol).
* **Variante Wrist/Knee-Friendly** : Le RKC Plank s'exécute sur les avant-bras (zéro contrainte sur les poignets). Pour protéger les lombaires sur les Flutter Kicks, remonter l'angle de battement des jambes entre `45°` et `60°`.

#### `EX_CORE_T3` — Tier 3 (Sous-Officier) : Hollow Body Hold & Anti-Rotation Plank Shoulder Taps
* **Muscles ciblés** :
  * *Agonistes primaires* : Grand droit de l'abdomen sur toute sa longueur (`50 %`), Obliques internes/externes (`30 %`).
  * *Synergistes & Stabilisateurs* : Dentelé antérieur et Moyen fessier (`20 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Hollow Body Hold* : Sur le dos, lombaires soudées au sol, décoller les omoplates et tendre les bras derrière les oreilles ainsi que les jambes jointes à `30°` du sol (corps en arc de cercle rigide dit "banane gymnique").
  2. *Plank Shoulder Taps* : En planche haute, pieds écartés largeur d'épaules, toucher lentement l'épaule gauche avec la main droite pendant `2s` **sans que le bassin ne bouge d'un seul centimètre**.
  * *HUD Cues (2m)* : `"Bas du dos soudé"` · `"Hanches immobiles"` · `"Zéro balancier"`
* **Tempo recommandé** : `ISO` (Hollow Hold `30s–60s`) / `1-2-1-0` (Shoulder Taps avec pause de 2s sur 3 appuis).
* **Erreur fréquente à éviter** : Dandinements latéraux du bassin sur les Shoulder Taps ou décollement lombaire en Hollow Body.
* **Variante Mode Silencieux Appartement (0 saut)** : Identique (`0 dB`).
* **Variante Wrist/Knee-Friendly** : Remplacer les *Plank Shoulder Taps* sur les mains par le **Forearm Plank Reach** (sur les avant-bras, tendre alternativement un bras devant soi) pour supprimer l'appui sur le carpe.

#### `EX_CORE_T4` — Tier 4 (Officier) : Hollow Body Rocks, Tactical V-Ups & Copenhagen Plank
* **Muscles ciblés** :
  * *Agonistes primaires* : Grand droit & Psoas-iliaque (`45 %`), Obliques & Carré des lombes (`25 %`), Adducteurs de hanche en Copenhagen (`30 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Hollow Body Rocks* : Conserver la forme parfaite du Hollow Body et osciller d'avant en arrière sur l'arrondi du dos sans jamais casser l'angle hanches-épaules.
  2. *Tactical V-Ups* : Fermeture simultanée et contrôlée du buste et des jambes tendues en "V" en équilibre sur les ischions, descente freinée en `3s` jusqu'à la position Hollow (sans reposer talons ni épaules).
  * *HUD Cues (2m)* : `"Forme rigide"` · `"Équilibre ischions"` · `"Descente freinée 3s"`
* **Tempo recommandé** : `3-0-1-1`.
* **Erreur fréquente à éviter** : Casser le corps au milieu pendant le Hollow Rock (effet "planche plate" qui tape à plat sur les lombaires).
* **Variante Mode Silencieux Appartement (0 saut)** : Roulement fluide sur le rachis arrondi, sans bruit d'impact (`< 20 dB`).
* **Variante Wrist/Knee-Friendly** : Pour le *Copenhagen Plank* ou le *Side Plank*, placer l'appui sur l'avant-bras et le point de contact supérieur au-dessus du genou (sur le fémur distal) afin d'éviter tout cisaillement en valgus sur le ligament collatéral médial (LLI) du genou.

#### `EX_CORE_T5` — Tier 5 (SpecOps) : Floor L-Sit Hold & Shoulder-Anchored Dragon Flag
* **Muscles ciblés** :
  * *Agonistes primaires* : Grand droit de l'abdomen et Droit fémoral/Psoas en compression maximale (`55 %`), Abaisseurs scapulaires (Trapèze inférieur, Grand dorsal, Triceps, `30 %`).
  * *Synergistes & Stabilisateurs* : Ensemble de la sangle abdominale profonde (`15 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Floor L-Sit* : Assis jambes tendues jointes, paumes au sol à côté des cuisses. Pousser verticalement pour abaisser les épaules et **décoller intégralement les fessiers et les talons du sol** en formant un angle strict de `90°`.
  2. *Shoulder-Anchored Dragon Flag (No-Equipment)* : Allongé sur le dos, mains ancrées sous les fessiers ou pressant puissamment le sol de chaque côté des épaules (ou coudes plantés comme en Back Widow), monter en chandelle sur le haut des épaules, puis descendre le corps parfaitement droit (épaules-bassin-chevilles alignés) en `4 secondes` jusqu'à `10 cm` du sol.
  * *HUD Cues (2m)* : `"Dépression épaules"` · `"Angle 90° strict"` · `"Corps droit 4s"`
* **Tempo recommandé** : `ISO` (L-Sit par séries de `10s–30s`) / `4-1-2-0` (Dragon Flag excentrique contrôlé).
* **Erreur fréquente à éviter** : Appuyer sur la nuque (vertèbres cervicales C5–C7) au lieu de la ceinture scapulaire supérieure (trapèzes/deltoïdes postérieurs) lors du Dragon Flag.
* **Variante Mode Silencieux Appartement (0 saut)** : `100 %` silencieux (`0 dB`).
* **Variante Wrist/Knee-Friendly** : Exécuter le *L-Sit* sur les poings fermés (ce qui gagne en outre `4 cm` de hauteur de bras et protège le poignet) ou remplacer par le **Hollow Body Hold lesté par bras de levier maximal**.

---

### 2.5. Famille 5 : Conditionnement Métabolique & Locomotion (*MetCon*)

> [!TIP]
> Chaque exercice *MetCon* dispose d'une **équivalence énergétique certifiée Mode Silencieux Appartement (*Stealth Mode*)** activable en 1 clic sur le `WorkoutBriefingSheet`. L'intensité cardiovasculaire ($\text{FC} > 80\% \text{ FC}_{\max}$) est maintenue en remplaçant la phase aérienne de saut par une amplitude articulaire accrue et une cadence d'exécution élevée au sol.

#### `EX_METCON_T1` — Tier 1 (Recrue) : Step-Jacks & Squat-to-Reach
* **Muscles ciblés** :
  * *Agonistes primaires* : Deltoïdes & Coiffe des rotateurs (`30 %`), Quadriceps & Fessiers (`45 %`), Mollets (`25 %`).
* **Consignes biomécaniques d'exécution** :
  1. *Step-Jacks* : Déplacement latéral dynamique d'un pied après l'autre avec élévation complète des bras au-dessus de la tête en synchronisant la respiration.
  2. *Squat-to-Reach* : Demi-squat rythmé suivi d'une extension complète chevilles-genoux-hanches sur la pointe des pieds en tendant les bras vers le plafond.
  * *HUD Cues (2m)* : `"Amplitude complète"` · `"Extension pointes"` · `"Rythme continu"`
* **Tempo recommandé** : `CADENCE` (`1 répétition / 1.5s`).
* **Erreur fréquente à éviter** : Mouvements de bras incomplets ou apnée respiratoire.
* **Variante Mode Silencieux Appartement (0 saut)** : Mouvement natif **100 % sans saut** (`0 impact`).
* **Variante Wrist/Knee-Friendly** : Aucun appui sur les poignets ; amplitude de flexion des genoux modulable à `45°`.

#### `EX_METCON_T2` — Tier 2 (Soldat) : Military Jumping Jacks & Controlled Mountain Climbers
* **Muscles ciblés** :
  * *Agonistes primaires* : Système cardiorespiratoire, Triceps sural (`30 %`), Fléchisseurs de hanche & Abdominaux (`40 %`), Ceinture scapulaire (`30 %`).
* **Consignes biomécaniques d'exécution** :
  1. *4-Count Military Side Straddle Hop (Jumping Jack)* : Exécution stricte bras tendus, réception souple sur l'avant-pied avec légère flexion des genoux.
  2. *Mountain Climbers* : Position de planche haute, épaules à la verticale exacte des poignets, montée alternée des genoux vers la poitrine en gardant le bassin bas aligné avec les épaules.
  * *HUD Cues (2m)* : `"Épaules sur poignets"` · `"Bassin bas"` · `"Réception souple"`
* **Tempo recommandé** : `CADENCE` (haute vélocité contrôlée).
* **Erreur fréquente à éviter** : Monter les fesses en pyramide pendant les Mountain Climbers ou atterrir jambes raides talons au sol sur les Jumping Jacks.
* **Variante Mode Silencieux Appartement (0 saut)** :
  * Remplace les *Jumping Jacks* par du **Speed Shadow Boxing Tactique (Directs croisés haute cadence en garde basse Semi-Squat)** + **Silent Spider Climbers** (pied amené à l'extérieur de la main sans bruit d'impact).
* **Variante Wrist/Knee-Friendly** : **Forearm Plank Knee-to-Elbow** (Mountain Climber lent sur les avant-bras) ou **Standing High-Knee March rapide**.

#### `EX_METCON_T3` — Tier 3 (Sous-Officier) : 6-Count Military Burpee & Tactical Bear Crawl
* **Muscles ciblés** :
  * *Agonistes primaires* : Corps entier — Pectoraux/Triceps (`30 %`), Quadriceps/Fessiers (`35 %`), Gainage & Épaules (`35 %`).
* **Consignes biomécaniques d'exécution** :
  1. *6-Count Military Burpee* :
     * `Temps 1` : Squat mains à plat au sol devant les pieds.
     * `Temps 2` : Projection des pieds en planche haute verrouillée.
     * `Temps 3` : Flexion des coudes, poitrine au sol.
     * `Temps 4` : Extension complète des bras en planche.
     * `Temps 5` : Retour groupé des pieds à plat à l'extérieur des mains (dos plat).
     * `Temps 6` : Extension verticale complète (ou saut amorti).
  2. *Tactical Bear Crawl* : Quadrupédie genoux décollés à `3 cm` du sol, avancement/recul sur `2m` en opposition bras droit / jambe gauche, dos plat comme une table.
  * *HUD Cues (2m)* : `"6 Temps stricts"` · `"Pieds à plat Temps 5"` · `"Genoux à 3cm"`
* **Tempo recommandé** : `CADENCE 6-COUNT` (`~3.5s` par répétition).
* **Erreur fréquente à éviter** : Cambrer le bas du dos au `Temps 2` (impact lombaire) ou revenir sur la pointe des pieds genoux avancés au `Temps 5`.
* **Variante Mode Silencieux Appartement (0 saut)** : **Stealth 6-Count Step-Back Burpee** (recul et retour rapide d'un pied après l'autre + pompe stricte + extension sur pointes de pieds sans saut) & **Slow Bear Crawl**.
* **Variante Wrist/Knee-Friendly** : **Squat-to-Plank Walkout** (marche sur les mains vers l'avant puis retour en squat) ou Burpee mains surélevées / sur les poings.

#### `EX_METCON_T4` — Tier 4 (Officier) : 8-Count Navy SEAL Bodybuilder
* **Muscles ciblés** :
  * *Agonistes primaires* : Pectoraux, Triceps, Deltoïdes (`35 %`), Quadriceps, Fessiers, Adducteurs/Abducteurs (`35 %`), Gainage anti-extension & Obliques (`30 %`).
* **Consignes biomécaniques d'exécution** :
  Exécution séquentielle ultra-rigoureuse du standard **US Navy SEAL NSW PTG** :
  * `1` : Squat mains au sol · `2` : Jeté en planche · `3` : Descente pompe · `4` : Remontée pompe · `5` : **Plank Jack écarté** (ouverture des jambes en gardant la planche) · `6` : **Plank Jack serré** (retour pieds joints) · `7` : Retour pieds sous les hanches · `8` : Redressement complet au garde-à-vous.
  * *HUD Cues (2m)* : `"1-2-3-4 Pompe"` · `"5-6 Plank Jack"` · `"7-8 Debout strict"`
* **Tempo recommandé** : `CADENCE 8-COUNT` (`~4.5s` par répétition).
* **Erreur fréquente à éviter** : Affaissement du bassin pendant les temps `5` et `6` (Plank Jack).
* **Variante Mode Silencieux Appartement (0 saut)** : **Stealth 8-Count Bodybuilder** (Step-Back + Pompe + Step-Out latéral gauche/droit en planche + Step-In + Extension rapide sans saut).
* **Variante Wrist/Knee-Friendly** : Exécution sur les poings fermés (*Knuckle 8-Count*) avec transition en Step-Back/Step-In pour protéger les poignets et les ménisques.

#### `EX_METCON_T5` — Tier 5 (SpecOps) : Devil Burpee (Double Push-up + Tuck) & Speed Bear Crawl
* **Muscles ciblés** :
  * *Agonistes primaires* : Chaîne antérieure et postérieure complète sous dette d'oxygène élevée ($\text{VO}_2\max$ & tolérance lactique).
* **Consignes biomécaniques d'exécution** :
  1. Squat mains au sol, jeté en planche, **2 Strict Push-ups consécutives** (`Temps 3-4-5-6`), retour explosif des pieds à plat, saut groupé genoux hauts (*Tuck Jump*) avec réception ultra-amortie en demi-squat.
  2. Enchaînement immédiat en **Speed Bear Crawl avant/arrière** sur `2m`.
  * *HUD Cues (2m)* : `"Double Pompe stricte"` · `"Explosivité hanches"` · `"Réception féline"`
* **Tempo recommandé** : `EXPLOSIVE CONTROL`.
* **Erreur fréquente à éviter** : Dégrader la forme de la seconde pompe ou atterrir jambes tendues après le saut groupé.
* **Variante Mode Silencieux Appartement (0 saut)** : **Silent SpecOps Burpee** : Step-Back rapide + **1 Military Push-up + 1 Pike Push-up + 2 Mountain Climbers** + retour en **Prisoner Pause Squat** (sollicitation métabolique identique au Tuck Jump avec `0 dB` d'impact au sol).
* **Variante Wrist/Knee-Friendly** : **No-Impact Bear Crawl + Double Knuckle Push-up + Tempo Air Squat** (zéro impact patellaire, poignets neutres).

---

## 3. Structure Détaillée des 5 Formats de Routines Simples ("Zero-Friction Workouts")

Toutes les séances générées par **MakeFit** respectent l'architecture physiologique **US Army H2F** :
1. **Bloc RAMP Warm-up (2 à 3 min)** : *Raise, Activate, Mobilize, Potentiate* (Rotations articulaires, Cat-Cow thoracique, Glute Bridge d'activation, Scapular Push-ups).
2. **Corps de Séance Opérationnel (Format 1 à 5 ci-dessous)** avec respect strict de l'équilibre **Poussée / Tirage sans barre**.
3. **Bloc H2F Cooldown & Box Breathing (1 à 2 min)** : Décompression articulaire + respiration tactique `4s Inspiration - 4s Apnée - 4s Expiration - 4s Apnée` pour activer le système nerveux parasympathique.

---

### Format 1 : "Flash PT" (`5 minutes` — Réveil Opérationnel & Protection de Streak)
* **Objectif physiologique** : Lubrification synoviale matinale, potentiation neuromusculaire (*Grease the Groove*) sans fatigue nerveuse centrale, validation de l'habitude quotidienne en 300 secondes.
* **Structure chronométrée exacte (`300s`, 0 temps mort)** :

| Minute | Bloc Biomécanique | Exercice (Adapté au Tier $k$ du soldat) | Temps d'Effort | Transition / Resp. |
| :---: | :--- | :--- | :---: | :---: |
| **Min 1** | Mobilité Thoracique & Hanches | World's Greatest Stretch + Cat-Cow | `50s` | `10s` |
| **Min 2** | Chaîne Postérieure (`PULL`) | Exercice `EX_PULL_Tk` (ex: *Prone I-Y-T-W*) | `45s` | `15s` |
| **Min 3** | Poussée Haut du Corps (`PUSH`) | Exercice `EX_PUSH_Tk` (ex: *Military Push-ups*) | `45s` | `15s` |
| **Min 4** | Membres Inférieurs (`LEGS`) | Exercice `EX_LEGS_Tk` (ex: *Air Squats + Lunges*) | `45s` | `15s` |
| **Min 5** | Gainage Tactique (`CORE`) | Exercice `EX_CORE_Tk` (ex: *RKC Plank*) | `45s` | `15s` (Debrief) |

---

### Format 2 : "EMOM Opérationnel" (`10, 15 ou 20 minutes` — *Every Minute On the Minute*)
* **Objectif physiologique** : Densité mécanique auto-régulée sous contrainte temporelle. Au bip `00s` de chaque minute, l'utilisateur exécute son quota exact de répétitions $Q_i$. S'il termine en `32s`, il dispose de `28s` de récupération active avant la minute suivante.
* **Règle de sécurité biomécanique** : Le quota $Q_i$ est calibré pour occuper `30s à 40s` d'effort (soit un ratio Effort/Repos de `1:1` à `2:1`). Si le temps restant tombe sous `10s` deux minutes de suite, le moteur propose une réduction automatique de `-2 reps` pour préserver la technique.
* **Architecture Binaire (10 ou 16 min) & Ternaire (15 ou 21 min)** :
  * *Minute 1 (A — Poussée + Gainage)* : $Q_{\text{push}}$ répétitions de `EX_PUSH_Tk` + `15s` de `EX_CORE_Tk`.
  * *Minute 2 (B — Tirage Sans Barre + Jambes)* : $Q_{\text{pull}}$ répétitions de `EX_PULL_Tk` + $Q_{\text{legs}}$ répétitions de `EX_LEGS_Tk`.
  * *Minute 3 (C — Conditionnement Métabolique, en mode Ternaire)* : $Q_{\text{metcon}}$ répétitions de `EX_METCON_Tk`.

| Niveau du Soldat | Quota $Q_{\text{push}}$ (`PUSH`) | Quota $Q_{\text{pull}}$ (`PULL`) | Quota $Q_{\text{legs}}$ (`LEGS`) | Quota $Q_{\text{metcon}}$ (`METCON`) |
| :--- | :---: | :---: | :---: | :---: |
| **Tier 1 (Recrue)** | `8–10 reps` | `8–10 reps` | `10–12 reps` | `8 reps` (Step-Jacks) |
| **Tier 2 (Soldat)** | `12–15 reps` | `12–15 reps` | `15–18 reps` | `8 reps` (6-Count / Climbers) |
| **Tier 3 (Sous-Officier)** | `12–16 reps` | `12–16 reps` | `14–16 reps` | `10 reps` (6-Count Burpees) |
| **Tier 4 (Officier)** | `10–14 reps` (Archer) | `12–15 reps` (Floor Pull) | `12–14 reps` (Cossack) | `10 reps` (8-Count SEAL) |
| **Tier 5 (SpecOps)** | `6–10 reps` (One-Arm/HSPU) | `10–12 reps` (1-Arm Pull) | `8–10 reps` (Pistol) | `10 reps` (Devil Burpee) |

---

### Format 3 : "AMRAP Haute Densité" (`12, 15 ou 18 minutes` — *As Many Rounds As Possible*)
* **Objectif physiologique** : Endurance musculaire locale et capacité aérobie/anaérobie mixte. L'utilisateur enchaîne le maximum de tours complets d'un circuit équilibré de **4 stations complémentaires** dans le temps imparti, en gérant librement ses micro-pauses.
* **Structure Standard d'un Tour (1 Round)** :
  1. **Station 1 (`PUSH`)** : $R_1$ répétitions (ex: `10 Military Push-ups`)
  2. **Station 2 (`PULL`)** : $R_2$ répétitions (ex: `10 Supine Elbow Presses / Prone Y-T-W` — garantit le ratio `1:1` Push/Pull !)
  3. **Station 3 (`LEGS`)** : $R_3$ répétitions (ex: `15 Air Squats`)
  4. **Station 4 (`CORE` ou `METCON`)** : $R_4$ répétitions (ex: `20 4-Count Flutter Kicks` ou `8 Burpees`)
* **Formule de Score Opérationnel AMRAP** :
  $$\text{Score}_{\text{AMRAP}} = N_{\text{tours}} + \frac{\sum_{j=1}^{k} r_j}{\sum_{i=1}^{4} R_i}$$
  *(Ex : 6 tours complets + 10 Push-ups + 5 Elbow Presses sur un tour de 55 reps totales = `6.27 Rounds`, permettant de battre son record personnel à la répétition près).*

---

### Format 4 : "Pyramide Tactique" (*Tactical Ladder `1 → N → 1`*, `15 à 25 minutes`)
* **Objectif physiologique** : Hypertrophie sarcoplasmique et résilience mentale (classique du *NSW Physical Training Guide* des Navy SEALs). L'échauffement progressif est intégré dans les premiers barreaux de l'échelle, le pic métabolique est atteint au sommet $N$, et la redescente sous pré-fatigue recrute les unités motrices à haut seuil.
* **Loi des Multiplicateurs Biomécaniques (`1 : 2 : 3 : 4`)** :
  Pour chaque échelon $k \in \{1, 2, \dots, N, N-1, \dots, 1\}$ de la pyramide :
  * **Mouvement 1 (`METCON` ou `PULL` lourd)** : $1 \times k$ répétitions (ou $2 \times k$ pour `PULL` postural)
  * **Mouvement 2 (`PUSH`)** : $2 \times k$ répétitions
  * **Mouvement 3 (`LEGS`)** : $3 \times k$ répétitions
  * **Mouvement 4 (`CORE`)** : $4 \times k$ répétitions
* **Volume Total Mathématique d'une Pyramide Symétrique $1 \to N \to 1$** :
  La somme des coefficients d'une montée-descente complète jusqu'au sommet $N$ vaut exactement $N^2$ :
  $$\sum_{k=1}^{N} k + \sum_{k=1}^{N-1} k = \frac{N(N+1)}{2} + \frac{(N-1)N}{2} = N^2$$
  Ainsi, pour un coefficient multiplicateur $m \in \{1, 2, 3, 4\}$, le volume total d'un exercice sur la séance est :
  $$V_{\text{total}}(m, N) = m \cdot N^2$$

| Niveau Cible | Sommet $N$ | Multiplicateur $N^2$ | Total `METCON/PULL` ($1\times N^2$) | Total `PUSH` ($2\times N^2$) | Total `LEGS` ($3\times N^2$) | Total `CORE` ($4\times N^2$) | Repos Inter-Échelon |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Tier 1 (Recrue)** | $N = 5$ | `25` | `25 reps` | `50 reps` | `75 reps` | `100 reps` | `20s–30s` |
| **Tier 2 (Soldat)** | $N = 6$ | `36` | `36 reps` | `72 reps` | `108 reps` | `144 reps` | `20s–35s` |
| **Tier 3 (Sous-Officier)** | $N = 7$ | `49` | `49 reps` | `98 reps` | `147 reps` | `196 reps` | `25s–40s` |
| **Tier 4 (Officier)** | $N = 8$ | `64` | `64 reps` | `128 reps` | `192 reps` | `256 reps` | `30s–45s` |
| **Tier 5 (SpecOps)** | $N = 10$ | `100` | `100 reps` | `200 reps` | `300 reps` | `400 reps` | `Auto-régulé` |

---

### Format 5 : "Tabata HIIT / Intervalle Opérationnel" (`40s/20s` ou `20s/10s`, `12 à 20 minutes`)
* **Objectif physiologique** : Puissance aérobie maximale ($\text{VO}_2\max$) et exécution **100 % "Eyes-Free / Hands-Free"** guidée uniquement par les bips d'Audio Ducking (`3-2-1-GO`) et les impulsions haptiques.
* **Deux protocoles d'intervalles** :
  1. **Protocole Tactique Standard (`40s Effort / 20s Repos`)** : Idéal pour maintenir un tempo biomécanique propre (`2-1-1-0`) sans dégradation technique.
  2. **Protocole Tabata Supra-Maximal (`20s Effort Max / 10s Repos` × 8 cycles = `4:00` par bloc, `60s` de repos entre les blocs)** : Réservé aux exercices à cycle court (`Mountain Climbers`, `Air Squats`, `Shadow Boxing`, `Flutter Kicks`, `Prone Swimmers`).
* **Séquence de Rotation Anti-Fatigue Locale (4 Stations × 3 à 4 Tours = 12 à 16 min)** :
  * `Intervalle 1` : `PUSH` (`40s` Effort / `20s` Repos)
  * `Intervalle 2` : `PULL` (`40s` Effort / `20s` Repos)
  * `Intervalle 3` : `LEGS` (`40s` Effort / `20s` Repos)
  * `Intervalle 4` : `CORE` ou `METCON` (`40s` Effort / `20s` Repos)

---

## 4. Formules Mathématiques Exactes : Test PT Initial (6 min) & Algorithme RPE (1 à 5)

### 4.1. Protocole & Équations du Test PT Initial (*Baseline Qualification Test — 6 Minutes*)

Lors de l'onboarding (ou lors d'un *Promotion Trial*), le soldat exécute un test chronométré de **6 minutes (`360s`)** composé de 3 épreuves fondamentales :
1. **Bloc 1 (`0:00 – 2:00`) — Force-Endurance de Poussée ($R_{\text{push}}$)** :
   * Nombre maximal de **Military Strict Push-ups** en `120s` (pause autorisée uniquement en position de planche haute).
   * *Option Knee/Incline Push-ups* : Si l'utilisateur choisit la variante assistée (`EX_PUSH_T1`), un coefficient de pondération $\alpha_{\text{push}} = 0.55$ est appliqué aux répétitions brutes : $R_{\text{push}}^{\text{eff}} = \alpha_{\text{push}} \cdot R_{\text{push}}^{\text{brut}}$ (sinon $\alpha_{\text{push}} = 1.0$).
2. **Bloc 2 (`2:00 – 4:00`) — Force-Endurance des Membres Inférieurs ($R_{\text{squat}}$)** :
   * Nombre maximal d'**Air Squats complets sous la parallèle** en `120s`.
3. **Bloc 3 (`4:00 – 6:00`) — Gainage Anti-Extension ($T_{\text{plank}}$)** :
   * Temps maximal de maintien en **RKC / Strict Forearm Plank** (en secondes, plafonné à $T_{\max} = 120\text{ s}$ dans le format compact de 6 minutes, ou $180\text{ s}$ lors des examens de promotion SpecOps).

#### Normalisation Mathématique des Sous-Scores ($[0, 100]$)
Chaque performance brute est convertie en un score normalisé sur `100 points` via une fonction de saturation bornée calibrée sur les barèmes **US Army ACFT / USMC PFT / NSW PTG** :

$$S_{\text{push}} = \min\left(100,\; \text{round}\left(100 \times \left(\frac{R_{\text{push}}^{\text{eff}}}{60}\right)^{0.85}\right)\right)$$

$$S_{\text{legs}} = \min\left(100,\; \text{round}\left(100 \times \left(\frac{R_{\text{squat}}}{80}\right)^{0.85}\right)\right)$$

$$S_{\text{core}} = \min\left(100,\; \text{round}\left(100 \times \left(\frac{T_{\text{plank}}}{120}\right)^{0.90}\right)\right)$$

*(Exposants $< 1$ permettant une sensibilité discriminative élevée chez les débutants tout en exigeant `60 Push-ups`, `80 Squats` et `120s Plank` pour atteindre le score parfait de `100/100`).*

#### Calcul de l'Indice d'Aptitude Opérationnelle Global ($\text{IAO}$)
$$\text{IAO} = \text{round}\Big(0.35 \cdot S_{\text{push}} + 0.35 \cdot S_{\text{legs}} + 0.30 \cdot S_{\text{core}}\Big) \in [0, 100]$$

#### Attribution Automatique des Échelons Biomécaniques ($\text{Tier } 1 \dots 5$)
Pour éviter qu'un utilisateur fort du bas du corps mais débutant en poussée ne soit bloqué, **MakeFit** attribue un échelon spécifique par famille $\text{Tier}(f)$ ainsi qu'un échelon global :
* $\text{Tier}(\text{PUSH}) = \tau(S_{\text{push}})$
* $\text{Tier}(\text{LEGS}) = \tau(S_{\text{legs}})$
* $\text{Tier}(\text{CORE}) = \tau(S_{\text{core}})$
* $\text{Tier}(\text{PULL}) = \min\big(\text{Tier}(\text{PUSH}),\; \tau(\text{IAO})\big)$ *(sécurité posturale scapulaire)*
* $\text{Tier}(\text{METCON}) = \tau(\text{IAO})$

Où la fonction de seuillage discret $\tau(S)$ est définie par :

$$\tau(S) = \begin{cases} 
1 \quad (\text{Tier 1 — Recrue}) & \text{si } 0 \le S < 25 \\[4pt]
2 \quad (\text{Tier 2 — Soldat}) & \text{si } 25 \le S < 50 \\[4pt]
3 \quad (\text{Tier 3 — Sous-Officier}) & \text{si } 50 \le S < 75 \\[4pt]
4 \quad (\text{Tier 4 — Officier}) & \text{si } 75 \le S < 90 \\[4pt]
5 \quad (\text{Tier 5 — SpecOps}) & \text{si } 90 \le S \le 100
\end{cases}$$

| Indice $\text{IAO}$ | Échelon Attribué | Repères Bruts Équivalents (`2 min Push` / `2 min Squat` / `Plank`) | Grade Initial Débloqué |
| :---: | :--- | :--- | :--- |
| **`0 – 24`** | **Tier 1 — Recrue** | `< 11 Push-ups` · `< 16 Squats` · `< 26s Plank` | `E-1 Private (Recrue)` |
| **`25 – 49`** | **Tier 2 — Soldat** | `11–26 Push-ups` · `16–35 Squats` · `26s–55s Plank` | `E-2 Private First Class` |
| **`50 – 74`** | **Tier 3 — Sous-Officier** | `27–42 Push-ups` · `36–56 Squats` · `56s–87s Plank` | `E-3 Corporal (Caporal)` |
| **`75 – 89`** | **Tier 4 — Officier** | `43–53 Push-ups` · `57–70 Squats` · `88s–106s Plank` | `E-3 Corporal` *(Campagne Avancée ouverte)* |
| **`90 – 100`** | **Tier 5 — SpecOps** | `≥ 54 Push-ups` · `≥ 71 Squats` · `≥ 107s Plank` | `E-3 Corporal` *(Accès SpecOps déverrouillé)* |

---

### 4.2. Algorithme Mathématique d'Auto-Régulation RPE (Échelle Simplifiée `1 à 5`)

À l'issue de chaque séance ($n$), l'utilisateur sélectionne sur le `MissionDebriefScreen` son **RPE Simplifié** $r_n \in \{1, 2, 3, 4, 5\}$ ainsi que son taux de complétion réel $C_n = \frac{V_{\text{réalisé}}}{V_{\text{cible}}} \in [0, 1.5]$.

#### 1. Équation d'Adaptation du Volume de Répétitions ($R_{n+1}$) et du Temps Isométrique ($T_{n+1}$)
Soit $R_n$ le quota de répétitions par série à la séance $n$ et $T_n$ la durée de maintien isométrique (en secondes) :

$$R_{n+1} = \text{clamp}\Big(\text{round}\big(R_n \cdot (1 + \gamma(r_n, C_n)) + \delta(r_n, C_n)\big),\; R_{\min},\; R_{\max}\Big)$$

$$T_{n+1} = \text{clamp}\Big(\text{round}\big(T_n \cdot (1 + \gamma(r_n, C_n))\big),\; 15\text{ s},\; 90\text{ s}\Big)$$

Où les coefficients d'adaptation $\gamma(r_n, C_n)$ (facteur multiplicatif), $\delta(r_n, C_n)$ (incrément linéaire minimal) et $\Delta_{\text{rest}}(r_n)$ (ajustement du temps de repos inter-séries) sont définis par la matrice déterministe suivante :

| Score RPE ($r_n$) | Libellé Opérationnel HUD | Facteur $\gamma(r_n, C_n)$ | Incrément $\delta(r_n, C_n)$ | Ajustement Repos $\Delta_{\text{rest}}$ | Action du Moteur (`AdaptiveProgressionEngine`) |
| :---: | :--- | :---: | :---: | :---: | :--- |
| **`RPE = 1`** | *Trop Facile / Échauffement* ($C_n \ge 1.0$) | **$+0.15$** (`+15 %`) | $+2\text{ reps}$ | $-5\text{ s}$ | Surcharge rapide $+15\%$ (minimum $+2\text{ reps}$). Si $r_{n-1} \le 2$ également $\Rightarrow$ **Promotion immédiate au $\text{Tier } k+1$**. |
| **`RPE = 2`** | *Confortable / Réserve Importante* ($C_n \ge 1.0$) | **$+0.10$** (`+10 %`) | $+1\text{ rep}$ | $-5\text{ s}$ | Progression soutenue $+10\%$ (minimum $+1\text{ rep}$). |
| **`RPE = 3`** | *Optimal / Effort Solide* ($C_n \ge 0.90$) | **$+0.05$** (`+5 %`) | $+1\text{ rep}$ | $0\text{ s}$ | **Zone cible H2F** : Surcharge progressive nominale ($+1$ à $+2\text{ reps}$ par série). |
| **`RPE = 4`** | *Très Dur / Limite Technique* ($C_n \ge 0.80$) | **$0.00$** (`0 %`) | $0\text{ rep}$ | $+5\text{ s}$ | **Consolidation neuromusculaire** : Maintien exact du volume $R_{n+1} = R_n$ et ajout de $+5\text{ s}$ de repos pour consolider les tendons. |
| **`RPE = 5`** | *Échec / Épuisement* (ou $C_n < 0.80$) | **$-0.20$** (`-20 %`) | $-2\text{ reps}$ | $+15\text{ s}$ | **Tactical Deload automatique** : Réduction de $-20\%$ du volume à la séance suivante + recommandation d'une séance *Flash PT / Mobilité H2F*. |

#### 2. Loi de Promotion et de Rétrogradation d'Échelon ($\text{Tier } k \leftrightarrow \text{Tier } k \pm 1$)
Chaque famille biomécanique $f \in \{\text{PUSH}, \text{PULL}, \text{LEGS}, \text{CORE}, \text{METCON}\}$ possède un plafond de maîtrise $R_{\text{mastery}}(f, k)$ (typiquement `18 reps` par série pour les mouvements bilatéraux, `10 reps` par côté pour les mouvements unilatéraux, ou `60s` pour les isométries) :

1. **Condition d'Upgrade ($\text{Tier } k \to \text{Tier } k+1$, avec $k < 5$)** :
   $$\text{Upgrade}(f) \iff \Big(R_{n+1}(f) \ge R_{\text{mastery}}(f, k) \;\land\; r_n \le 3\Big) \;\lor\; \Big(r_n = 1 \;\land\; r_{n-1} \le 2 \;\land\; C_n = 1.0\Big)$$
   Lors du passage au $\text{Tier } k+1$, le quota initial de répétitions du nouvel exercice plus difficile est initialisé à :
   $$R_{\text{init}}(f, k+1) = \text{round}\big(0.55 \times R_{\text{mastery}}(f, k)\big)$$
   *(Transition douce : passer de `18 Military Push-ups` Tier 2 à `10 Diamond/Pike Push-ups` Tier 3).*

2. **Condition de Régression Protectrice ($\text{Tier } k \to \text{Tier } k-1$, avec $k > 1$)** :
   $$\text{Downgrade}(f) \iff \Big(r_n = 5 \;\land\; r_{n-1} = 5\Big) \;\lor\; \Big(C_n < 0.65\Big) \;\lor\; \Big(\text{TriggerAdaptationDouleur}(f) = \text{true}\Big)$$
   Si l'utilisateur subit deux échecs consécutifs ($\text{RPE } 5$) ou active le bouton d'adaptation articulaire, le moteur bascule vers la variante sécurisée avec un volume de relance fixé à $0.75 \times R_{\text{mastery}}(f, k-1)$.

#### 3. Indice d'Équilibre Postural Push / Pull ($\mathcal{B}_{\text{postural}}$)
Sur une fenêtre glissante des 7 derniers jours, le moteur calcule le ratio de volume effectif :
$$\mathcal{B}_{\text{postural}} = \frac{\sum_{d=1}^{7} V_{\text{PULL}}(d)}{\sum_{d=1}^{7} V_{\text{PUSH}}(d)}$$
* **Cible Santé Optimale** : $\mathcal{B}_{\text{postural}} \in [0.85,\; 1.15]$.
* **Correction Automatique** : Si $\mathcal{B}_{\text{postural}} < 0.85$ (déficit de chaîne postérieure), le générateur de mission quotidienne injecte automatiquement $+1$ série de `EX_PULL_Tk` (*Prone I-Y-T-W* ou *Supine Elbow Press*) dans le bloc d'échauffement RAMP et dans le corps de séance suivant.

---

## 5. Modèle de Données Dart Immuable Prêt pour l'Implémentation (`@Carbon`)

Cette structure garantit une intégration directe avec **0 friction** dans `lib/src/domain/models/exercise_model.dart` et `lib/src/data/catalogs/military_exercises_catalog.dart` :

```dart
enum BiomechanicalFamily {
  upperPush,
  noBarPull,
  tacticalLegs,
  ironCore,
  metCon,
}

enum DifficultyTier {
  tier1Recruit,    // Échelon 1
  tier2Soldier,    // Échelon 2
  tier3Nco,        // Échelon 3
  tier4Officer,    // Échelon 4
  tier5SpecOps,    // Échelon 5
}

enum WorkoutFormatType {
  flashPt5Min,
  emomOperational,
  amrapHighDensity,
  tacticalPyramid,
  tabataHiit,
}
```
