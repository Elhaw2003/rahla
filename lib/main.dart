import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/core/di/dependency_injection.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await setupGetIt();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      startLocale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
      useOnlyLangCode: true,
      child: const App(),
    ),
  );
}
