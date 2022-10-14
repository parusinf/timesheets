import 'package:flutter/widgets.dart';

String getLocale(
  BuildContext context, {
  Locale? selectedLocale,
}) {
  if (selectedLocale != null) {
    return '${selectedLocale.languageCode}_${selectedLocale.countryCode}';
  }
  final locale = Localizations.localeOf(context);
  return '${locale.languageCode}_${locale.countryCode}';
}
