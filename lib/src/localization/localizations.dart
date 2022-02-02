import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Loc {
  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context)!;
}

extension LocalizationsExt on BuildContext {
  AppLocalizations loc() => AppLocalizations.of(this)!;
}
