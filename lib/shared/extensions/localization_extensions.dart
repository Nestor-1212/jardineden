// ─────────────────────────────────────────────────────────────────────────────
// shared/extensions/localization_extensions.dart
//
// RESPONSABILIDAD:
//   Extensiones de BuildContext que simplifican el acceso al sistema de
//   internacionalización. En lugar de escribir AppLocalizations.of(context)
//   en cada widget, los widgets usan context.l10n directamente.
//
// USO EN WIDGETS:
//   ```dart
//   Text(context.l10n.appTitle)
//   Text(context.l10n.authWelcomeTitle)
//   Text(context.l10n.verseCount(myVerses.length))
//   ```
//
// DEPENDENCIAS PERMITIDAS:   flutter/material.dart, l10n/generated/.
// DEPENDENCIAS PROHIBIDAS:   features, core, otros módulos shared.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/l10n/generated/app_localizations.dart';

export 'package:jardindeleden/l10n/generated/app_localizations.dart';

/// Extensión que expone AppLocalizations directamente desde BuildContext.
///
/// Uso: `context.l10n.appTitle` en lugar de `AppLocalizations.of(context).appTitle`
extension LocalizationContext on BuildContext {
  /// Acceso directo al objeto AppLocalizations del contexto actual.
  ///
  /// Equivale a `AppLocalizations.of(context)` pero más ergonómico.
  /// No puede ser null porque MaterialApp.localizationsDelegates incluye
  /// AppLocalizations.delegate.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Código ISO 639-1 del idioma activo. Ejemplo: 'es', 'en', 'pt'
  String get languageCode => Localizations.localeOf(this).languageCode;

  /// Locale completo activo. Ejemplo: Locale('es'), Locale('en')
  Locale get locale => Localizations.localeOf(this);
}
