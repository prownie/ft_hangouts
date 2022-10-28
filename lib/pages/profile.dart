import 'package:flutter/material.dart';
import 'package:ft_hangouts/utils/utils.dart';
import '../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  late Color _pickedColor;
  late String _selectedLocale;
  late String _profilePicture;
  late String _profilPicturePlaceHolder;

  List<Color> availableColors = [
    Colors.yellow,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.orange,
  ];
  @override
  void initState() {
    _pickedColor = globalColor.value;
    _selectedLocale = globalLocale.value;
  }

  Future<void> initProfilePicture() async {
    _profilePicture = await sharedPrefHelper.getFavProfilePicture();
    _profilPicturePlaceHolder = await imageHelper.base64placeHolder();
    if (_profilePicture.isEmpty) {
      _profilePicture = await imageHelper.base64placeHolder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initProfilePicture(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SizedBox.shrink();
          } else {
            return OrientationBuilder(builder: (context, orientation) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          Image.asset("assets/images/backgroundHangouts.jpeg")
                              .image,
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        child: Column(children: [
                      Text(AppLocalizations.of(context)!.changeThemeColor,
                          style: TextStyle(
                            height: 2,
                          )),
                      SizedBox(
                        height: 54,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      orientation == Orientation.portrait
                                          ? 50
                                          : 40,
                                  childAspectRatio: 1 / 1,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 10),
                          itemCount: availableColors.length,
                          itemBuilder: (context, index) {
                            final itemColor = availableColors[index];
                            return InkWell(
                              onTap: () {
                                sharedPrefHelper
                                    .setFavColor(itemColor)
                                    .then((value) {
                                  globalColor.value = value;
                                  setState(() {
                                    _pickedColor = itemColor;
                                  });
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: itemColor,
                                  shape: BoxShape.circle,
                                ),
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
                      )
                    ])),
                    Spacer(),
                    Container(
                      color: Colors.grey[400],
                      height: 0.5,
                    ),
                    Spacer(),
                    Container(
                        child: Row(children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          File? croppedImage = await imageHelper.uploadImage();
                          if (croppedImage != null) {
                            setState(() {
                              var imagePicked = croppedImage;
                              sharedPrefHelper.setFavProfilePicture(
                                  imageHelper.base64String(
                                      croppedImage.readAsBytesSync()));
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: orientation == Orientation.portrait ? 60 : 32,
                          backgroundColor: globalColor.value.shade900,
                          child: CircleAvatar(
                              radius:
                                  orientation == Orientation.portrait ? 58 : 30,
                              backgroundImage: imageHelper
                                  .imageFromBase64String(_profilePicture)
                                  .image),
                        ),
                      ),
                      _profilePicture != _profilPicturePlaceHolder
                          ? IconButton(
                              padding: const EdgeInsets.all(4.0),
                              onPressed: () async {
                                setState(() {
                                  sharedPrefHelper.setFavProfilePicture(
                                      _profilPicturePlaceHolder);
                                  _profilePicture = _profilPicturePlaceHolder;
                                });
                              },
                              color: globalColor.value.shade700,
                              icon: Icon(Icons.delete),
                            )
                          : SizedBox.shrink(),
                      Spacer(),
                    ])),
                    Spacer(),
                    Container(
                      color: Colors.grey[400],
                      height: 0.5,
                    ),
                    Spacer(),
                    Container(
                      child: Column(
                        children: [
                          Text(AppLocalizations.of(context)!.changeLocale),
                          DropdownButton(
                              value: _selectedLocale != ""
                                  ? _selectedLocale
                                  : "None",
                              icon: const Icon(Icons.arrow_downward_rounded),
                              // elevation: 16,
                              style:
                                  TextStyle(color: globalColor.value.shade900),
                              underline: Container(
                                  height: 2, color: globalColor.value.shade50),
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
                                  child: Text(AppLocalizations.of(context)!
                                      .phoneLanguage),
                                  value: "None",
                                ),
                              ],
                              onChanged: (value) {
                                sharedPrefHelper
                                    .setFavLocale(value!)
                                    .then((value) {
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
                      ),
                    ),
                  ],
                ),
              );
            });
          }
        });
  }
}
