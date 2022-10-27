import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'package:ft_hangouts/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';
import 'dart:io';

class contactPage extends StatefulWidget {
  final ValueNotifier<bool> updater;
  final String contactId;

  contactPage(this.contactId, this.updater);

  @override
  State<contactPage> createState() => contactPageState();
}

class contactPageState extends State<contactPage> {
  Contact? _contact;
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  String? base64image;
  @override
  void initState() {
    databaseController.instance
        .getContactFromId(widget.contactId)
        .then((value) {
      setState(() {
        _contact = new Contact(
            id: value[0]['id'],
            firstName: value[0]['firstName'],
            lastName: value[0]['lastName'],
            phoneNumber: value[0]['phoneNumber'],
            profilePicture: value[0]['profilePicture']);
        firstNameController.text = _contact!.firstName!;
        lastNameController.text = _contact!.lastName!;
        phoneNumberController.text = _contact!.phoneNumber!;
        base64image = value[0]['profilePicture'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_contact != null) {
      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, true),
            ),
            title: Text(_contact!.firstName! + ' ' + _contact!.lastName!)),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            physics: BouncingScrollPhysics(),
            child: Column(children:[
              GestureDetector(
                onTap: () async {
                     File? croppedImage = await imageHelper.uploadImage();
                     if (croppedImage != null) {
                       setState(() {
                        var imagePicked = croppedImage;
                         _contact!.setProfilePicture(imageHelper.base64String(imagePicked.readAsBytesSync()));
                       });
                     }
                   },
                child: CircleAvatar(
                  radius:80,
                  backgroundColor: globalColor.value.shade900,
                  child: CircleAvatar(
                    radius:75,
                    backgroundImage: imageHelper.imageFromBase64String(_contact!.profilePicture!).image
                  )
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return AppLocalizations.of(context)!.firstNameEmpty;
                  return null;
                },
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.firstName,
                    border: OutlineInputBorder(),
                    hintText: _contact!.firstName!),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.lastName,
                    border: OutlineInputBorder(),
                    hintText: _contact!.lastName!),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: phoneNumberController,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r"^0\d{9}$").hasMatch(value))
                    return AppLocalizations.of(context)!.phoneNumberFormat;
                  return null;
                },
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.phoneNumber,
                    border: OutlineInputBorder(),
                    hintText: _contact!.phoneNumber!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Contact updatedContact = Contact(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          phoneNumber: phoneNumberController.text,
                          profilePicture: _contact!.profilePicture,
                          id: _contact?.id);
                      databaseController.instance
                          .updateContact(updatedContact)
                          .then((value) {
                        initState();
                        widget.updater.value = !widget.updater.value;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  AppLocalizations.of(context)!.updateDone)),
                        );
                      });
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.saveChange)),
              ElevatedButton(
                child: Text(AppLocalizations.of(context)!.deleteContact),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        color: Color.fromARGB(255, 193, 193, 193),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                  child: Text(AppLocalizations.of(context)!.no),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              ElevatedButton(
                                  child:
                                      Text(AppLocalizations.of(context)!.yes),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    databaseController.instance
                                        .deleteContact(_contact!)
                                        .then((value) {
                                      widget.updater.value =
                                          !widget.updater.value;
                                      int count = 0;
                                      Navigator.popUntil(context, (route) {
                                        return count++ == 2;
                                      });
                                    });
                                  }),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],),
          ),
        ),
      );
    }
    return Scaffold();
  }
}

// ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Processing Data')),
//                   );
