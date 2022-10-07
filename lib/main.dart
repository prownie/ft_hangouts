import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

ValueNotifier<MaterialColor> globalColor = ValueNotifier(Colors.grey);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: globalColor,
      builder: (context, value, _) {
        return MaterialApp(
          theme: ThemeData(
              // brightness: Brightness.dartk
              primarySwatch: globalColor.value),
          title: 'ft_hangouts',
          color: globalColor.value,
          home: HomePage(),
        );
      },
    );
  }
}
