import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'utils/utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

ValueNotifier<MaterialColor> globalColor = ValueNotifier(Colors.grey);
ValueNotifier<String> globalLocale = ValueNotifier("");
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  globalColor.value = await sharedPrefHelper.getFavColor();
  globalLocale.value = await sharedPrefHelper.getFavLocale();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: globalColor,
      builder: (context, value, _) {
        return MaterialApp(
          locale:
              !globalLocale.value.isEmpty ? Locale(globalLocale.value) : null,
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''), // English, no country code
            Locale('fr', ''), // Spanish, no country code
          ],
          theme: ThemeData(
              // brightness: Brightness.dartk
              scaffoldBackgroundColor: Colors.grey.shade800,
              primarySwatch: globalColor.value),
          title: 'ft_hangouts',
          color: globalColor.value,
          home: HomePage(),
        );
      },
    );
  }
}
