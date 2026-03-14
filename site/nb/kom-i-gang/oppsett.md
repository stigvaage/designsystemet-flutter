# Oppsett

## Installer pakken

Legg til biblioteket i `pubspec.yaml`:

```yaml
dependencies:
  komponentbibliotek_flutter: ^1.0.0
```

Kjør deretter:

```bash
flutter pub get
```

## Importer biblioteket

Den enkleste måten er å importere alt samlet:

```dart
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
```

## Granulære importer

For bedre tree-shaking kan du importere kun det du trenger:

```dart
// Kun tema
import 'package:komponentbibliotek_flutter/theme.dart';

// Kun komponenter
import 'package:komponentbibliotek_flutter/components.dart';

// Kun typografi
import 'package:komponentbibliotek_flutter/typography.dart';
```

Dette gir mindre app-størrelse ved å ekskludere ubrukt kode.
