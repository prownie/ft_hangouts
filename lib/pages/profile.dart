import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ft_hangouts/database_controller.dart';
import 'package:flutter/material.dart';
import 'package:ft_hangouts/utils/shared_preferences.dart';
import '../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  late Color _pickedColor;
  late String _selectedLocale;

  List<Color> availableColors = [
    Colors.yellow,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.orange
  ];
  @override
  void initState() {
    _pickedColor = globalColor.value;
    _selectedLocale = globalLocale.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(AppLocalizations.of(context)!.changeThemeColor),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 50,
                childAspectRatio: 1 / 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemCount: availableColors.length,
            itemBuilder: (context, index) {
              final itemColor = availableColors[index];
              return InkWell(
                onTap: () {
                  sharedPrefHelper.setFavColor(itemColor).then((value) {
                    globalColor.value = value;
                    setState(() {
                      _pickedColor = itemColor;
                    });
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: itemColor,
                      shape: BoxShape.circle,
                      border:
                          Border.all(width: 1, color: Colors.grey.shade300)),
                  child: itemColor.value == _pickedColor.value
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        )
                      : Container(),
                ),
              );
            },
          ),
        ),
        Text(AppLocalizations.of(context)!.changeLocale),
        DropdownButton(
            value: _selectedLocale != "" ? _selectedLocale : "None",
            icon: const Icon(Icons.arrow_downward_rounded),
            // elevation: 16,
            style: TextStyle(color: globalColor.value.shade900),
            underline: Container(height: 2, color: globalColor.value.shade50),
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem(
                child: Text('fr'),
                value: 'fr',
              ),
              DropdownMenuItem(
                child: Text('en'),
                value: 'en',
              ),
              DropdownMenuItem(
                child: Text(AppLocalizations.of(context)!.phoneLanguage),
                value: "None",
              ),
            ],
            onChanged: (value) {
              sharedPrefHelper.setFavLocale(value!).then((value) {
                globalLocale.value = value;
                MaterialColor tmp = globalColor.value;
                globalColor.value = Colors.grey;
                globalColor.value = tmp;
                setState(() {
                  _selectedLocale = value;
                });
              });
            })
      ],
    );
  }
}
