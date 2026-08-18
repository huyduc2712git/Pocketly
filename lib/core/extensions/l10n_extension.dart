import 'package:flutter/widgets.dart';
import 'package:finly/l10n/generated/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      throw StateError(
        'No AppLocalizations found in BuildContext. Ensure MaterialApp includes localizationsDelegates and supportedLocales.',
      );
    }
    return localizations;
  }
}
