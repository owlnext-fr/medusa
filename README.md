# medusa

Package Flutter/Dart pour créer des tickets Mantis depuis l’application.

## Installation

Ajoutez `medusa` à vos dépendances puis importez la lib :

```dart
import 'package:medusa/medusa.dart';
```

## Initialisation

Initialisez la lib une fois au démarrage de l’app.

```dart
Medusa.initialize(
	baseUrl: 'https://mantis.example.com/api/rest',
	token: 'YOUR_MANTIS_TOKEN',
	project: 'MyProject',
	category: 'General',
	browser: 'Chrome',
	os: 'Android',
	device: 'Pixel 8',
	environment: 'production',
);
```

Paramètres de `Medusa.initialize` :

- `baseUrl` *(requis, MantisBT)* : URL API REST de l’instance MantisBT.
	- Exemple : `https://mantis.example.com/api/rest`
	- Où la trouver : URL de votre instance MantisBT (ajouter `/api/rest`).

- `token` *(requis, MantisBT)* : token API utilisé pour l’authentification.
	- Où le trouver : paramètres du compte utilisateur technique Mantis (profil utilisateur).

- `project` *(requis, MantisBT)* : nom exact du projet cible.
	- Où le trouver : liste des projets MantisBT.

- `category` *(requis, MantisBT)* : nom exact de la catégorie du ticket.
	- Où la trouver : catégories dans la configuration du projet MantisBT.

- `browser` *(optionnel, contexte app)* : navigateur côté client (si applicable).

- `os` *(optionnel, contexte app)* : système d’exploitation du device.

- `device` *(optionnel, contexte app)* : nom/modèle du device.

- `environment` *(optionnel, MantisBT/app)* : valeur envoyée dans le champ custom `c_environment`.
	- Soit une chaîne libre (si votre champ custom l’accepte),
	- soit une valeur d’énum définie dans la config du champ custom `c_environment`.

- `debugCallback` *(optionnel, app)* : callback de debug de l’API (logs/événements réseau).

## Envoi d’un ticket

Crée un ticket et attache automatiquement une capture (`screenshot.png`).

```dart
final issueId = await Medusa.createIssue(
	path: '/checkout/payment',
	summary: 'Crash au clic sur Payer',
	issueDescription: 'L’application se ferme après validation du formulaire.',
	stepToReproduce: '1. Ouvrir checkout\n2. Saisir carte\n3. Cliquer sur Payer',
	expectedBehavior: 'Le paiement est validé et l’écran de confirmation s’affiche.',
	severity: 'major',
	fileData: screenshotBytes, // Uint8List
);
```

Paramètres de `Medusa.createIssue` :

- `path` *(requis, contexte app)* : chemin/route de l’écran où l’erreur a eu lieu.
	- Ajouté automatiquement dans la description du ticket.

- `summary` *(requis, MantisBT)* : titre court du ticket.

- `issueDescription` *(requis, MantisBT)* : description détaillée du problème.

- `stepToReproduce` *(requis, nullable, MantisBT)* : étapes de reproduction.
	- Peut être `null`, mais l’argument doit être fourni lors de l’appel.

- `expectedBehavior` *(requis, nullable, MantisBT)* : comportement attendu.
	- Peut être `null`, mais l’argument doit être fourni lors de l’appel.

- `severity` *(requis, MantisBT)* : sévérité MantisBT.
	- Doit correspondre à une valeur acceptée par votre configuration MantisBT.
	- Où la trouver : dans les niveaux de sévérité disponibles sur un ticket MantisBT (liste proposée dans le champ **Severity**) et/ou dans la configuration des énumérations d'attributs MantisBT utilisée par votre instance.

- `fileData` *(requis, app)* : bytes de la capture d’écran (`Uint8List`).
	- La capture est envoyée en pièce jointe sous le nom `screenshot.png`.

Contenu construit automatiquement dans la description finale :
- `issueDescription`
- `path`
- `stepToReproduce`
- `expectedBehavior`

Paramètres MantisBT réutilisés automatiquement à l’envoi :
- `project` et `category` (définis dans `Medusa.initialize`).
- `browser`, `os`, `device`, `environment` (si fournis à l’initialisation).

Exemple de vérification d’API avant envoi :

```dart
final isApiReachable = await Medusa.ping();
if (!isApiReachable) {
	// gérer l’indisponibilité de Mantis
}
```

Paramètres de `Medusa.ping` :
- Aucun paramètre.
- Retourne `true` si l’API MantisBT est joignable.

## Widgets frontend

### MedusaCaptureButtonWidget
Widget qui sert de déclencheur pour capturer l'écran. 

Description :

Peut être placé n'importe où dans l'application.
Déclenche une capture d'écran si un MedusaScreenerPanel est présent dans l'arborescence des widgets.
Affiche un bouton cliquable pour déclencher la capture.

Utilisation :
```dart
MedusaCaptureButtonWidget()
```

### MedusaScreenerPanelWidget:

Widget principal qui encapsule la partie de l'interface à capturer. Il gère la capture d'écran et l'affichage du panneau latéral.

Description :

Doit être placé à un niveau élevé dans l'arborescence des widgets (par exemple, dans le Layout, les pages principales, ou le widget racine).
Capture toute l'arborescence des widgets enfants.
Attention : Ne pas utiliser plusieurs MedusaScreenerPanel dans le même arbre de widgets. Un seul MedusaScreenerPanel est autorisé.

Utilisation :
```dart
MedusaScreenerPanelWidget(
	routerFullPath: GoRouterState.of(context).fullPath, //For GoRouter routing implementations
    child: ...YourWidgetTreeToCapture(),
)
```



